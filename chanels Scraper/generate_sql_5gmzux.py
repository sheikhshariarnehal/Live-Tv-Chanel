import re
import json

def escape_sql_string(val):
    if val is None:
        return 'NULL'
    # Escape single quotes in Postgres by doubling them
    escaped = str(val).replace("'", "''")
    return f"'{escaped}'"

def main():
    print("Loading 5gmzux.json...")
    with open('5gmzux.json', 'r', encoding='utf-8') as f:
        channels = json.load(f)
        
    print(f"Loaded {len(channels)} raw channels.")
    
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
        
    print(f"Filtered down to {len(filtered_channels)} sports channels.")
    
    sql_lines = []
    sql_lines.append("INSERT INTO public.channels (id, name, logo, category, country, language, is_live, is_trending, quality, stream_url, headers, proxy, drm, sort_order)")
    sql_lines.append("VALUES")
    
    value_rows = []
    for idx, ch in enumerate(filtered_channels):
        # Use the already unique id from JSON, and append -cricfy suffix
        ch_id = f"{ch['id']}-cricfy"
        
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
    
    with open('5gmzux.sql', 'w', encoding='utf-8') as f:
        f.write("\n".join(sql_lines))
        
    print(f"Generated 5gmzux.sql with {len(filtered_channels)} rows.")

if __name__ == '__main__':
    main()
