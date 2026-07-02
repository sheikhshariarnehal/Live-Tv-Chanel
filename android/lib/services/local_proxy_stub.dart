import 'dart:io';
import 'dart:convert';
import 'dart:async';

HttpServer? _server;
int _port = 0;

DateTime? _lastKkx4AuthTime;
bool _isAuthorizingKkx4 = false;
Timer? _kkx4AuthTimer;

Future<void> _authorizeKkx4IP() async {
  if (_isAuthorizingKkx4) return;
  _isAuthorizingKkx4 = true;
  
  try {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 3);
    
    final request = await client.getUrl(Uri.parse('https://kkx4.livekhelatv.com/'))
        .timeout(const Duration(seconds: 3));
        
    request.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
    request.headers.set('Referer', 'https://kkx4.livekhelatv.com/');
    
    final response = await request.close()
        .timeout(const Duration(seconds: 3));
        
    await response.drain()
        .timeout(const Duration(seconds: 3));
        
    _lastKkx4AuthTime = DateTime.now();
    print('IP Authorization for kkx4 completed with status: ${response.statusCode}');
  } catch (e) {
    print('IP Authorization failed: $e');
  } finally {
    _isAuthorizingKkx4 = false;
  }
}

void startKkx4AuthTimer() {
  if (_kkx4AuthTimer != null) return;
  print('Starting periodic IP authorization timer for Toffee CDN...');
  
  // Run once immediately
  _authorizeKkx4IP();
  
  // Run every 5 seconds to keep IP authorization alive
  _kkx4AuthTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
    try {
      await _authorizeKkx4IP();
    } catch (e) {
      print('Background Timer IP authorization error: $e');
    }
  });
}

void stopKkx4AuthTimer() {
  _kkx4AuthTimer?.cancel();
  _kkx4AuthTimer = null;
  print('Stopped periodic IP authorization timer.');
}

