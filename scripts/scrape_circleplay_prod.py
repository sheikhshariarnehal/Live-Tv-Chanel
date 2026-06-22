import requests
from bs4 import BeautifulSoup
import re
import urllib.parse
import base64
import urllib3
import json
import time
import os
import shutil
import sys

# Reconfigure stdout/stderr to use UTF-8 to prevent console encoding crashes on Windows
sys.stdout.reconfigure(encoding='utf-8')
sys.stderr.reconfigure(encoding='utf-8')

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

base_url = "https://circleplay.top"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Referer": base_url + "/"
}

session = requests.Session()

def decrypt_payload(script_content):
    match_func = re.search(r"eval\(unescape\('([^']+)'\)\)", script_content)
    if not match_func:
        return None, "No function definition found"
        
    func_js = urllib.parse.unquote(match_func.group(1))
    
    delim_match = re.search(r'\.split\((?:"([^"]+)"|\'([^\']+)\')\)', func_js)
    if not delim_match:
        return None, "No delimiter found in function"
    delimiter = delim_match.group(1) or delim_match.group(2)
    
    suffix_match = re.search(r'\+\s*(?:"([^"]+)"|\'([^\']+)\')', func_js)
    if not suffix_match:
        return None, "No suffix found in function"
    suffix = suffix_match.group(1) or suffix_match.group(2)
    
    # Precise offset check
    offset = 0
    math_match = re.search(r'\)\+([+-]?[0-9]+)\)', func_js)
    if math_match:
        offset = int(math_match.group(1))
    else:
        math_match = re.search(r'\)-([+-]?[0-9]+)\)', func_js)
        if math_match:
            offset = -int(math_match.group(1))
            
    payload_match = re.search(rf"'([^']*{delimiter}[^']*)'", script_content)
    if not payload_match:
        payload_match = re.search(rf'"([^"]*{delimiter}[^"]*)"', script_content)
        
    if not payload_match:
        return None, f"No payload containing delimiter '{delimiter}' found"
        
    enc_payload = payload_match.group(1)
    parts = enc_payload.split(delimiter)
    if len(parts) < 2:
        return None, "Payload split failed"
        
    s = urllib.parse.unquote(parts[0], encoding='latin1')
    k = urllib.parse.unquote(parts[1] + suffix, encoding='latin1')
    
    decrypted = ""
    for i in range(len(s)):
        k_char = k[i % len(k)]
        xor_val = int(k_char) ^ ord(s[i])
        decrypted += chr((xor_val + offset) & 0xffff)
        
    return decrypted, None

def parse_stream_info(html_content):
    # Try standard patterns
    manifest_match = re.search(r'const\s+manifestUri\s*=\s*["\']([^"\']+)["\']', html_content)
    if not manifest_match:
        manifest_match = re.search(r'streamUrl\s*=\s*new\s+URL\(["\']([^"\']*)["\']\)', html_content)
    if not manifest_match:
        manifest_match = re.search(r'source\s*:\s*["\']([^"\']+)["\']', html_content)
        
    stream_url = manifest_match.group(1) if manifest_match else None
    
    # Check for base64 encoded streams in window.atob / atob
    if not stream_url:
        atob_match = re.search(r'(?:window\.)?atob\([\'"]([a-zA-Z0-9+/=]+)[\'"]\)', html_content)
        if atob_match:
            try:
                decoded = base64.b64decode(atob_match.group(1)).decode('utf-8', errors='ignore')
                if decoded.startswith('http') and ('.m3u8' in decoded or '.mpd' in decoded):
                    stream_url = decoded
            except Exception:
                pass
                
    drm_keys = {}
    clear_keys_match = re.search(r'clearKeys\s*:\s*\{([^}]+)\}', html_content)
    if clear_keys_match:
        pairs = re.findall(r'["\']([a-fA-F0-9]{32})["\']\s*:\s*["\']([a-fA-F0-9]{32})["\']', clear_keys_match.group(1))
        for kid, key in pairs:
            drm_keys[kid] = key
            
    if not drm_keys:
        key_id_match = re.search(r'keyId\s*:\s*["\']([a-fA-F0-9]{32})["\']', html_content)
        key_match = re.search(r'key\s*:\s*["\']([a-fA-F0-9]{32})["\']', html_content)
        if key_id_match and key_match:
            drm_keys[key_id_match.group(1)] = key_match.group(1)
            
    return stream_url, drm_keys

