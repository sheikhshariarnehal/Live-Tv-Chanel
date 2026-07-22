#!/usr/bin/env python3
"""
GoPlay Movies Module - IPTV Stream Checker & Hourly M3U Sync Worker
Downloads raw M3U, asynchronously checks each stream URL for availability,
generates clean M3U playlists in output/ folder, and upserts working movies into Supabase DB.
"""

import os
import re
import sys
import json
import asyncio
import urllib.parse
import urllib.request
import urllib.error

try:
    import aiohttp
except ImportError:
    print("aiohttp not installed. Please run: pip install aiohttp")
    sys.exit(1)

RAW_M3U_URL = "https://raw.githubusercontent.com/sm-monirulislam/SM-Movie-Hup-Auto-Update/refs/heads/main/Movie_Combined.m3u"
DEFAULT_SUPABASE_URL = "https://hqmhuvsjlykrdusfkmeg.supabase.co"
DEFAULT_SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA"

DEFAULT_HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Referer': 'https://fibwatch.art/'
}

def slugify(text):
    text = text.lower()
    text = re.sub(r'[^a-z0-9\s\-]', '', text)
    text = re.sub(r'[\s\-]+', '-', text)
    return text.strip('-')

def extract_tags(title):
    quality = "HD"
    language = "Unknown"
    year = None

    if re.search(r'\[CAM\]|CAM', title, re.IGNORECASE):
        quality = "CAM"
    elif re.search(r'\[4K\]|4K', title, re.IGNORECASE):
        quality = "4K"
    elif re.search(r'\[1080p\]|1080p', title, re.IGNORECASE):
        quality = "1080p"
    elif re.search(r'\[720p\]|720p', title, re.IGNORECASE):
        quality = "720p"

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

    year_match = re.search(r'\b(19\d{2}|20\d{2})\b', title)
    if year_match:
        year = int(year_match.group(1))

    clean_title = re.sub(r'\[.*?\]', '', title).strip()
    if not clean_title:
        clean_title = title

    return clean_title, quality, language, year

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
                'raw_line': line,
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
                headers = dict(DEFAULT_HEADERS)

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

                movies.append({
                    'id': movie_id,
                    'title': clean_title,
                    'raw_line': current_item['raw_line'],
                    'vlc_opts': current_item['vlc_opts'],
                    'poster': current_item['logo'],
                    'category_id': cat_id,
                    'category_name': current_item['group'],
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

async def check_single_movie(session, sem, movie, total, progress):
    url = movie['stream_url']
    req_headers = movie['headers']
    timeout = 8

    async with sem:
        try:
            # First try HEAD request
            async with session.head(url, headers=req_headers, timeout=timeout, allow_redirects=True) as resp:
                if resp.status in (200, 206, 302):
                    progress[0] += 1
                    if progress[0] % 1000 == 0 or progress[0] == total:
                        print(f"Checked {progress[0]} / {total} streams...")
                    return movie
        except Exception:
            pass

        try:
            # Fallback to range GET request
            get_headers = dict(req_headers)
            get_headers['Range'] = 'bytes=0-1024'
            async with session.get(url, headers=get_headers, timeout=timeout, allow_redirects=True) as resp:
                if resp.status in (200, 206, 302):
                    progress[0] += 1
                    if progress[0] % 1000 == 0 or progress[0] == total:
                        print(f"Checked {progress[0]} / {total} streams...")
                    return movie
        except Exception:
            pass

    progress[0] += 1
    if progress[0] % 1000 == 0 or progress[0] == total:
        print(f"Checked {progress[0]} / {total} streams...")
    return None

async def filter_working_movies(movies, concurrency=50):
    print(f"Asynchronously checking accessibility for {len(movies)} streams (concurrency: {concurrency})...")
    sem = asyncio.Semaphore(concurrency)
    progress = [0]
    total = len(movies)

    async with aiohttp.ClientSession() as session:
        tasks = [check_single_movie(session, sem, m, total, progress) for m in movies]
        results = await asyncio.gather(*tasks)

    working = [m for m in results if m is not None]
    print(f"Stream verification complete! {len(working)} / {total} streams are active.")
    return working

def generate_m3u_file(working_movies, output_path):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    lines = ["#EXTM3U\n"]
    for m in working_movies:
        lines.append(f"{m['raw_line']}\n")
        for vlc in m.get('vlc_opts', []):
            lines.append(f"{vlc}\n")
        lines.append(f"{m['stream_url']}\n")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    print(f"Generated clean M3U playlist file at: {output_path}")

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

R2_ACCOUNT_ID = os.environ.get("R2_ACCOUNT_ID") or "aa99ddc40153ab1ceab9f2b9f26b2c85"
R2_ACCESS_KEY_ID = os.environ.get("R2_ACCESS_KEY_ID") or "d232cf2991dc5ceb5acac1af5ecc8a31"
R2_SECRET_ACCESS_KEY = os.environ.get("R2_SECRET_ACCESS_KEY") or "838281291b2d1baa7def41b7ca9bccf345401f45e423720f541024b4a928cce1"
R2_BUCKET_NAME = os.environ.get("R2_BUCKET_NAME") or "posters"
R2_PUBLIC_BASE_URL = os.environ.get("R2_PUBLIC_BASE_URL") or "https://pub-cd766441d96b4a34acf34877be374ea9.r2.dev"

async def upload_poster_to_r2(session, sem, r2_client, movie, progress, total):
    poster_url = movie.get('poster')
    if not poster_url:
        return

    if poster_url.startswith(R2_PUBLIC_BASE_URL):
        return

    r2_key = f"{movie['id']}.jpg"
    r2_public_url = f"{R2_PUBLIC_BASE_URL}/{r2_key}"

    async with sem:
        loop = asyncio.get_event_loop()
        try:
            await loop.run_in_executor(
                None, lambda: r2_client.head_object(Bucket=R2_BUCKET_NAME, Key=r2_key)
            )
            movie['poster'] = r2_public_url
            progress[0] += 1
            if progress[0] % 500 == 0 or progress[0] == total:
                print(f"R2 Poster Sync: {progress[0]} / {total} movies processed...")
            return
        except Exception:
            pass

        try:
            req_headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                'Referer': 'https://fibwatch.art/'
            }
            async with session.get(poster_url, headers=req_headers, timeout=aiohttp.ClientTimeout(total=8)) as resp:
                if resp.status == 200:
                    img_bytes = await resp.read()
                    if img_bytes and len(img_bytes) > 500:
                        await loop.run_in_executor(
                            None,
                            lambda: r2_client.put_object(
                                Bucket=R2_BUCKET_NAME,
                                Key=r2_key,
                                Body=img_bytes,
                                ContentType='image/jpeg'
                            )
                        )
                        movie['poster'] = r2_public_url
        except Exception:
            pass

    progress[0] += 1
    if progress[0] % 500 == 0 or progress[0] == total:
        print(f"R2 Poster Sync: {progress[0]} / {total} movies processed...")

async def sync_posters_to_r2(working_movies, concurrency=15):
    print(f"Synchronizing active movie posters to Cloudflare R2 bucket '{R2_BUCKET_NAME}'...")
    try:
        import boto3
        r2_client = boto3.client(
            's3',
            endpoint_url=f"https://{R2_ACCOUNT_ID}.r2.cloudflarestorage.com",
            aws_access_key_id=R2_ACCESS_KEY_ID,
            aws_secret_access_key=R2_SECRET_ACCESS_KEY,
            region_name='auto'
        )
    except Exception as e:
        print(f"Warning: boto3 R2 client setup failed ({e}). Skipping R2 poster sync.")
        return

    sem = asyncio.Semaphore(concurrency)
    progress = [0]
    total = len(working_movies)

    async with aiohttp.ClientSession() as session:
        tasks = [upload_poster_to_r2(session, sem, r2_client, m, progress, total) for m in working_movies]
        await asyncio.gather(*tasks)

    r2_count = sum(1 for m in working_movies if m.get('poster', '').startswith(R2_PUBLIC_BASE_URL))
    print(f"Cloudflare R2 Poster Sync Complete! {r2_count} / {total} posters hosted on Cloudflare R2!")

async def main_async():
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

    working_movies = await filter_working_movies(movies, concurrency=50)

    # Sync posters to Cloudflare R2
    await sync_posters_to_r2(working_movies, concurrency=15)

    # 1. Output clean generated M3U playlist
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    output_path = os.path.join(base_dir, '..', 'output', 'Movie_Combined_Clean.m3u')
    generate_m3u_file(working_movies, output_path)

    index_path = os.path.join(base_dir, '..', 'output', 'index.m3u')
    generate_m3u_file(working_movies, index_path)

    # 2. Sync working movies to Supabase DB
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

        print("Purging stale/non-working movies from Supabase DB...")
        delete_endpoint = f"{supabase_url}/rest/v1/movies?id=neq.dummy"
        delete_headers = {
            "apikey": supabase_key,
            "Authorization": f"Bearer {supabase_key}",
            "Prefer": "return=minimal"
        }
        try:
            postgrest_request(delete_endpoint, method="DELETE", headers=delete_headers)
            print("Successfully purged stale movies from DB.")
        except Exception as err:
            print(f"Warning during purge ({err}), proceeding with upsert...")

        print(f"Upserting {len(working_movies)} verified active movies in batches of 100...")
        movies_endpoint = f"{supabase_url}/rest/v1/movies"
        
        # Prepare movie records for Supabase schema
        db_movies = []
        for m in working_movies:
            db_movies.append({
                'id': m['id'],
                'title': m['title'],
                'poster': m['poster'],
                'category_id': m['category_id'],
                'language': m['language'],
                'quality': m['quality'],
                'year': m['year'],
                'description': m['description'],
                'stream_url': m['stream_url'],
                'headers': m['headers'],
            })

        batch_size = 100
        for i in range(0, len(db_movies), batch_size):
            batch = db_movies[i:i + batch_size]
            postgrest_request(movies_endpoint, method="POST", data=batch, headers=headers)
            if (i + len(batch)) % 1000 == 0 or (i + len(batch)) == len(db_movies):
                print(f"Upserted movies {i + len(batch)} / {len(db_movies)}")

        print("Fetching current movies_version in app_settings...")
        settings_endpoint = f"{supabase_url}/rest/v1/app_settings?select=movies_version&limit=1"
        res = postgrest_request(settings_endpoint, method="GET", headers={"apikey": supabase_key, "Authorization": f"Bearer {supabase_key}"})
        
        current_ver = 1
        if res and isinstance(res, list) and len(res) > 0 and "movies_version" in res[0]:
            current_ver = res[0]["movies_version"]
        
        new_ver = current_ver + 1
        print(f"Updating movies_version from {current_ver} to {new_ver}...")

        update_endpoint = f"{supabase_url}/rest/v1/app_settings?id=eq.1"
        update_headers = {
            "apikey": supabase_key,
            "Authorization": f"Bearer {supabase_key}",
            "Prefer": "return=minimal"
        }
        postgrest_request(update_endpoint, method="PATCH", data={"movies_version": new_ver}, headers=update_headers)
        
        print(f"SUCCESS! Verified and synchronized {len(working_movies)} active movies into Supabase DB! New movies_version: {new_ver}")
    
    except Exception as e:
        print(f"Database sync failed: {e}")
        sys.exit(1)

def main():
    try:
        asyncio.run(main_async())
    except AttributeError:
        loop = asyncio.get_event_loop()
        loop.run_until_complete(main_async())

if __name__ == "__main__":
    main()