Future<void> startProxy() async {
  try {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _port = _server!.port;
    print('Local Proxy Server started on port $_port');

    _server!.listen((HttpRequest request) async {
      print('Local Proxy: Incoming request: ${request.uri.path}');
      String? targetUrlStr;
      Map<String, String> customHeaders = {};

      if (request.uri.path.startsWith('/proxy/')) {
        // Path-based proxy format: /proxy/<base64_headers>/<scheme>/<rest_of_url>
        final segments = request.uri.pathSegments;
        if (segments.length >= 4) {
          final base64Headers = segments[1];
          final targetScheme = segments[2];
          final targetPath = segments.sublist(3).join('/');
          final queryStr = request.uri.hasQuery ? '?${request.uri.query}' : '';
          targetUrlStr = '$targetScheme://$targetPath$queryStr';

          if (base64Headers.isNotEmpty) {
            try {
              var normalizedB64 = base64Headers;
              while (normalizedB64.length % 4 != 0) {
                normalizedB64 += '=';
              }
              final jsonStr = utf8.decode(base64Url.decode(normalizedB64));
              final parsed = jsonDecode(jsonStr);
              if (parsed is Map) {
                parsed.forEach((k, v) {
                  customHeaders[k.toString()] = v.toString();
                });
              }
            } catch (e) {
              print('Error decoding proxy headers: $e');
            }
          }
        }
      } else if (request.uri.path == '/proxy') {
        // Legacy query-based format
        targetUrlStr = request.uri.queryParameters['url'];
        final headersJson = request.uri.queryParameters['headers'];
        if (headersJson != null) {
          try {
            final parsed = jsonDecode(headersJson);
            if (parsed is Map) {
              parsed.forEach((k, v) {
                customHeaders[k.toString()] = v.toString();
              });
            }
          } catch (_) {}
        }
      }

      if (targetUrlStr == null) {
        request.response.statusCode = HttpStatus.badRequest;
        request.response.write('Invalid proxy request format');
        await request.response.close();
        return;
      }

      final targetUrl = Uri.parse(targetUrlStr);

      try {
        // Run IP Authorization if needed (e.g., kkx4 authorization for Toffee CDN)
        if (targetUrlStr.contains('otte.cache.aiv-cdn.net')) {
          if (_lastKkx4AuthTime == null) {
            startKkx4AuthTimer();
            // Await a short moment for the first background auth request to complete
            await Future.delayed(const Duration(milliseconds: 800));
          } else {
            startKkx4AuthTimer();
          }
        }

        final client = HttpClient();
        client.autoUncompress = true;

        final clientRequest = await client.openUrl(request.method, targetUrl);

        // Copy only standard safe headers from the incoming request.
        // This strips non-standard headers like 'icy-metadata' which cause CDNs (like Varnish) to reject requests.
        const allowedHeaders = {
          'user-agent',
          'referer',
          'range',
          'accept',
          'accept-encoding',
          'accept-language',
          'authorization',
          'origin',
        };

        request.headers.forEach((name, values) {
          final nameLower = name.toLowerCase();
          if (allowedHeaders.contains(nameLower)) {
            for (var val in values) {
              clientRequest.headers.add(name, val);
            }
          }
        });

        // Override with custom headers (Referer, User-Agent, etc.)
        customHeaders.forEach((name, val) {
          clientRequest.headers.set(name, val);
        });

        // Set default headers for specific CDNs if they are not explicitly specified
        if (targetUrlStr.contains('otte.cache.aiv-cdn.net')) {
          final hasReferer = customHeaders.keys.any((k) => k.toLowerCase() == 'referer');
          final hasUA = customHeaders.keys.any((k) => k.toLowerCase() == 'user-agent');
          if (!hasReferer) {
            clientRequest.headers.set('Referer', 'https://kkx4.livekhelatv.com/');
          }
          if (!hasUA) {
            clientRequest.headers.set('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
          }
        }

        // Strip content-length for GET/HEAD requests to prevent CDNs from rejecting them
        if (request.method.toUpperCase() == 'GET' || request.method.toUpperCase() == 'HEAD') {
          clientRequest.contentLength = -1;
          clientRequest.headers.removeAll(HttpHeaders.contentLengthHeader);
        }

        // Print sent headers for debugging
        final sentHeaders = <String, String>{};
        clientRequest.headers.forEach((name, values) {
          sentHeaders[name] = values.join(', ');
        });
        print('Local Proxy: Routing request to: $targetUrlStr');
        print('Local Proxy: Sent headers: $sentHeaders');

        // Forward request body if present
        if (request.contentLength > 0) {
          await clientRequest.addStream(request.cast<List<int>>());
        }

        final clientResponse = await clientRequest.close();
        print('Local Proxy: CDN response status: ${clientResponse.statusCode}');
        final respHeaders = <String, String>{};
        clientResponse.headers.forEach((name, values) {
          respHeaders[name] = values.join(', ');
        });
        print('Local Proxy: CDN response headers: $respHeaders');

        // Intercept and print error body from upstream CDN
        if (clientResponse.statusCode >= 400) {
          final bytes = await clientResponse.fold<List<int>>([], (p, e) => p..addAll(e));
          final bodyString = utf8.decode(bytes, allowMalformed: true);
          print('Local Proxy: CDN error body (status ${clientResponse.statusCode}): $bodyString');

          clientResponse.headers.forEach((name, values) {
            final nameLower = name.toLowerCase();
            if (nameLower != HttpHeaders.connectionHeader.toLowerCase() &&
                nameLower != HttpHeaders.transferEncodingHeader.toLowerCase()) {
              for (var val in values) {
                request.response.headers.add(name, val);
              }
            }
          });

          request.response.statusCode = clientResponse.statusCode;
          request.response.add(bytes);
          await request.response.close();
          return;
        }

        // Copy response status and headers
        request.response.statusCode = clientResponse.statusCode;
        
        // If the clientResponse was decompressed by Dart, the Content-Encoding is stripped
        // and the Content-Length is no longer accurate.
        final isDecompressed = clientResponse.headers.value(HttpHeaders.contentEncodingHeader) != null;

        clientResponse.headers.forEach((name, values) {
          final nameLower = name.toLowerCase();
          // Skip Content-Encoding and Content-Length if body is decompressed
          if (isDecompressed && 
              (nameLower == HttpHeaders.contentEncodingHeader.toLowerCase() || 
               nameLower == HttpHeaders.contentLengthHeader.toLowerCase())) {
            return;
          }
          // Skip connection/transfer-encoding headers as they are handled by the server
          if (nameLower == HttpHeaders.connectionHeader.toLowerCase() ||
              nameLower == HttpHeaders.transferEncodingHeader.toLowerCase()) {
            return;
          }
          for (var val in values) {
            request.response.headers.add(name, val);
          }
        });

        // Check if the response is an M3U8 playlist
        final contentType = clientResponse.headers.value(HttpHeaders.contentTypeHeader) ?? '';
        final isM3u8 = contentType.contains('mpegurl') ||
            contentType.contains('m3u8') ||
            targetUrl.path.toLowerCase().endsWith('.m3u8');

        if (isM3u8) {
          final bytes = await clientResponse.fold<List<int>>([], (p, e) => p..addAll(e));
          final content = utf8.decode(bytes, allowMalformed: true);

          final rewrittenContent = _rewriteM3u8(content, targetUrlStr, customHeaders);
          request.response.headers.set(HttpHeaders.contentLengthHeader, utf8.encode(rewrittenContent).length.toString());
          request.response.write(rewrittenContent);
          await request.response.close();
        } else {
          // Stream response directly to player (e.g. .ts, .key, .m4s, .mpd, etc.)
          await clientResponse.pipe(request.response);
        }
      } catch (e) {
        print('Local Proxy Error fetching $targetUrlStr: $e');
        try {
          request.response.statusCode = HttpStatus.internalServerError;
          request.response.write('Error: $e');
        } catch (_) {
          // Headers already sent, ignore status/write exceptions
        } finally {
          try {
            await request.response.close();
          } catch (_) {}
        }
      }
    });
  } catch (e) {
    print('Failed to start Local Proxy Server: $e');
  }
}

String getProxyUrl(String url, Map<String, dynamic> headers) {
  if (_port == 0) return url; // Fallback if server failed to start
  
  final jsonHeaders = jsonEncode(headers);
  final base64Headers = base64Url.encode(utf8.encode(jsonHeaders)).replaceAll('=', '');
  
  final uri = Uri.parse(url);
  final scheme = uri.scheme;
  if (scheme != 'http' && scheme != 'https') return url;
  
  final rest = url.substring(scheme.length + 3); // strip 'http://' or 'https://'
  return 'http://127.0.0.1:$_port/proxy/$base64Headers/$scheme/$rest';
}

String _rewriteM3u8(String manifest, String baseManifestUrl, Map<String, String> headers) {
  final lines = LineSplitter.split(manifest).toList();
  final baseUri = Uri.parse(baseManifestUrl);

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    if (line.startsWith('#')) {
      if (line.contains('URI=')) {
        final match = RegExp(r'URI="([^"]+)"').firstMatch(line);
        if (match != null) {
          final extractedUrl = match.group(1)!;
          final absoluteUrl = baseUri.resolve(extractedUrl).toString();
          final proxyUrl = getProxyUrl(absoluteUrl, headers);
          lines[i] = line.replaceFirst('URI="$extractedUrl"', 'URI="$proxyUrl"');
        }
      }
    } else {
      // It is a stream/segment URI
      final absoluteUrl = baseUri.resolve(line).toString();
      final proxyUrl = getProxyUrl(absoluteUrl, headers);
      lines[i] = proxyUrl;
    }
  }

  return lines.join('\n');
}
