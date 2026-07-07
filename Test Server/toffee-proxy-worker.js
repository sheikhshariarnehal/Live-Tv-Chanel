/**
 * Cloudflare Worker: Toffee TV Channel Proxy & Playlist Server
 * Serves dynamic M3U playlists and proxies streaming requests with spoofed headers.
 */

const CHANNELS = [
  {
    "id": "toffee-sports-vip-toffee",
    "name": "TOFFEE Sports VIP",
    "logo": "https://images.toffeelive.com/images/program/19779/logo/240x240/mobile_logo_975410001725875598.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sports_highlights/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "toffee-movies-vip-toffee",
    "name": "TOFFEE Movies VIP",
    "logo": "https://images.toffeelive.com/images/program/2708/logo/240x240/mobile_logo_724353001725875591.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/toffee_movie/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "toffee-dramas-vip-toffee",
    "name": "TOFFEE Dramas VIP",
    "logo": "https://images.toffeelive.com/images/program/44878/logo/240x240/mobile_logo_764950001725875605.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/toffee_drama/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "cnn-vip-toffee",
    "name": "CNN VIP",
    "logo": "https://images.toffeelive.com/images/program/333/logo/240x240/mobile_logo_146607001735536058.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/cnn/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "somoy-tv-toffee",
    "name": "Somoy TV",
    "logo": "https://assets-prod.services.toffeelive.com//Xi_Ga5oBNnOkwJLWkhKP/posters/ef2899d5-1ae0-4fee-aee5-45f9b0b3ba80.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/somoy_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "independent-tv-toffee",
    "name": "Independent TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/ES_cZZsBNnOkwJLW1Oz1/posters/b872b8f5-cb6b-45a1-a1cd-7609df51d614.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/independent_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "desh-tv-toffee",
    "name": "Desh TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/6Hz1PJwBcqxnFHJBhgkV/posters/845f1e3f-987a-47cc-a48d-ee12d8f4d419.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/desh_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "jamuna-tv-toffee",
    "name": "Jamuna TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_640,q_75,f_webp/PiL635oBEef-9-uV2uCe/posters/36f380e0-6c71-4b27-a73b-2afb3ce7e982.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/jamuna_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "atn-news-toffee",
    "name": "ATN News",
    "logo": "https://assets-prod.services.toffeelive.com/w_640,q_75,f_webp/NCLx35oBEef-9-uVh-Dg/posters/af9773c7-7971-41a2-9b78-121fcb240c48.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/atn_news/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "atn-bangla-toffee",
    "name": "ATN Bangla",
    "logo": "https://assets-prod.services.toffeelive.com/w_640,q_75,f_webp/MCLv35oBEef-9-uVH-D2/posters/0d1e571c-ebb2-4277-9814-760a4f1603a6.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/atn_bangla/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "nexus-tv-toffee",
    "name": "Nexus TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/FHz5PJwBcqxnFHJBdAqW/posters/419869ac-8ddf-4909-86c1-b69f0a3adf13.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/nexus_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "movie-bangla-toffee",
    "name": "Movie Bangla",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/CXz4PJwBcqxnFHJBPwrG/posters/2f913e34-3a6c-45e6-9f1f-97bf129a2ff5.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/movie_bangla/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "mohona-tv-toffee",
    "name": "Mohona TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/-Xz3PJwBcqxnFHJBDAlE/posters/fecea361-8b60-4aeb-a530-6e27eee8178a.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/mohona_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "ananda-tv-toffee",
    "name": "Ananda TV",
    "logo": "https://assets-prod.services.toffeelive.com//wCM3l5sBEef-9-uVXFvD/posters/d80f7aee-5bd7-4edc-97eb-ead0e3ebbe09.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/anandatv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "bijoy-tv-toffee",
    "name": "Bijoy TV",
    "logo": "https://assets-prod.services.toffeelive.com//bns4l5sBcqxnFHJBVZ32/posters/feaf9f3d-cc3b-4a3d-81a3-2cb703e561eb.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/bijoytv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "global-tv-toffee",
    "name": "Global TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_640,q_75,f_webp/0y_tDJsBNnOkwJLWNrdE/posters/2ff058e1-630f-4657-8dc6-b677e65642c5.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/global_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "channel-s-toffee",
    "name": "Channel S",
    "logo": "https://assets-prod.services.toffeelive.com//WyPuDJsBEef-9-uVUA_z/posters/ea20055c-a824-443c-8083-ce8e2da8b922.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/channel_s/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "bangla-tv-toffee",
    "name": "Bangla TV",
    "logo": "https://assets-prod.services.toffeelive.com//JiK-_poBEef-9-uVZv6L/posters/757a328e-70d6-45de-b093-0a843c69ade7.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/bangla_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "asian-tv-toffee",
    "name": "Asian TV",
    "logo": "https://assets-prod.services.toffeelive.com//MyK__poBEef-9-uVmf5l/posters/1eadef5b-28e7-4dc2-b42f-c67a3357c9a0.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/asian_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "channel-i-toffee",
    "name": "Channel i",
    "logo": "https://assets-prod.services.toffeelive.com/w_640,q_75,f_webp/qnv835oBcqxnFHJBuQcB/posters/348dfac3-c1e0-485d-a72b-3d282c9e2c73.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/channel_i/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "ekhon-tv-toffee",
    "name": "Ekhon TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_640,q_75,f_webp/o3v235oBcqxnFHJBkAdC/posters/159af631-796d-4342-a2a7-c272f32bcd32.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/ekhon_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "rajdhani-tv-toffee",
    "name": "Rajdhani TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/KECGB54BuUSiBsg_dHyj/posters/d032f456-c7e8-4fd4-928b-ea5359960ed7.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/rajdhani_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "islamic-tv-toffee",
    "name": "Islamic TV",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/jehEA54BIxFjn23xAmdw/posters/f20b1b2e-3662-4da5-a71b-3f769d2a9a4e.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/islamic_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "ekattor-tv-toffee",
    "name": "Ekattor TV",
    "logo": "https://assets-prod.services.toffeelive.com//PS_La5oBNnOkwJLWLRN_/posters/e8c444fd-ee3b-4bf3-bb0a-f969bc295f82.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/ekattor_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "ban-vs-aus-toffee",
    "name": "BAN VS AUS",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/JOg0jZ4BIxFjn23xbePr/posters/683d682a-5589-48e4-b08c-1afe5dc9c3e4.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/BDVSAUS-26/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "fifa-wc-channel-1-toffee",
    "name": "FIFA WC Channel 1",
    "logo": "https://raw.githubusercontent.com/BINOD-XD/Toffee-Auto-Update-Playlist/refs/heads/main/FIFA%20WC%20Channel%201.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/FIFA-2026/sst/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "fifa-wc-channel-2-toffee",
    "name": "FIFA WC CHANNEL 2",
    "logo": "https://raw.githubusercontent.com/BINOD-XD/Toffee-Auto-Update-Playlist/refs/heads/main/FIFA%20WC%20Channel%202.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-2/sst/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "fifa-wc-channel-3-toffee",
    "name": "FIFA WC Channel 3",
    "logo": "https://raw.githubusercontent.com/BINOD-XD/Toffee-Auto-Update-Playlist/refs/heads/main/FIFA%20WC%20Channel%203.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-3/sst/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "fifa-wc-channel-4-toffee",
    "name": "FIFA WC Channel 4",
    "logo": "https://raw.githubusercontent.com/BINOD-XD/Toffee-Auto-Update-Playlist/refs/heads/main/FIFA%20WC%20Channel%204.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-4/sst/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "fifa-wc-channel-5-toffee",
    "name": "FIFA WC Channel 5",
    "logo": "https://raw.githubusercontent.com/BINOD-XD/Toffee-Auto-Update-Playlist/refs/heads/main/FIFA%20WC%20Channel%205.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-5/sst/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "wc-match-recap-toffee",
    "name": "WC Match Recap",
    "logo": "https://assets-prod.services.toffeelive.com/w_480,q_75,f_webp/V__o054BObUt2AG6LL5C/posters/84590b8d-6430-4ba8-a0a5-757bf2f57c05.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/FIFA-2026-6/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "euro-sport-hd-toffee",
    "name": "Euro Sport HD",
    "logo": "https://images.toffeelive.com/images/program/4388/logo/240x240/mobile_logo_422191001674119624.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/euro_sports_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "icc-test-championship-highlights-toffee",
    "name": "ICC Test Championship Highlights",
    "logo": "https://assets-prod.services.toffeelive.com/f_webp,w_400,q_100/PnZefJcBcqxnFHJBoxca/posters/955ae898-8336-4936-8d78-c6b8866e35f7.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/icc_wtc_final/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-sports-ten-1-hd-toffee",
    "name": "SONY SPORTS TEN 1 HD",
    "logo": "https://images.toffeelive.com/images/program/603/logo/240x240/mobile_logo_237244001666780563.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sony_sports_1_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-sports-ten-2-hd-toffee",
    "name": "SONY SPORTS TEN 2 HD",
    "logo": "https://images.toffeelive.com/images/program/604/logo/240x240/mobile_logo_093449001666780976.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sony_sports_2_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-sports-ten-5-hd-toffee",
    "name": "SONY SPORTS TEN 5 HD",
    "logo": "https://images.toffeelive.com/images/program/606/logo/240x240/mobile_logo_689539001672145843.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sony_sports_5_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-ten-cricket-toffee",
    "name": "SONY TEN Cricket",
    "logo": "https://images.toffeelive.com/images/program/301891/logo/240x240/mobile_logo_578686001735197654.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/ten_cricket/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "bfl-live-1-toffee",
    "name": "BFL Live 1",
    "logo": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRl6-ZPZ6UT3YhXilJF9fxtHzCqIt6mD71Dmg2_D-ZUsg&s=10",
    "url": "https://prod-cdn01-live.toffeelive.com/live/match-11<?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "bfl-live-2-toffee",
    "name": "BFL Live 2",
    "logo": "https://assets-prod.services.toffeelive.com//MXnGgJkBcqxnFHJBILyR/posters/035a24dd-4d88-4fc2-99a1-275a5bc97bf5.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/match-12/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "bfl-live-3-toffee",
    "name": "BFL Live 3",
    "logo": "https://assets-prod.services.toffeelive.com//LnlKhJkBcqxnFHJBU8GM/posters/74e6a7bb-f850-4ec5-991f-7a882b04db37.png",
    "url": "https://prod-cdn01-live.toffeelive.com/live/match-13/index.m3u8?edge-cache-token=Expires=1783399054~Starts=1783398994~URLPrefix=aHR0cHM6Ly9wcm9kLWNkbjAxLWxpdmUudG9mZmVlbGl2ZS5jb20~Signature=W7A-6q5gEyqpHVzom5CVL4LjJCfOu5EJQ74JrmlaoHbdgf5_Lo4mtcoFRDj-fHFzyApmrkIgEY4v34mWZTNRBQ",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36"
    }
  },
  {
    "id": "cartoon-network-hd-toffee",
    "name": "Cartoon Network HD",
    "logo": "https://images.toffeelive.com/images/program/26942/logo/240x240/mobile_logo_443429001678950505.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/cartoon_network_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "cartoon-network-toffee",
    "name": "Cartoon Network",
    "logo": "https://images.toffeelive.com/images/program/27232/logo/240x240/mobile_logo_320294001679201065.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/cartoon_network_sd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "pogo-toffee",
    "name": "Pogo",
    "logo": "https://images.toffeelive.com/images/program/27159/logo/240x240/mobile_logo_740957001679201029.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/pogo_sd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "discovery-kids-toffee",
    "name": "Discovery Kids",
    "logo": "https://images.toffeelive.com/images/program/611/logo/240x240/mobile_logo_430542001673177743.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/discovery_kids/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-yay-vip-toffee",
    "name": "SONY YAY VIP",
    "logo": "https://images.toffeelive.com/images/program/612/logo/240x240/mobile_logo_091186001666784752.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sonyyay/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-bangla-vip-toffee",
    "name": "Zee Bangla VIP",
    "logo": "https://images.toffeelive.com/images/program/340/logo/240x240/mobile_logo_094417001655891123.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_bangla/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-anmol-toffee",
    "name": "Zee Anmol",
    "logo": "https://assets-prod.services.toffeelive.com/f_webp,w_400,q_100/7x0Jd5YBEef-9-uVv_Gy/posters/f630a176-73cc-48d7-94cf-69ba0d201b36.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_anmol/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zing-toffee",
    "name": "Zing",
    "logo": "https://assets-prod.services.toffeelive.com/f_webp,w_400,q_100/DK8dd5YBrjBfS2_Ru22e/posters/a89a1e2e-677c-4a8a-9a66-dff5e0b921c8.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zing_sd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "hum-tv-toffee",
    "name": "Hum TV",
    "logo": "https://images.toffeelive.com/images/program/303937/logo/240x240/mobile_logo_880134001738072763.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/hum_tv/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "hum-masala-toffee",
    "name": "Hum Masala",
    "logo": "https://images.toffeelive.com/images/program/303947/logo/240x240/mobile_logo_203789001738235600.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/hum_masala/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "hum-sitarey-toffee",
    "name": "Hum Sitarey",
    "logo": "https://images.toffeelive.com/images/program/303948/logo/240x240/mobile_logo_350939001738236112.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/hum_sitaray/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-aat-vip-toffee",
    "name": "Sony Aat VIP",
    "logo": "https://images.toffeelive.com/images/program/343/logo/240x240/mobile_logo_496322001666780228.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sonyaath/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-entertainment-television-hd-vip-toffee",
    "name": "SONY ENTERTAINMENT TELEVISION HD VIP",
    "logo": "https://images.toffeelive.com/images/program/602/logo/240x240/mobile_logo_495351001666780441.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sonyentertainmnt_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-entertainment-television-toffee",
    "name": "SONY ENTERTAINMENT TELEVISION",
    "logo": "https://images.toffeelive.com/images/program/57/logo/240x240/mobile_logo_149299001666780350.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sony_entertainment/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "b4u-music-vip-toffee",
    "name": "B4U Music VIP",
    "logo": "https://images.toffeelive.com/images/program/367/logo/115x115/mobile_logo_886909001563629905.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/b4u_music/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-sab-hd-vip-toffee",
    "name": "SONY SAB HD VIP",
    "logo": "https://images.toffeelive.com/images/program/2420/logo/240x240/mobile_logo_688156001666785674.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sonysab_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-tv-hd-toffee",
    "name": "Zee TV HD",
    "logo": "https://images.toffeelive.com/images/program/644/logo/240x240/mobile_logo_649814001655891557.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_tv_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-max-hd-vip-toffee",
    "name": "SONY MAX HD VIP",
    "logo": "https://images.toffeelive.com/images/program/641/logo/240x240/mobile_logo_440775001666782769.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sony_max_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-bangla-cinema-toffee",
    "name": "Zee Bangla Cinema",
    "logo": "https://assets-prod.services.toffeelive.com/w_256,q_75,f_webp/-C7MX5UBv9knK3AHdKOi/posters/b0f0bfe0-f1f3-48b3-83ce-203cd44cafe2.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_bangla_cinema/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-bollywood-toffee",
    "name": "Zee Bollywood",
    "logo": "https://assets-prod.services.toffeelive.com/f_png,w_300,q_85/OnSlPJYBcqxnFHJB6lFX/posters/4818f95a-c64a-490f-b310-a49aec026d71.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_bollywood/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-action-toffee",
    "name": "Zee Action",
    "logo": "https://assets-prod.services.toffeelive.com/f_webp,w_400,q_100/Pc3RD5YBtpl-Sbt7doxr/posters/d0f337ab-a7e6-4eed-bc7b-7d51fdc70a0f.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_action/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-max-vip-toffee",
    "name": "SONY MAX VIP",
    "logo": "https://images.toffeelive.com/images/program/352/logo/240x240/mobile_logo_612341001666782969.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sony_max/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-pix-hd-vip-toffee",
    "name": "SONY PIX HD VIP",
    "logo": "https://images.toffeelive.com/images/program/2419/logo/240x240/mobile_logo_287412001666784602.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sonypix_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-cafe-toffee",
    "name": "Zee Cafe",
    "logo": "https://assets-prod.services.toffeelive.com/f_webp,w_400,q_100/U3QEd5YBcqxnFHJBpYzc/posters/3442d493-0c71-44b9-b12f-8e600d5eab91.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_cafe_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "b4u-movies-vip-toffee",
    "name": "B4U Movies VIP",
    "logo": "https://images.toffeelive.com/images/program/366/logo/240x240/mobile_logo_702115001663003759.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/b4u_movies/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-max-2-vip-toffee",
    "name": "SONY MAX 2 VIP",
    "logo": "https://images.toffeelive.com/images/program/353/logo/240x240/mobile_logo_044841001666779831.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sonymax_2/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-bangla-cinema-vip-toffee",
    "name": "Zee Bangla Cinema VIP",
    "logo": "https://images.toffeelive.com/images/program/403/logo/240x240/mobile_logo_368845001655891378.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_bangla_cinema/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "zee-cinema-hd-toffee",
    "name": "Zee Cinema HD",
    "logo": "https://images.toffeelive.com/images/program/804/logo/240x240/mobile_logo_370803001655891689.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/zee_cinema_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "tlc-hd-toffee",
    "name": "TLC HD",
    "logo": "https://images.toffeelive.com/images/program/608/logo/240x240/mobile_logo_648826001673178929.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/tlc_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "tlc-toffee",
    "name": "TLC",
    "logo": "https://images.toffeelive.com/images/program/358/logo/240x240/mobile_logo_048875001673178985.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/tlc_sd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "animal-planet-toffee",
    "name": "Animal Planet",
    "logo": "https://images.toffeelive.com/images/program/359/logo/240x240/mobile_logo_835681001673175607.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/animal_planet_sd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "animal-planet-hd-toffee",
    "name": "Animal Planet HD",
    "logo": "https://images.toffeelive.com/images/program/18096/logo/240x240/mobile_logo_032001001673194753.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/animal_planet_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "sony-bbc-earth-hd-vip-toffee",
    "name": "SONY BBC EARTH HD VIP",
    "logo": "https://images.toffeelive.com/images/program/670/logo/240x240/mobile_logo_892290001738663264.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/sonybbc_earth_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "discovery-hd-toffee",
    "name": "Discovery HD",
    "logo": "https://images.toffeelive.com/images/program/18093/logo/240x240/mobile_logo_868363001673181438.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/discovery_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "discovery-toffee",
    "name": "Discovery",
    "logo": "https://images.toffeelive.com/images/program/18097/logo/240x240/mobile_logo_297723001673195119.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/discovery_sd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "discovery-science-toffee",
    "name": "Discovery Science",
    "logo": "https://images.toffeelive.com/images/program/378/logo/240x240/mobile_logo_604754001673177502.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/discovery_science/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "discovery-turbo-toffee",
    "name": "Discovery Turbo",
    "logo": "https://images.toffeelive.com/images/program/379/logo/240x240/mobile_logo_775127001673177876.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/discovery_turbo/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "investigation-discovery-hd-toffee",
    "name": "Investigation Discovery HD",
    "logo": "https://images.toffeelive.com/images/program/18094/logo/240x240/mobile_logo_154805001673178308.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/discovary_investigation_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "tv-hd-toffee",
    "name": "&TV HD",
    "logo": "https://images.toffeelive.com/images/program/801/logo/240x240/mobile_logo_974516001655891652.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/and_tv_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  },
  {
    "id": "pictures-hd-toffee",
    "name": "& Pictures HD",
    "logo": "https://images.toffeelive.com/images/program/4570/logo/240x240/mobile_logo_000080001675856893.png",
    "url": "https://bldcmprod-cdn.toffeelive.com/cdn/live/andpicture_hd/playlist.m3u8",
    "headers": {
      "User-Agent": "Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36",
      "Cookie": "Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw"
    }
  }
];

