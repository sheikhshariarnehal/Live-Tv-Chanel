import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../models/channel.dart';
import 'circuit_breaker.dart';

/// Controls the skip decision with a user-interruptible countdown.
///
/// Instead of silently and instantly skipping channels, [AutoSkipManager]
/// shows a countdown (default 5 seconds) during which the user can:
/// - **Cancel** — stops the skip, shows error screen with retry button.
/// - **Skip Now** — immediately advances to the next channel.
///
/// When selecting the next channel, it consults the [CircuitBreaker] to
/// avoid channels with open circuits (known-dead channels).
class AutoSkipManager {
  AutoSkipManager({
    this.defaultCountdownSeconds = 5,
  });

  final int defaultCountdownSeconds;

  Timer? _countdownTimer;
  int _secondsRemaining = 0;
  VoidCallback? _onSkip;
  VoidCallback? _onTick;
  bool _isSkipping = false;

  /// Whether a skip countdown is currently active.
  bool get isSkipping => _isSkipping;

  /// Seconds remaining in the current countdown.
  int get secondsRemaining => _secondsRemaining;

  /// Start a skip countdown. Calls [onSkip] when countdown reaches zero.
  /// Calls [onTick] on each second for UI updates.
  void startCountdown({
    int? durationSeconds,
    required VoidCallback onSkip,
    VoidCallback? onTick,
  }) {
    cancel(); // Cancel any existing countdown

    _secondsRemaining = durationSeconds ?? defaultCountdownSeconds;
    _onSkip = onSkip;
    _onTick = onTick;
    _isSkipping = true;

    debugPrint('AutoSkipManager: starting $defaultCountdownSeconds countdown');

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      _onTick?.call();

      if (_secondsRemaining <= 0) {
        timer.cancel();
        _isSkipping = false;
        debugPrint('AutoSkipManager: countdown finished — executing skip');
        _onSkip?.call();
      }
    });
  }

  /// Cancel the skip countdown. The user chose to stay.
  void cancel() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _isSkipping = false;
    _secondsRemaining = 0;
    _onSkip = null;
    _onTick = null;
  }

  /// Skip immediately without waiting for countdown.
  void skipNow() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _isSkipping = false;
    _secondsRemaining = 0;
    final callback = _onSkip;
    _onSkip = null;
    _onTick = null;
    if (callback != null) {
      debugPrint('AutoSkipManager: user requested immediate skip');
      callback();
    }
  }

  /// Select the next channel from the related channels list.
  ///
  /// Skips channels whose circuit breakers are open (known-dead).
  /// Returns `null` if no valid next channel is found.
  String? selectNextChannel({
    required String currentChannelId,
    required List<Channel> relatedChannels,
    required CircuitBreaker circuitBreaker,
  }) {
    if (relatedChannels.isEmpty) return null;

    final currentIndex = relatedChannels.indexWhere(
      (c) => c.id == currentChannelId,
    );

    if (currentIndex == -1) return null;

    // Search forward from current position
    for (int i = currentIndex + 1; i < relatedChannels.length; i++) {
      final candidate = relatedChannels[i];
      if (!circuitBreaker.isOpen(candidate.id)) {
        debugPrint('AutoSkipManager: selected next channel '
            '${candidate.name} (index $i)');
        return candidate.id;
      }
      debugPrint('AutoSkipManager: skipping ${candidate.name} '
          '(circuit open)');
    }

    // Search backward from current position
    for (int i = currentIndex - 1; i >= 0; i--) {
      final candidate = relatedChannels[i];
      if (!circuitBreaker.isOpen(candidate.id)) {
        debugPrint('AutoSkipManager: selected prev channel '
            '${candidate.name} (index $i)');
        return candidate.id;
      }
    }

    debugPrint('AutoSkipManager: no valid channels found');
    return null;
  }

  void dispose() {
    cancel();
  }
}
