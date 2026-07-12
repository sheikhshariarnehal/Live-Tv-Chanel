import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Internet reachability states.
///
/// [ConnectivityService] reports these after verifying actual internet access
/// via lightweight HTTP HEAD requests — never trusting the OS connectivity
/// signal alone.
enum InternetState {
  /// Device has verified internet access.
  available,

  /// No network interface or verified unreachable.
  noInternet,

  /// Connected to a network but intercepted by a captive portal.
  captivePortal,

  /// DNS resolution is failing.
  dnsFailure,

  /// Not yet determined.
  unknown,
}

/// Detects real internet availability using HTTP HEAD probes.
///
/// The OS-level connectivity signal (Wi-Fi connected, mobile data on) is used
/// only as a *fast hint*. Every state change is verified by actually reaching
/// a known endpoint before being trusted.
///
/// Usage:
/// ```dart
/// final cs = ConnectivityService();
/// await cs.initialize();
/// cs.stateNotifier.addListener(() {
///   print(cs.state); // InternetState.available / .noInternet / ...
/// });
/// ```
class ConnectivityService {
  ConnectivityService();

  /// Current verified internet state.
  InternetState get state => _stateNotifier.value;

  /// Listenable notifier for UI / state-machine binding.
  ValueNotifier<InternetState> get stateNotifier => _stateNotifier;

  final ValueNotifier<InternetState> _stateNotifier =
      ValueNotifier(InternetState.unknown);

  /// Stream that emits only when the state actually changes.
  Stream<InternetState> get stream => _controller.stream;
  final StreamController<InternetState> _controller =
      StreamController<InternetState>.broadcast();

  Timer? _pollingTimer;
  bool _disposed = false;

  // Endpoints for reachability probes (fast, globally distributed).
  static const _probeUrls = [
    'https://connectivitycheck.gstatic.com/generate_204', // Google
    'https://clients3.google.com/generate_204', // Google fallback
    'https://cp.cloudflare.com/', // Cloudflare
  ];

  /// Start monitoring. Call once at app startup or when entering the player.
  Future<void> initialize() async {
    if (_disposed) return;
    // Immediate check
    await checkNow();
    // Poll every 10 seconds while active
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!_disposed) checkNow();
    });
  }

  /// Perform an on-demand reachability check. Returns the verified state.
  Future<InternetState> checkNow() async {
    if (_disposed) return InternetState.unknown;

    try {
      final result = await _probeReachability();
      _updateState(result);
      return result;
    } catch (e) {
      _updateState(InternetState.noInternet);
      return InternetState.noInternet;
    }
  }

  void _updateState(InternetState newState) {
    if (_disposed) return;
    if (_stateNotifier.value != newState) {
      _stateNotifier.value = newState;
      _controller.add(newState);
      debugPrint('ConnectivityService: state → $newState');
    }
  }

  /// Try multiple endpoints. If any succeeds, we have internet.
  Future<InternetState> _probeReachability() async {
    for (final url in _probeUrls) {
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 5);
        final request = await client.headUrl(Uri.parse(url));
        final response = await request.close().timeout(
              const Duration(seconds: 5),
            );
        await response.drain<void>();
        client.close(force: true);

        final code = response.statusCode;

        // 204 or 200 = real internet
        if (code == 204 || code == 200) {
          return InternetState.available;
        }

        // 302/301 redirect to login page = captive portal
        if (code == 301 || code == 302) {
          final location = response.headers.value('location') ?? '';
          if (location.isNotEmpty && !_probeUrls.any((u) => location.startsWith(u))) {
            return InternetState.captivePortal;
          }
        }
      } on SocketException {
        // Continue to next endpoint
        continue;
      } on HandshakeException {
        // TLS issue — likely captive portal intercepting HTTPS
        return InternetState.captivePortal;
      } on TimeoutException {
        // Continue to next endpoint
        continue;
      } catch (_) {
        continue;
      }
    }

    // All endpoints failed — check if it's DNS specifically
    try {
      await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      // DNS works but HTTP doesn't — likely firewall/captive portal
      return InternetState.captivePortal;
    } on SocketException {
      return InternetState.noInternet;
    } on TimeoutException {
      return InternetState.dnsFailure;
    } catch (_) {
      return InternetState.noInternet;
    }
  }

  /// Convenience: is internet currently verified as available?
  bool get isOnline => state == InternetState.available;

  /// Convenience: is internet currently unavailable?
  bool get isOffline => state != InternetState.available;

  void dispose() {
    _disposed = true;
    _pollingTimer?.cancel();
    _controller.close();
    _stateNotifier.dispose();
  }
}