export default {
  async fetch(request, env, ctx) {
    const urlObj = new URL(request.url);
    const path = urlObj.pathname;

    // Handle OPTIONS requests (CORS preflight)
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        status: 204,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, OPTIONS',
          'Access-Control-Allow-Headers': '*',
          'Access-Control-Max-Age': '86400'
        }
      });
    }

    // 1. Serve dynamic M3U playlist
    if (path === '/playlist.m3u' || (path === '/' && !urlObj.searchParams.has('url'))) {
      let m3u = '#EXTM3U\n\n';
      CHANNELS.forEach(ch => {
        m3u += `#EXTINF:-1 tvg-id="${ch.id}" tvg-name="${ch.name}" tvg-logo="${ch.logo}" group-title="Toffee", ${ch.name}\n`;
        m3u += `#KODIPROP:inputstream=inputstream.adaptive\n`;
        m3u += `#KODIPROP:inputstream.adaptive.manifest_type=hls\n`;
        m3u += `${urlObj.origin}/?url=${encodeURIComponent(ch.url)}\n\n`;
      });
      return new Response(m3u, {
        headers: {
          'Content-Type': 'text/plain; charset=utf-8',
          'Access-Control-Allow-Origin': '*'
        }
      });
    }

    // 2. Get target stream URL
    const targetUrl = urlObj.searchParams.get('url');
    if (!targetUrl) {
      return new Response('Toffee Proxy Worker is Active. Visit /playlist.m3u for your channel list.', {
        status: 200,
        headers: { 'Content-Type': 'text/plain' }
      });
    }

    // 3. Stream Proxy logic
    try {
      const targetUrlObj = new URL(targetUrl);
      const targetHostname = targetUrlObj.hostname;

      // Determine correct headers based on target URL domain
      let userAgent = 'Mozilla/5.0 (Linux; Android 9; Redmi S2 Build/PKQ1.181203.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36';
      let cookie = '';

      if (targetHostname.includes('bldcmprod-cdn.toffeelive.com')) {
        cookie = 'Edge-Cache-Cookie=URLPrefix=aHR0cHM6Ly9ibGRjbXByb2QtY2RuLnRvZmZlZWxpdmUuY29t:Expires=1783571793:KeyName=prod_linear:Signature=zc8k8QN255JwDQmME5lrTj9Mtupdg4gtzTf0rs6J32GpzE_-YLpqca3iXcKwPQOCEbgAnFDzHhrHjwCTDUkYAw';
      }

      const upstreamHeaders = {
        'User-Agent': userAgent,
        'Accept': request.headers.get('accept') || '*/*',
        'Accept-Language': request.headers.get('accept-language') || 'en-US,en;q=0.9',
        'Connection': 'keep-alive',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache'
      };

      if (cookie) {
        upstreamHeaders['Cookie'] = cookie;
      }

      const rangeHeader = request.headers.get('range');
      if (rangeHeader) {
        upstreamHeaders['Range'] = rangeHeader;
      }

      // Spoof Referer and Origin for the target host
      upstreamHeaders['Referer'] = `https://${targetHostname}/`;
      upstreamHeaders['Origin'] = `https://${targetHostname}`;

      const response = await fetch(targetUrl, {
        headers: upstreamHeaders,
        redirect: 'follow'
      });

      const responseHeaders = new Headers();
      const headersToCopy = ['content-type', 'cache-control', 'content-length', 'accept-ranges', 'content-range'];
      headersToCopy.forEach(h => {
        const val = response.headers.get(h);
        if (val) responseHeaders.set(h, val);
      });

      responseHeaders.set('Access-Control-Allow-Origin', '*');
      responseHeaders.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
      responseHeaders.set('Access-Control-Allow-Headers', '*');

      const contentType = response.headers.get('content-type') || '';
      const isM3u8 = contentType.includes('application/vnd.apple.mpegurl') || contentType.includes('application/x-mpegurl') || targetUrl.includes('.m3u8');

      // If it is HLS manifest, rewrite relative segment paths to flow through this proxy
      if (isM3u8) {
        const text = await response.text();
        const baseUrl = new URL(targetUrl);
        const basePath = baseUrl.origin + baseUrl.pathname.substring(0, baseUrl.pathname.lastIndexOf('/') + 1);
        const proxyPrefix = `${urlObj.origin}/?url=`;

        const rewrittenLines = text.split('\n').map(line => {
          line = line.trim();
          if (line && !line.startsWith('#')) {
            let absoluteUrl = line;
            if (!line.startsWith('http')) {
              absoluteUrl = line.startsWith('/') ? baseUrl.origin + line : basePath + line;
            }
            if (baseUrl.search && !absoluteUrl.includes('?')) {
              absoluteUrl += baseUrl.search;
            }
            return proxyPrefix + encodeURIComponent(absoluteUrl);
          }
          if (line.startsWith('#EXT-X-KEY') || line.startsWith('#EXT-X-MAP')) {
            return line.replace(/URI="([^"]+)"/, (match, uri) => {
              let absoluteUrl = uri;
              if (!uri.startsWith('http')) {
                absoluteUrl = uri.startsWith('/') ? baseUrl.origin + uri : basePath + uri;
              }
              if (baseUrl.search && !absoluteUrl.includes('?')) {
                absoluteUrl += baseUrl.search;
              }
              return `URI="${proxyPrefix}${encodeURIComponent(absoluteUrl)}"`;
            });
          }
          return line;
        });

        responseHeaders.set('content-type', 'application/vnd.apple.mpegurl');
        return new Response(rewrittenLines.join('\n'), {
          status: response.status,
          headers: responseHeaders
        });
      }

      // Stream segments / TS chunks passthrough
      if (response.ok) {
        responseHeaders.set('Cache-Control', 'public, max-age=6');
      }

      return new Response(response.body, {
        status: response.status,
        headers: responseHeaders
      });

    } catch (err) {
      return new Response(JSON.stringify({
        error: err.message || 'Fetch failed',
        stack: err.stack
      }), {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        }
      });
    }
  }
};