def resolve_page(url, headers, depth=0):
    if depth > 4:
        return {"status": "error", "message": "Max depth exceeded"}
        
    try:
        res = session.get(url, headers=headers, verify=False, timeout=10)
        if res.status_code != 200:
            return {"status": "error", "message": f"HTTP {res.status_code} on {url}"}
            
        if "offline.php" in res.url:
            return {"status": "offline", "message": "Channel is offline"}
            
        soup = BeautifulSoup(res.text, 'html.parser')
        
        # 1. Check for scripts on current page
        stream_url, drm_keys = parse_stream_info(res.text)
        if stream_url:
            return {
                "status": "success",
                "stream_url": urllib.parse.urljoin(url, stream_url),
                "drm_keys": drm_keys,
                "source": "plain_script",
                "iframe_url": url
            }
            
        scripts = soup.find_all('script')
        for s in scripts:
            content = s.string or ""
            if "eval(unescape" in content:
                decrypted, err = decrypt_payload(content)
                if not err and decrypted:
                    stream_url, drm_keys = parse_stream_info(decrypted)
                    if stream_url:
                        return {
                            "status": "success",
                            "stream_url": urllib.parse.urljoin(url, stream_url),
                            "drm_keys": drm_keys,
                            "source": "decrypted_script",
                            "iframe_url": url
                        }
                        
        # 2. Check for iframe
        iframe = soup.find('iframe')
        if iframe:
            iframe_src = iframe.get('src')
            if iframe_src:
                if iframe_src.startswith('/'):
                    next_url = base_url + iframe_src
                else:
                    next_url = iframe_src
                
                next_headers = headers.copy()
                next_headers["Referer"] = url
                return resolve_page(next_url, next_headers, depth + 1)
                
        # 3. Check for json references (auto-start) - ONLY if auto-start is in the URL
        if "auto-start.php" in url:
            json_match = re.search(r"id=(\d+)", url)
            if json_match:
                json_url = f"{base_url}/json/{json_match.group(1)}.json"
                json_res = session.get(json_url, headers=headers, verify=False, timeout=10)
                if json_res.status_code == 200:
                    data = json_res.json()
                    stream_url = data.get('stream_url')
                    if stream_url:
                        if stream_url.startswith('/'):
                            next_url = base_url + stream_url
                        else:
                            next_url = stream_url
                        if "offline.php" in next_url:
                            return {"status": "offline", "message": "Channel is offline"}
                        next_headers = headers.copy()
                        next_headers["Referer"] = url
                        return resolve_page(next_url, next_headers, depth + 1)
                        
        return {"status": "unknown", "message": "Could not find stream URL"}
    except Exception as e:
        return {"status": "error", "message": str(e)}

def clean_id(name):
    # Generates a slug-friendly ID, prepending circleplay-
    clean = re.sub(r'[^a-zA-Z0-9\s-]', '', name).strip().lower()
    clean = re.sub(r'[\s-]+', '-', clean)
    return f"circleplay-{clean}"

def main():
    print("Fetching circleplay.top homepage...")
    res = session.get(base_url, headers=headers, verify=False, timeout=15)
    soup = BeautifulSoup(res.text, 'html.parser')
    
    live_links = soup.find_all('a', href=re.compile(r'^/live/'))
    channels = []
    seen_hrefs = set()
    
    for a in live_links:
        href = a.get('href')
        if href in seen_hrefs:
            continue
        seen_hrefs.add(href)
        
        img = a.find('img')
        name = img.get('alt') if img else a.text.strip()
        logo = img.get('src') if img else ''
        if logo and logo.startswith('../'):
            logo = "https://circleplay.top/" + logo.replace('../', '')
            
        channels.append({
            "name": name,
            "path": href,
            "logo": logo
        })
        
    print(f"Discovered {len(channels)} unique channels.")
    
    successful_channels = []
    
    for idx, ch in enumerate(channels):
        print(f"[{idx+1}/{len(channels)}] Resolving: {ch['name']} ({ch['path']})...")
        time.sleep(0.5) # Gentle delay
        
        info = resolve_page(base_url + ch['path'], headers)
        if info['status'] == 'success':
            print(f"    -> SUCCESS: {info['stream_url']}")
            # Format according to channels.json schema
            ch_id = clean_id(ch['name'])
            ch_data = {
                "id": ch_id,
                "name": f"CirclePlay {ch['name']}",
                "url": info['stream_url'],
                "logo": ch['logo']
            }
            if info['drm_keys']:
                kid = list(info['drm_keys'].keys())[0]
                key = info['drm_keys'][kid]
                ch_data["drm"] = {
                    "kid": kid,
                    "key": key
                }
            successful_channels.append(ch_data)
        else:
            print(f"    -> FAILED: {info.get('message', 'unknown status')}")
            
    print(f"\nSuccessfully resolved {len(successful_channels)} channels out of {len(channels)}.")
    
    # Save the custom circleplay-only output
    output_path = "public/assets/data/circleplay_channels.json"
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(successful_channels, f, indent=2, ensure_ascii=False)
    print(f"Saved circleplay-only channels to {output_path}")
    
    # Now merge into e:\Poject\Live-Tv-Chanel\public\assets\data\channels.json
    channels_json_path = "public/assets/data/channels.json"
    if os.path.exists(channels_json_path):
        # Create a backup
        backup_path = channels_json_path + ".bak"
        shutil.copyfile(channels_json_path, backup_path)
        print(f"Created backup of channels.json at {backup_path}")
        
        try:
            with open(channels_json_path, 'r', encoding='utf-8') as f:
                channels_data = json.load(f)
                
            if "categories" in channels_data and "sports" in channels_data["categories"]:
                existing_sports = channels_data["categories"]["sports"].get("channels", [])
                
                # Check for duplicates by ID or URL
                existing_ids = {ch.get('id') for ch in existing_sports}
                
                added_count = 0
                for new_ch in successful_channels:
                    if new_ch['id'] not in existing_ids:
                        existing_sports.append(new_ch)
                        added_count += 1
                        existing_ids.add(new_ch['id'])
                        
                channels_data["categories"]["sports"]["channels"] = existing_sports
                
                with open(channels_json_path, 'w', encoding='utf-8') as f:
                    json.dump(channels_data, f, indent=2, ensure_ascii=False)
                    
                print(f"Successfully merged {added_count} new channels into '{channels_json_path}' under 'sports' category!")
            else:
                print("Error: Could not find 'categories' or 'sports' key in channels.json. Skipping merge.")
        except Exception as e:
            print(f"Error merging with channels.json: {e}")
    else:
        print("channels.json not found, skipping merge.")

if __name__ == '__main__':
    main()
