import urllib.request

url = "https://cricfy.allinonereborn.workers.dev/995xon.m3u"
headers = {'User-Agent': 'VLC/3.0.18 LibVLC/3.0.18'}

try:
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as response:
        content = response.read().decode('utf-8')
        print("Success! Total length:", len(content))
        
        # Save to local file
        with open('995xon.m3u', 'w', encoding='utf-8') as f:
            f.write(content)
        print("Saved complete file to 995xon.m3u")
        
        lines = content.splitlines()
        print("Total lines in file:", len(lines))
except Exception as e:
    print("Error:", e)
