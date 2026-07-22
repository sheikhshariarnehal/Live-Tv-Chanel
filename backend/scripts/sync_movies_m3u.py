#!/usr/bin/env python3
"""
GoPlay Movies Module - Hourly M3U Sync Worker
Fetches Movie_Combined.m3u, parses movie metadata, categories, quality, language tags,
and upserts data into Supabase DB via REST API while incrementing `movies_version` in `app_settings`.
Zero external dependencies required (uses Python standard library).
"""

import os
import re
import sys
import json
import urllib.parse
import urllib.request
import urllib.error

RAW_M3U_URL = "https://raw.githubusercontent.com/sm-monirulislam/SM-Movie-Hup-Auto-Update/refs/heads/main/Movie_Combined.m3u"
DEFAULT_SUPABASE_URL = "https://hqmhuvsjlykrdusfkmeg.supabase.co"
DEFAULT_SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA"

def slugify(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s\-]', '', text)
    text = re.sub(r'[\s\-]+', '-', text)
    return text.strip('-')

def extract_tags(title):
    quality = "HD"
    language = "Unknown"
    year = None

    # Detect Quality
    if re.search(r'\[CAM\]|CAM', title, re.IGNORECASE):
        quality = "CAM"
    elif re.search(r'\[4K\]|4K', title, re.IGNORECASE):
        quality = "4K"
    elif re.search(r'\[1080p\]|1080p', title, re.IGNORECASE):
        quality = "1080p"
    elif re.search(r'\[720p\]|720p', title, re.IGNORECASE):
        quality = "720p"

    # Detect Language
    lang_match = re.search(r'\[(Hindi|Bangla|English|Tamil|Telugu|Malayalam|Kannada|Korean|Chinese|Dual)\]', title, re.IGNORECASE)
    if lang_match:
        language = lang_match.group(1).capitalize()
    else:
        if "Hindi" in title:
            language = "Hindi"
        elif "Bangla" in title:
            language = "Bangla"
        elif "English" in title:
            language = "English"

    # Detect Year (e.g. 2024, 2025, 2026)
    year_match = re.search(r'\b(19\d{2}|20\d{2})\b', title)
    if year_match:
        year = int(year_match.group(1))

    # Clean title
    clean_title = re.sub(r'\[.*?\]', '', title).strip()
    if not clean_title:
        clean_title = title

def clean_poster_url(url):
    if not url:
        return None
    url = url.strip()
    if '|' in url:
        url = url.split('|')[0]
    if 'image.sm-monirulislam-exp.workers.dev' in url and 'url=' in url:
        parsed = urllib.parse.urlparse(url)
        qs = urllib.parse.parse_qs(parsed.query)
        if 'url' in qs and qs['url']:
            url = qs['url'][0]
    url = url.strip().rstrip('|')
    return url if url else None

def parse_m3u_content(m3u_text):
    lines = m3u_text.splitlines()
    movies = []
    categories_set = set()
    current_item = None
    seen_ids = set()

    for idx, line in enumerate(lines):
        line = line.strip()
        if not line:
            continue

        if line.startswith('#EXTINF:'):
            logo = ''
            logo_match = re.search(r'tvg-logo="([^"]+)"', line)
            if logo_match:
                logo = clean_poster_url(logo_match.group(1))

            group = 'Movies'
            group_match = re.search(r'group-title="([^"]+)"', line)
            if group_match and group_match.group(1).strip():
                group = group_match.group(1).strip()

            categories_set.add(group)

            parts = line.split(',')
            raw_title = parts[-1].strip() if len(parts) > 1 else line

            current_item = {
                'raw_title': raw_title,
                'logo': logo if logo else None,
                'group': group,
                'url': None,
                'vlc_opts': [],
                'kodi_props': []
            }
        elif line.startswith('#EXTVLCOPT:'):
            if current_item is not None:
                current_item['vlc_opts'].append(line)
        elif line.startswith('#KODIPROP:'):
            if current_item is not None:
                current_item['kodi_props'].append(line)
        elif line.startswith('http://') or line.startswith('https://'):
            if current_item is not None:
                current_item['url'] = line
                
                clean_title, quality, language, year = extract_tags(current_item['raw_title'])
                cat_id = slugify(current_item['group']) or 'uncategorized'
                
                base_id = slugify(f"{clean_title}-{current_item['group']}")
                if not base_id:
                    base_id = f"movie-{idx}"

                movie_id = base_id
                counter = 1
                while movie_id in seen_ids:
                    movie_id = f"{base_id}-{counter}"
                    counter += 1
                seen_ids.add(movie_id)

                url_part = current_item['url']
                headers = {}

                for opt in current_item.get('vlc_opts', []):
                    opt_str = opt.replace('#EXTVLCOPT:', '').strip()
                    if '=' in opt_str:
                        k, v = opt_str.split('=', 1)
                        k_clean = k.strip().lower()
                        v_clean = v.strip()
                        if k_clean in ('http-referrer', 'referer', 'referrer'):
                            headers['Referer'] = v_clean
                        elif k_clean in ('http-user-agent', 'user-agent'):
                            headers['User-Agent'] = v_clean

                for prop in current_item.get('kodi_props', []):
                    prop_str = prop.replace('#KODIPROP:', '').strip()
                    if '=' in prop_str:
                        k, v = prop_str.split('=', 1)
                        if k.strip().lower() == 'inputstream.adaptive.stream_headers':
                            for pair in v.split('&'):
                                if '=' in pair:
                                    hk, hv = pair.split('=', 1)
                                    headers[hk.strip()] = urllib.parse.unquote(hv.strip())

                if '|' in url_part:
                    parts = url_part.split('|')
                    url_part = parts[0]
                    header_str = parts[1]
                    for pair in header_str.split('&'):
                        if '=' in pair:
                            k, v = pair.split('=', 1)
                            headers[k.strip()] = urllib.parse.unquote(v.strip())

                if 'Referer' not in headers and ('b-cdn.net' in url_part or 'fibwatch' in url_part):
                    headers['Referer'] = 'https://fibwatch.art/'

                movies.append({
                    'id': movie_id,
                    'title': clean_title,
                    'poster': current_item['logo'],
                    'category_id': cat_id,
                    'language': language,
                    'quality': quality,
                    'year': year,
                    'description': f"{clean_title} ({language})",
                    'stream_url': url_part,
                    'headers': headers,
                })
                current_item = None

    categories = []
    for idx, group_name in enumerate(sorted(categories_set)):
        cat_id = slugify(group_name) or 'uncategorized'
        categories.append({
            'id': cat_id,
            'name': group_name,
            'sort_order': idx + 1
        })

    return categories, movies

