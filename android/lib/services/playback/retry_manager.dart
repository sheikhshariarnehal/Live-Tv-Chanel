import 'dart:async';

import 'package:flutter/foundation.dart';
import 'error_classifier.dart';

/// Manages exponential-backoff retries with proper cancellation.
///
/// Each retry attempt waits `baseDelay * backoffMultiplier^attempt` capped
/// at [RetryConfig.maxDelay]. Timers are properly cancelled on dispose,
/// channel switch, or when playback recovers.
///
/// Usage:
/// ```dart
/// final rm = RetryManager();
/// rm.scheduleRetry(
///   config: RetryConfig(maxAttempts: 3, baseDelay: Duration(seconds: 2)),
///   attempt: 1,
///   onRetry: () => playbackStateMachine.retryPlayback(),
/// );
/// // Cancel at any time:
/// rm.cancel();
/// ```
class RetryManager {
  RetryManager();

  Timer? _retryTimer;
  bool _cancelled = false;
  int _currentAttempt = 0;

  /// Whether a retry is currently scheduled (timer running).
  bool get isRetrying => _retryTimer?.isActive == true;

  /// The current attempt number (0 = no retries yet).
  int get currentAttempt => _currentAttempt;

  /// Schedule a retry attempt with exponential backoff.
  ///
  /// Returns `true` if a retry was scheduled, `false` if max attempts exceeded.
  bool scheduleRetry({
    required RetryConfig config,
    required int attempt,
    required VoidCallback onRetry,
  }) {
    _cancelled = false;
    _currentAttempt = attempt;

    if (attempt > config.maxAttempts) {
      debugPrint('RetryManager: max attempts (${config.maxAttempts}) exceeded');
      return false;
    }

    final delay = getDelay(config, attempt);
    debugPrint('RetryManager: scheduling retry $attempt/${config.maxAttempts} '
        'in ${delay.inMilliseconds}ms');

    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () {
      if (!_cancelled) {
        debugPrint('RetryManager: executing retry $attempt');
        onRetry();
      }
    });

    return true;
  }

  /// Calculate the delay for a given attempt using exponential backoff.
  ///
  /// attempt 1 → baseDelay * 1     (2s)
  /// attempt 2 → baseDelay * 2     (4s)
  /// attempt 3 → baseDelay * 4     (8s)
  /// ...capped at maxDelay
  Duration getDelay(RetryConfig config, int attempt) {
    if (attempt <= 1) return config.baseDelay;

    final multiplier = _pow(config.backoffMultiplier, attempt - 1);
    final delayMs = (config.baseDelay.inMilliseconds * multiplier).round();
    final cappedMs = delayMs.clamp(0, config.maxDelay.inMilliseconds);
    return Duration(milliseconds: cappedMs);
  }

  /// Cancel any pending retry timer.
  void cancel() {
    _cancelled = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    debugPrint('RetryManager: cancelled');
  }

  /// Reset attempt counter and cancel any pending timer.
  void reset() {
    cancel();
    _currentAttempt = 0;
  }

  void dispose() {
    cancel();
  }

  /// Integer power for doubles (dart:math pow returns num).
  static double _pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
