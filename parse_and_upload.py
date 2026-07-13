import re
import json
import urllib.parse

def slugify(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s\-]', '', text)
    text = re.sub(r'[\s\-]+', '-', text)
    return text.strip('-')

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

def process_channels(parsed_channels):
    processed = []
    seen_ids = set()

    for idx, ch in enumerate(parsed_channels):
        name = ch['name']
        
        if 'telegram' in name.lower() or 'facebook' in name.lower() or 'join' in name.lower():
            continue
        if ch['group'] == '📢 SOCIAL MEDIA':
            continue

        match_title = ""
        if "(" in ch['group'] and ")" in ch['group']:
            match_title_match = re.search(r'\(([^)]+)\)', ch['group'])
            if match_title_match:
                match_title = match_title_match.group(1)

        final_name = name
        if match_title:
            final_name = f"{match_title} | {name}"

        base_id = slugify(final_name)
        if not base_id:
            base_id = f"channel-{idx}"
        
        ch_id = f"{base_id}-reborn"
        counter = 1
        orig_ch_id = ch_id
        while ch_id in seen_ids:
            ch_id = f"{orig_ch_id}-{counter}"
            counter += 1
        seen_ids.add(ch_id)

        url_part = ch['url']
        headers = {}
        
        if '|' in url_part:
            parts = url_part.split('|')
            url_part = parts[0]
            header_str = parts[1]
            for pair in header_str.split('&'):
                if '=' in pair:
                    k, v = pair.split('=', 1)
                    headers[k] = urllib.parse.unquote(v)

        drm = None
        for prop in ch['kodiprops']:
            prop = prop.replace('#KODIPROP:', '').strip()
            if '=' in prop:
                k, v = prop.split('=', 1)
                if k == 'inputstream.adaptive.license_type' and v == 'clearkey':
                    if drm is None:
                        drm = {'type': 'clearkey'}
                elif k == 'inputstream.adaptive.license_key':
                    if ':' in v:
                        kid, key = v.split(':', 1)
                        if drm is None:
                            drm = {'type': 'clearkey'}
                        drm['kid'] = kid.strip()
                        drm['key'] = key.strip()
                elif k == 'inputstream.adaptive.stream_headers':
                    for pair in v.split('&'):
                        if '=' in pair:
                            hk, hv = pair.split('=', 1)
                            headers[hk] = urllib.parse.unquote(hv)

        processed.append({
            'id': ch_id,
            'name': final_name,
            'logo': ch['logo'],
            'category': 'reborn-sports',
            'country': None,
            'language': None,
            'is_live': True,
            'is_trending': False,
            'quality': 'HD',
            'stream_url': url_part,
            'headers': headers,
            'proxy': True,
            'drm': drm
        })

    return processed

if __name__ == '__main__':
    ch_list = parse_m3u('playlist.m3u')
    proc_list = process_channels(ch_list)
    print(f"Total parsed channels: {len(ch_list)}")
    print(f"Total processed channels (excluding social): {len(proc_list)}")
    print("\nSample processed channels:")
    print(json.dumps(proc_list[:3], indent=2))