def postgrest_request(url, method="GET", data=None, headers=None):
    if headers is None:
        headers = {}
    
    body = None
    if data is not None:
        body = json.dumps(data).encode('utf-8')
        headers['Content-Type'] = 'application/json'

    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as resp:
            resp_data = resp.read().decode('utf-8')
            if resp_data:
                return json.loads(resp_data)
            return None
    except urllib.error.HTTPError as e:
        err_body = e.read().decode('utf-8')
        print(f"HTTPError {e.code} for {url}: {err_body}")
        raise e

def main():
    print("Fetching raw M3U playlist from GitHub...")
    req = urllib.request.Request(RAW_M3U_URL, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        with urllib.request.urlopen(req) as resp:
            m3u_text = resp.read().decode('utf-8')
    except Exception as e:
        print(f"Error downloading M3U file: {e}")
        sys.exit(1)

    print("Parsing M3U playlist...")
    categories, movies = parse_m3u_content(m3u_text)
    print(f"Parsed {len(categories)} categories and {len(movies)} movies.")

    supabase_url = os.environ.get("SUPABASE_URL") or DEFAULT_SUPABASE_URL
    supabase_key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY") or os.environ.get("SUPABASE_KEY") or DEFAULT_SUPABASE_KEY

    headers = {
        "apikey": supabase_key,
        "Authorization": f"Bearer {supabase_key}",
        "Prefer": "resolution=merge-duplicates"
    }

    try:
        print("Upserting movie categories...")
        cat_endpoint = f"{supabase_url}/rest/v1/movie_categories"
        postgrest_request(cat_endpoint, method="POST", data=categories, headers=headers)
        print(f"Successfully upserted {len(categories)} categories.")

        print(f"Upserting {len(movies)} movies in batches of 100...")
        batch_size = 100
        movie_endpoint = f"{supabase_url}/rest/v1/movies"
        for i in range(0, len(movies), batch_size):
            batch = movies[i:i + batch_size]
            postgrest_request(movie_endpoint, method="POST", data=batch, headers=headers)
            if (i // batch_size) % 10 == 0 or (i + batch_size) >= len(movies):
                print(f"Upserted movies {min(i + batch_size, len(movies))} / {len(movies)}")

        print("Fetching current movies_version in app_settings...")
        settings_endpoint = f"{supabase_url}/rest/v1/app_settings?id=eq.1&select=movies_version"
        get_headers = {
            "apikey": supabase_key,
            "Authorization": f"Bearer {supabase_key}"
        }
        res = postgrest_request(settings_endpoint, method="GET", headers=get_headers)
        
        current_ver = 1
        if res and len(res) > 0 and res[0].get("movies_version"):
            current_ver = res[0]["movies_version"]

        new_ver = current_ver + 1
        print(f"Updating movies_version from {current_ver} to {new_ver}...")
        
        update_headers = {
            "apikey": supabase_key,
            "Authorization": f"Bearer {supabase_key}",
            "Content-Type": "application/json"
        }
        patch_endpoint = f"{supabase_url}/rest/v1/app_settings?id=eq.1"
        postgrest_request(patch_endpoint, method="PATCH", data={"movies_version": new_ver}, headers=update_headers)

        print(f"SUCCESS! Synchronized all {len(movies)} movies into Supabase DB! New movies_version: {new_ver}")

    except Exception as e:
        print(f"Error syncing with Supabase: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
