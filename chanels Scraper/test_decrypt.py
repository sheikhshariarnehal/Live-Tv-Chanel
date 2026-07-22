import base64
import urllib.request
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad

def decrypt_cricfy_content(content_str):
    trimmed = content_str.strip()
    if trimmed.startswith("#EXTM3U") or trimmed.startswith("#EXTINF") or trimmed.startswith("#KODIPROP"):
        return trimmed

    if len(trimmed) < 79:
        return trimmed

    # Extract IV, Key, and Encrypted Data segments
    part1 = trimmed[0:10]
    part2 = trimmed[34:-54]
    part3 = trimmed[-10:]
    encrypted_base64 = part1 + part2 + part3

    iv_base64 = trimmed[10:34]
    key_base64 = trimmed[-54:-10]

    # Decode from base64 to bytes
    iv_bytes = base64.b64decode(iv_base64)
    key_bytes = base64.b64decode(key_base64)
    encrypted_bytes = base64.b64decode(encrypted_base64)

    # Decrypt AES-CBC-PKCS5
    cipher = AES.new(key_bytes, AES.MODE_CBC, iv_bytes)
    decrypted_bytes = cipher.decrypt(encrypted_bytes)
    
    # Unpad PKCS5/PKCS7
    unpadded = unpad(decrypted_bytes, AES.block_size)
    return unpadded.decode('utf-8')

def main():
    # Test one of Cricfy's known endpoint links
    url = "https://playlist-cricfy.noobon.top/toffee.php"
    print(f"Fetching from {url}...")
    headers = {'User-Agent': 'Mozilla/5.0'}
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            content = response.read().decode('utf-8')
            print("Fetched content of length:", len(content))
            print("Beginning of response:", content[:100])
            
            print("\nDecrypting...")
            decrypted = decrypt_cricfy_content(content)
            print("Successfully decrypted! Decrypted length:", len(decrypted))
            print("\nFirst 1000 characters of decrypted playlist:")
            print(decrypted[:1000])
            
            with open('decrypted_toffee.m3u', 'w', encoding='utf-8') as f:
                f.write(decrypted)
            print("\nSaved output to decrypted_toffee.m3u")
    except Exception as e:
        print("Error:", e)

if __name__ == '__main__':
    main()
