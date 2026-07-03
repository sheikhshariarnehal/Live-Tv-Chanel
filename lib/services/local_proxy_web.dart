Future<void> startProxy() async {
  // No-op on web
}

String getProxyUrl(String url, Map<String, dynamic> headers) {
  // Return original URL on web (handled by MSE/blob converter)
  return url;
}

void startKkx4AuthTimer() {
  // No-op on web
}

void stopKkx4AuthTimer() {
  // No-op on web
}
