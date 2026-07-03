import 'local_proxy_stub.dart'
    if (dart.library.html) 'local_proxy_web.dart';

class LocalProxy {
  static Future<void> start() => startProxy();
  static String getUrl(String url, Map<String, dynamic> headers) => getProxyUrl(url, headers);
  static void startKkx4Auth() => startKkx4AuthTimer();
  static void stopKkx4Auth() => stopKkx4AuthTimer();
}
