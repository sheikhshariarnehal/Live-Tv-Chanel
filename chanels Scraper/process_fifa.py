import re
import json
import base64
import urllib.parse
import urllib.request
import os

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

def escape_sql_string(val):
    if val is None:
        return 'NULL'
    # Escape single quotes in Postgres by doubling them
    escaped = str(val).replace("'", "''")
    return f"'{escaped}'"

def generate_sql(channels, output_sql_path):
    print("Generating SQL...")
    filtered_channels = []
    for idx, ch in enumerate(channels):
        name = ch['name']
        group = ch['group'] or ''
        
        # Filter out sponsored/telegram/facebook/join social channels
        if 'telegram' in name.lower() or 'facebook' in name.lower() or 'join' in name.lower():
            continue
        if ch['category_id'] == 'sponsored' or group == '📢 SOCIAL MEDIA':
            continue
            
        filtered_channels.append(ch)
        
    print(f"Filtered down to {len(filtered_channels)} sports channels for SQL.")
    
    sql_lines = []
    sql_lines.append("INSERT INTO public.channels (id, name, logo, category, country, language, is_live, is_trending, quality, stream_url, headers, proxy, drm, sort_order)")
    sql_lines.append("VALUES")
    
    value_rows = []
    for idx, ch in enumerate(filtered_channels):
        # Use the already unique id from JSON, and append -fifa suffix
        ch_id = f"{ch['id']}-fifa"
        
        id_val = escape_sql_string(ch_id)
        name_val = escape_sql_string(ch['name'])
        logo_val = escape_sql_string(ch['logo'])
        
        # Hardcode category to 'sports'
        cat_val = "'sports'"
        
        country_val = 'NULL'
        lang_val = 'NULL'
        is_live_val = 'true'
        is_trend_val = 'false'
        quality_val = "'HD'"
        stream_url_val = escape_sql_string(ch['stream_url'])
        
        # headers JSON
        if ch['headers']:
            headers_json = json.dumps(ch['headers'])
            headers_val = escape_sql_string(headers_json) + '::jsonb'
        else:
            headers_val = "'{}'::jsonb"
            
        proxy_val = 'true'
        
        # drm JSON
        if ch['drm']:
            drm_json = json.dumps(ch['drm'])
            drm_val = escape_sql_string(drm_json) + '::jsonb'
        else:
            drm_val = 'NULL'
            
        sort_order_val = str(idx + 1)
        
        row = f"({id_val}, {name_val}, {logo_val}, {cat_val}, {country_val}, {lang_val}, {is_live_val}, {is_trend_val}, {quality_val}, {stream_url_val}, {headers_val}, {proxy_val}, {drm_val}, {sort_order_val})"
        value_rows.append(row)
        
    sql_lines.append(",\n".join(value_rows))
    sql_lines.append("ON CONFLICT (id) DO UPDATE SET")
    sql_lines.append("  name = EXCLUDED.name,")
    sql_lines.append("  logo = EXCLUDED.logo,")
    sql_lines.append("  category = EXCLUDED.category,")
    sql_lines.append("  country = EXCLUDED.country,")
    sql_lines.append("  language = EXCLUDED.language,")
    sql_lines.append("  is_live = EXCLUDED.is_live,")
    sql_lines.append("  is_trending = EXCLUDED.is_trending,")
    sql_lines.append("  quality = EXCLUDED.quality,")
    sql_lines.append("  stream_url = EXCLUDED.stream_url,")
    sql_lines.append("  headers = EXCLUDED.headers,")
    sql_lines.append("  proxy = EXCLUDED.proxy,")
    sql_lines.append("  drm = EXCLUDED.drm,")
    sql_lines.append("  sort_order = EXCLUDED.sort_order;")
    
    with open(output_sql_path, 'w', encoding='utf-8') as f:
        f.write("\n".join(sql_lines))
        
    print(f"Saved SQL queries to {output_sql_path}")

def main():
    url = "https://fifa.allinonereborn.workers.dev/1z1vjv.m3u"
    m3u_file = "1z1vjv.m3u"
    flat_json = "1z1vjv.json"
    grouped_json = "1z1vjv_grouped.json"
    sql_file = "1z1vjv.sql"
    
    print(f"Downloading {url}...")
    headers = {'User-Agent': 'VLC/3.0.18 LibVLC/3.0.18'}
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            content = response.read().decode('utf-8')
            print("Download success! Total length:", len(content))
            with open(m3u_file, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Saved complete file to {m3u_file}")
    except Exception as e:
        print("Download failed:", e)
        return

    print(f"Parsing {m3u_file}...")
    ch_list = parse_m3u(m3u_file)
    proc_list = process_channels(ch_list)
    
    # 1. Save flat channel list
    with open(flat_json, 'w', encoding='utf-8') as f:
        json.dump(proc_list, f, indent=2, ensure_ascii=False)
    print(f"Saved flat channel list to {flat_json} ({len(proc_list)} channels)")

    # 2. Save grouped channel list
    grouped_channels = {}
    for ch in proc_list:
        cat_id = ch['category_id']
        cat_name = ch['category']
        
        if cat_id not in grouped_channels:
            grouped_channels[cat_id] = {
                'name': cat_name,
                'channels': []
            }
            
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
            ch_item['drm'] = {
                'kid': ch['drm']['kid'],
                'key': ch['drm']['key']
            }
            
        grouped_channels[cat_id]['channels'].append(ch_item)

    with open(grouped_json, 'w', encoding='utf-8') as f:
        json.dump(grouped_channels, f, indent=2, ensure_ascii=False)
    print(f"Saved grouped channels to {grouped_json} ({len(grouped_channels)} categories)")

    # 3. Generate SQL file
    generate_sql(proc_list, sql_file)

if __name__ == '__main__':
    main()
