import 'dart:io';
import 'dart:convert';

HttpServer? _server;
int _port = 0;

Future<void> startProxy() async {
  try {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _port = _server!.port;
    print('Local Proxy Server started on port $_port');

    _server!.listen((HttpRequest request) async {
      if (request.uri.path == '/proxy') {
        final targetUrlStr = request.uri.queryParameters['url'];
        final headersJson = request.uri.queryParameters['headers'];

        if (targetUrlStr == null) {
          request.response.statusCode = HttpStatus.badRequest;
          request.response.write('Missing url parameter');
          await request.response.close();
          return;
        }

        final targetUrl = Uri.parse(targetUrlStr);
        Map<String, String> customHeaders = {};
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

        try {
          final client = HttpClient();
          client.autoUncompress = true;

          final clientRequest = await client.openUrl(request.method, targetUrl);

          // Copy headers from incoming request (User-Agent, Range, etc.)
          request.headers.forEach((name, values) {
            if (name.toLowerCase() != 'host' && name.toLowerCase() != 'connection') {
              for (var val in values) {
                clientRequest.headers.add(name, val);
              }
            }
          });

          // Override with our custom headers (Referer, User-Agent, etc.)
          customHeaders.forEach((name, val) {
            clientRequest.headers.set(name, val);
          });

          // Forward request body if present
          if (request.contentLength > 0) {
            await clientRequest.addStream(request.cast<List<int>>());
          }

          final clientResponse = await clientRequest.close();

          // Copy response status and headers
          request.response.statusCode = clientResponse.statusCode;
          clientResponse.headers.forEach((name, values) {
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
            // Read manifest text, rewrite URIs, and write back
            final bytes = await clientResponse.fold<List<int>>([], (p, e) => p..addAll(e));
            final content = utf8.decode(bytes, allowMalformed: true);

            final rewrittenContent = _rewriteM3u8(content, targetUrlStr, customHeaders);
            request.response.headers.set(HttpHeaders.contentLengthHeader, utf8.encode(rewrittenContent).length.toString());
            request.response.write(rewrittenContent);
            await request.response.close();
          } else {
            // Stream response directly to player (e.g. .ts, .key, etc.)
            await clientResponse.pipe(request.response);
          }
        } catch (e) {
          print('Local Proxy Error fetching $targetUrlStr: $e');
          request.response.statusCode = HttpStatus.internalServerError;
          request.response.write('Error: $e');
          await request.response.close();
        }
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Not found');
        await request.response.close();
      }
    });
  } catch (e) {
    print('Failed to start Local Proxy Server: $e');
  }
}

String getProxyUrl(String url, Map<String, dynamic> headers) {
  if (_port == 0) return url; // Fallback if server failed to start
  return 'http://127.0.0.1:$_port/proxy?url=${Uri.encodeComponent(url)}&headers=${Uri.encodeComponent(jsonEncode(headers))}';
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
