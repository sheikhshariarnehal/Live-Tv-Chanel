import requests
import re
import json
import os
import shutil
import sys

# Reconfigure stdout/stderr to use UTF-8 to prevent console encoding crashes on Windows
sys.stdout.reconfigure(encoding='utf-8')
sys.stderr.reconfigure(encoding='utf-8')

m3u_url = "https://fifalive.click/play"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

def clean_id(name):
    # Generates a slug-friendly ID, prepending fifalive-
    clean = re.sub(r'[^a-zA-Z0-9\s-]', '', name).strip().lower()
    clean = re.sub(r'[\s-]+', '-', clean)
    return f"fifalive-{clean}"

def main():
    print(f"Fetching FIFA Live playlist from {m3u_url}...")
    try:
        res = requests.get(m3u_url, headers=headers, timeout=15)
        if res.status_code != 200:
            print(f"Error: Received HTTP {res.status_code} from {m3u_url}")
            return
    except Exception as e:
        print(f"Error fetching playlist: {e}")
        return

    lines = res.text.splitlines()
    channels = []
    
    current_name = None
    current_logo = ""
    default_logo = "https://pub-66c415049e354d59968472f8a48aff3d.r2.dev/Gemini_Generated_Image_dkp0p0dkp0p0dkp0.webp"

    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith("#EXTINF:"):
            # Try to extract tvg-name or the display name at the end
            # Example: #EXTINF:-1 tvg-name="FIFA 2026 Live (Server 1)" tvg-logo="" group-title="Sports",FIFA 2026 Live (Server 1)
            name_match = re.search(r'tvg-name="([^"]+)"', line)
            logo_match = re.search(r'tvg-logo="([^"]+)"', line)
            
            display_name = ""
            if "," in line:
                display_name = line.split(",", 1)[1].strip()
            
            if name_match:
                current_name = name_match.group(1)
            elif display_name:
                current_name = display_name
            else:
                current_name = "FIFA 2026 Live Channel"

            if logo_match and logo_match.group(1):
                current_logo = logo_match.group(1)
            else:
                current_logo = default_logo
        elif line.startswith("#"):
            # Skip other comments
            continue
        else:
            # This is the URL
            if current_name:
                channels.append({
                    "id": clean_id(current_name),
                    "name": current_name,
                    "url": line,
                    "logo": current_logo
                })
                current_name = None
                current_logo = ""

    print(f"Parsed {len(channels)} channels from the playlist.")
    for idx, ch in enumerate(channels):
        print(f"  [{idx+1}] ID: {ch['id']} | Name: {ch['name']} | URL: {ch['url'][:60]}...")

    # Save the custom fifalive-only output
    output_path = "public/assets/data/fifalive_channels.json"
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(channels, f, indent=2, ensure_ascii=False)
    print(f"Saved fifalive-only channels to {output_path}")

    # Merge or update in public/assets/data/channels.json
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

                # Map existing channel id to its index for quick lookup
                id_to_index = {ch.get('id'): idx for idx, ch in enumerate(existing_sports)}

                added_count = 0
                updated_count = 0

                for new_ch in channels:
                    new_id = new_ch['id']
                    # Let's clean the id specifically for check against potential existing manual names
                    # like toffee-fifa-2026-4. Wait, the Server 1 in play is:
                    # https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-4/0/master_2000.m3u8?...
                    # Its new_id is fifalive-fifa-2026-live-server-1.
                    # What if we also check if there is an existing channel with the same start/url? Or just ID?
                    # Let's match by ID first.
                    if new_id in id_to_index:
                        idx = id_to_index[new_id]
                        # Update URL
                        if existing_sports[idx]['url'] != new_ch['url']:
                            print(f"Updating URL for channel ID: {new_id}")
                            existing_sports[idx]['url'] = new_ch['url']
                            updated_count += 1
                    else:
                        # Let's also check if we have a duplicate by name or similar, or just insert it
                        existing_sports.append(new_ch)
                        added_count += 1
                        id_to_index[new_id] = len(existing_sports) - 1

                channels_data["categories"]["sports"]["channels"] = existing_sports

                with open(channels_json_path, 'w', encoding='utf-8') as f:
                    json.dump(channels_data, f, indent=2, ensure_ascii=False)

                print(f"Successfully merged: {added_count} added, {updated_count} updated in '{channels_json_path}' under 'sports' category!")
            else:
                print("Error: Could not find 'categories' or 'sports' key in channels.json. Skipping merge.")
        except Exception as e:
            print(f"Error merging with channels.json: {e}")
    else:
        print("channels.json not found, skipping merge.")

if __name__ == '__main__':
    main()
