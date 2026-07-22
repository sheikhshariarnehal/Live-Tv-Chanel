import os
import sys
import json
import urllib.request
import urllib.error

# Load configurations
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_ANON_KEY = os.environ.get("SUPABASE_ANON_KEY")
ADMIN_SECRET_TOKEN = os.environ.get("ADMIN_SECRET_TOKEN")

if not SUPABASE_URL or not SUPABASE_ANON_KEY or not ADMIN_SECRET_TOKEN:
    print("Error: Missing required environment variables: SUPABASE_URL, SUPABASE_ANON_KEY, ADMIN_SECRET_TOKEN")
    sys.exit(1)

TAPMAD_JSON_URL = "https://raw.githubusercontent.com/srhady/tapmad-bd/refs/heads/main/tapmad_bd.json"

def make_request(url, method="GET", headers=None, data=None):
    if headers is None:
        headers = {}
    
    req_data = None
    if data is not None:
        req_data = json.dumps(data).encode("utf-8")
        headers["Content-Type"] = "application/json"
        
    req = urllib.request.Request(url, data=req_data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as response:
            res_data = response.read()
            if response.status >= 200 and response.status < 300:
                return json.loads(res_data.decode("utf-8")) if res_data else {}
            else:
                print(f"Error: Request to {url} returned status {response.status}")
                return None
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8") if e else ""
        print(f"HTTPError to {url}: {e.code} - {e.reason}\nBody: {body}")
        return None
    except Exception as e:
        print(f"Error making request to {url}: {e}")
        return None

def main():
    print("Fetching latest Tapmad channels from GitHub...")
    # Fetch tapmad_bd.json
    try:
        req = urllib.request.Request(
            TAPMAD_JSON_URL, 
            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
        )
        with urllib.request.urlopen(req) as response:
            tapmad_data = json.loads(response.read().decode("utf-8"))
    except Exception as e:
        print(f"Error fetching tapmad_bd.json: {e}")
        sys.exit(1)
        
    matches = tapmad_data.get("Matches", [])
    print(f"Loaded {len(matches)} match streams from GitHub.")
    
    # 1. Build target channels dictionary
    target_channels = {}
    for match in matches:
        entity_id = match.get("EntityId")
        if not entity_id:
            continue
            
        channel_id = f"tapmad-{entity_id}"
        
        # Determine is_live based on Status
        status = match.get("Status", "").lower()
        is_live = status == "live"
        
        target_channels[channel_id] = {
            "id": channel_id,
            "name": f"Tapmad - {match.get('VideoName', 'Live Event')}",
            "logo": match.get("ThumbnailStandard"),
            "category": "sports",
            "country": None,
            "language": None,
            "is_live": is_live,
            "is_trending": False,
            "quality": "HD",
            "stream_url": match.get("stream_url"),
            "headers": {},
            "proxy": False,
            "drm": None,
            "sort_order": 0
        }
        
    # 2. Fetch existing tapmad channels from Supabase
    supabase_headers = {
        "apikey": SUPABASE_ANON_KEY,
        "Authorization": f"Bearer {SUPABASE_ANON_KEY}",
    }
    
    # URL escape % as %25
    db_url = f"{SUPABASE_URL.rstrip('/')}/rest/v1/channels?id=ilike.tapmad-%25&select=id,name,logo,stream_url,is_live"
    print("Fetching existing Tapmad channels from Supabase...")
    existing_channels_raw = make_request(db_url, "GET", supabase_headers)
    
    if existing_channels_raw is None:
        print("Failed to fetch existing channels from database. Aborting.")
        sys.exit(1)
        
    # Filter for numeric suffix e.g., tapmad-12345
    existing_channels = {}
    for ch in existing_channels_raw:
        ch_id = ch["id"]
        suffix = ch_id.replace("tapmad-", "")
        if suffix.isdigit():
            existing_channels[ch_id] = ch
            
    print(f"Found {len(existing_channels)} automated Tapmad channels in database.")
    
    # 3. Compare to identify deletes and upserts
    to_delete = []
    for ch_id in existing_channels:
        if ch_id not in target_channels:
            to_delete.append(ch_id)
            
    to_upsert = []
    for ch_id, target in target_channels.items():
        if ch_id not in existing_channels:
            to_upsert.append(target)
        else:
            existing = existing_channels[ch_id]
            # Compare fields to determine if update is needed
            name_changed = target["name"] != existing.get("name")
            logo_changed = target["logo"] != existing.get("logo")
            url_changed = target["stream_url"] != existing.get("stream_url")
            live_changed = target["is_live"] != existing.get("is_live")
            
            if name_changed or logo_changed or url_changed or live_changed:
                to_upsert.append(target)
                
    print(f"Comparison results: {len(to_upsert)} to upsert, {len(to_delete)} to delete.")
    
    # 4. Execute Changes
    changes_made = False
    
    admin_headers = {
        "apikey": SUPABASE_ANON_KEY,
        "Authorization": f"Bearer {SUPABASE_ANON_KEY}",
        "x-admin-token": ADMIN_SECRET_TOKEN,
    }
    
    # Perform Deletes
    if to_delete:
        print(f"Deleting {len(to_delete)} stale channels...")
        # Format the id list as '("tapmad-123","tapmad-456")'
        id_list = ",".join([f'"{id}"' for id in to_delete])
        delete_url = f"{SUPABASE_URL.rstrip('/')}/rest/v1/channels?id=in.({id_list})"
        res = make_request(delete_url, "DELETE", admin_headers)
        if res is not None:
            print("Deletion completed successfully.")
            changes_made = True
        else:
            print("Failed to delete stale channels.")
            sys.exit(1)
            
    # Perform Upserts
    if to_upsert:
        print(f"Upserting {len(to_upsert)} channels...")
        upsert_headers = admin_headers.copy()
        upsert_headers["Prefer"] = "resolution=merge-duplicates"
        upsert_url = f"{SUPABASE_URL.rstrip('/')}/rest/v1/channels?on_conflict=id"
        
        res = make_request(upsert_url, "POST", upsert_headers, to_upsert)
        if res is not None:
            print("Upsert completed successfully.")
            changes_made = True
        else:
            print("Failed to upsert channels.")
            sys.exit(1)
            
    if changes_made:
        print("Database sync completed successfully and changes were committed.")
    else:
        print("No changes detected. Database is up to date.")

if __name__ == "__main__":
    main()
