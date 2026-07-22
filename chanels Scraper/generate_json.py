import re
import json
import base64
import urllib.parse
import urllib.request

def decode_base64_url(url):
    """
    Extract and decode the base64 encoded stream parameter from a URL.
    """
    url_only = url.split('|')[0]
    match = re.search(r'[?&]stream=([^&]+)', url_only)
    if not match:
        return None
        
    stream_b64 = match.group(1)
    if '%' in stream_b64:
        stream_b64 = urllib.parse.unquote(stream_b64)
        
    stream_b64 = stream_b64.replace(' ', '+')
    
    missing_padding = len(stream_b64) % 4
    if missing_padding:
        stream_b64 += '=' * (4 - missing_padding)
        
    try:
        decoded_bytes = base64.b64decode(stream_b64)
        decoded_url = decoded_bytes.decode('utf-8')
        return decoded_url
    except Exception as e:
        return None

def parse_m3u(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    channels = []
    current_channel = None

    for line in lines:
        line = line.strip()
        if not line:
            continue

        if line.startswith('#EXTINF:'):
            logo = ''
            logo_match = re.search(r'tvg-logo="([^"]+)"', line)
            if logo_match:
                logo = logo_match.group(1)

            group = ''
            group_match = re.search(r'group-title="([^"]+)"', line)
            if group_match:
                group = group_match.group(1)

            name = ''
            parts = line.split(',')
            if len(parts) > 1:
                name = parts[-1].strip()
            else:
                name = line

            current_channel = {
                'name': name,
                'logo': logo if logo else None,
                'group': group,
                'kodiprops': [],
                'url': None
            }
        elif line.startswith('#KODIPROP:'):
            if current_channel is not None:
                current_channel['kodiprops'].append(line)
        elif line.startswith('#') and not line.startswith('#EXTM3U'):
            pass
        elif line.startswith('http://') or line.startswith('https://'):
            if current_channel is not None:
                current_channel['url'] = line
                channels.append(current_channel)
                current_channel = None

    return channels

def slugify(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s\-]', '', text)
    text = re.sub(r'[\s\-]+', '-', text)
    return text.strip('-')

def clean_category(group_name):
    """
    Extract a clean category name and id from group-title.
    e.g. "Cricket: Lanka Premier League" -> "Cricket"
    """
    if not group_name:
        return "Other", "other"
    parts = group_name.split(':')
    category_name = parts[0].strip()
    category_id = slugify(category_name)
    return category_name, category_id

def process_channels(parsed_channels):
    processed = []
    seen_ids = set()

    for idx, ch in enumerate(parsed_channels):
        name = ch['name']
        group = ch['group']
        
        # Don't skip any channel to get a complete scrape
        base_id = slugify(name)
        if not base_id:
            base_id = f"channel-{idx}"
        
        ch_id = base_id
        counter = 1
        orig_ch_id = ch_id
        while ch_id in seen_ids:
            ch_id = f"{orig_ch_id}-{counter}"
            counter += 1
        seen_ids.add(ch_id)

        worker_url = ch['url']
        direct_url = decode_base64_url(worker_url)
        
        headers = {}
        
        # Extract headers from both URLs
        def extract_headers_from_string(s):
            if '|' in s:
                header_str = s.split('|')[1]
                for pair in header_str.split('&'):
                    if '=' in pair:
                        k, v = pair.split('=', 1)
                        headers[k] = urllib.parse.unquote(v)

        extract_headers_from_string(worker_url)
        if direct_url:
            extract_headers_from_string(direct_url)
            direct_url = direct_url.split('|')[0]
            
        worker_url = worker_url.split('|')[0]

        drm = None
        drm_system = None
        for prop in ch['kodiprops']:
            prop = prop.replace('#KODIPROP:', '').strip()
            if '=' in prop:
                k, v = prop.split('=', 1)
                if k == 'inputstream.adaptive.license_type':
                    drm_system = v
                elif k == 'inputstream.adaptive.license_key':
                    if ':' in v:
                        kid, key = v.split(':', 1)
                        drm = {
                            'type': drm_system if drm_system else 'clearkey',
                            'kid': kid.strip(),
                            'key': key.strip()
                        }
                elif k == 'inputstream.adaptive.stream_headers':
                    for pair in v.split('&'):
                        if '=' in pair:
                            hk, hv = pair.split('=', 1)
                            headers[hk] = urllib.parse.unquote(hv)

        # Set default drm system if drm is parsed but drm_system wasn't set earlier
        if drm and not drm_system:
            drm_system = 'clearkey'

        category_name, category_id = clean_category(group)

        processed.append({
            'id': ch_id,
            'name': name,
            'logo': ch['logo'],
            'category': category_name,
            'category_id': category_id,
            'group': group,
            'stream_url': direct_url if direct_url else worker_url,
            'worker_url': worker_url,
            'resolution': 'HD',
            'proxy': True,
            'headers': headers if headers else None,
            'drmSystem': drm_system,
            'drm': drm
        })

    return processed

def main():
    print("Reading and parsing 995xon.m3u...")
    ch_list = parse_m3u('995xon.m3u')
    proc_list = process_channels(ch_list)
    
    # 1. Save flat channel list
    flat_output_path = 'cricfy_channels.json'
    with open(flat_output_path, 'w', encoding='utf-8') as f:
        json.dump(proc_list, f, indent=2, ensure_ascii=False)
    print(f"Saved flat channel list to {flat_output_path} ({len(proc_list)} channels)")

    # 2. Save grouped channel list (matching the structure of chanel.json)
    grouped_channels = {}
    for ch in proc_list:
        cat_id = ch['category_id']
        cat_name = ch['category']
        
        if cat_id not in grouped_channels:
            grouped_channels[cat_id] = {
                'name': cat_name,
                'channels': []
            }
            
        # Structure the channel object for the grouped output
        ch_item = {
            'id': ch['id'],
            'name': ch['name'],
            'url': ch['stream_url'],
            'worker_url': ch['worker_url'],
            'logo': ch['logo'],
            'resolution': ch['resolution'],
            'proxy': ch['proxy']
        }
        
        if ch['headers']:
            ch_item['headers'] = ch['headers']
        if ch['drmSystem']:
            ch_item['drmSystem'] = ch['drmSystem']
        if ch['drm']:
            # For legacy/compatibility: we keep type inside drm, or just kid and key
            ch_item['drm'] = {
                'kid': ch['drm']['kid'],
                'key': ch['drm']['key']
            }
            
        grouped_channels[cat_id]['channels'].append(ch_item)

    grouped_output_path = 'cricfy_channels_grouped.json'
    with open(grouped_output_path, 'w', encoding='utf-8') as f:
        json.dump(grouped_channels, f, indent=2, ensure_ascii=False)
    print(f"Saved grouped channels to {grouped_output_path} ({len(grouped_channels)} categories)")

if __name__ == '__main__':
    main()
