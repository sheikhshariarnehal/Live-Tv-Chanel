import re
import json
import base64
import urllib.parse

def decode_base64_url(url):
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

def process_channels(parsed_channels):
    processed = []
    seen_ids = set()
    for idx, ch in enumerate(parsed_channels):
        name = ch['name']
        group = ch['group']
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
                            'kid': kid.strip(),
                            'key': key.strip()
                        }
                elif k == 'inputstream.adaptive.stream_headers':
                    for pair in v.split('&'):
                        if '=' in pair:
                            hk, hv = pair.split('=', 1)
                            headers[hk] = urllib.parse.unquote(hv)
        processed.append({
            'id': ch_id,
            'name': name,
            'logo': ch['logo'],
            'group': group,
            'url': direct_url if direct_url else worker_url,
            'worker_url': worker_url,
            'resolution': 'HD',
            'proxy': True,
            'headers': headers if headers else None,
            'drmSystem': drm_system,
            'drm': drm
        })
    return processed

if __name__ == '__main__':
    ch_list = parse_m3u('995xon.m3u')
    proc_list = process_channels(ch_list)
    
    drm_count = sum(1 for ch in proc_list if ch['drm'] is not None)
    headers_count = sum(1 for ch in proc_list if ch['headers'] is not None)
    groups = set(ch['group'] for ch in proc_list)
    
    print(f"Total parsed: {len(ch_list)}")
    print(f"Channels with DRM: {drm_count}")
    print(f"Channels with headers: {headers_count}")
    print(f"Categories ({len(groups)}):")
    for g in sorted(groups):
        print(f"  - {g}")
