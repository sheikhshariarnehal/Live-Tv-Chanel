import 'dart:async';

import 'package:flutter/foundation.dart';

/// A snapshot of the player's buffer state at a point in time.
class BufferSnapshot {
  final Duration bufferedPosition;
  final Duration position;
  final DateTime timestamp;

  const BufferSnapshot({
    required this.bufferedPosition,
    required this.position,
    required this.timestamp,
  });
}

/// Monitors buffer health by tracking actual data progress, not just time.
///
/// Unlike a simple timeout-based watchdog, [BufferMonitor] checks whether
/// [bufferedPosition] is increasing between consecutive snapshots. If the
/// buffer is growing (even slowly), the stream is alive and we should NOT
/// skip — the user just has a slow connection.
///
/// A stall is only declared when *no buffer progress* has been made for
/// [stalledThreshold] duration (default 20 seconds).
class BufferMonitor {
  BufferMonitor({
    this.stalledThreshold = const Duration(seconds: 20),
  });

  /// How long the buffer must show zero progress before declaring a stall.
  final Duration stalledThreshold;

  BufferSnapshot? _lastSnapshot;
  DateTime? _lastProgressTime;
  bool _isProgressing = false;
  bool _isMonitoring = false;

  Timer? _stallCheckTimer;

  final StreamController<Duration> _stallController =
      StreamController<Duration>.broadcast();

  /// Whether buffer data is currently growing.
  bool get isProgressing => _isProgressing;

  /// Whether monitoring is active.
  bool get isMonitoring => _isMonitoring;

  /// Time since last observed buffer progress.
  Duration get stallDuration {
    if (_lastProgressTime == null) return Duration.zero;
    return DateTime.now().difference(_lastProgressTime!);
  }

  /// Emits [stallDuration] when buffer has been stalled for >= [stalledThreshold].
  Stream<Duration> get onStalled => _stallController.stream;

  /// Start monitoring. Call when player enters buffering state.
  void startMonitoring() {
    _isMonitoring = true;
    _lastProgressTime = DateTime.now();
    _lastSnapshot = null;
    _isProgressing = false;

    _stallCheckTimer?.cancel();
    _stallCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkForStall();
    });

    debugPrint('BufferMonitor: started monitoring');
  }

  /// Feed a new buffer snapshot. Call on every progress update from ExoPlayer.
  void update(BufferSnapshot snapshot) {
    if (!_isMonitoring) return;

    final prev = _lastSnapshot;
    _lastSnapshot = snapshot;

    if (prev == null) {
      // First snapshot — mark as progress
      _lastProgressTime = snapshot.timestamp;
      _isProgressing = true;
      return;
    }

    // Check if buffered position has grown (even by 1ms)
    final bufferGrew =
        snapshot.bufferedPosition > prev.bufferedPosition;

    if (bufferGrew) {
      _lastProgressTime = snapshot.timestamp;
      if (!_isProgressing) {
        _isProgressing = true;
        debugPrint('BufferMonitor: buffer is progressing again');
      }
    } else {
      if (_isProgressing) {
        _isProgressing = false;
        debugPrint('BufferMonitor: buffer stalled at '
            '${snapshot.bufferedPosition.inMilliseconds}ms');
      }
    }
  }

  /// Stop monitoring. Call when playback starts or channel changes.
  void stopMonitoring() {
    _isMonitoring = false;
    _stallCheckTimer?.cancel();
    _stallCheckTimer = null;
    _isProgressing = false;
    debugPrint('BufferMonitor: stopped monitoring');
  }

  /// Reset all state. Call on channel switch.
  void reset() {
    stopMonitoring();
    _lastSnapshot = null;
    _lastProgressTime = null;
  }

  void _checkForStall() {
    if (!_isMonitoring || _lastProgressTime == null) return;

    final stall = DateTime.now().difference(_lastProgressTime!);
    if (stall >= stalledThreshold && !_isProgressing) {
      debugPrint('BufferMonitor: STALL detected — no progress for '
          '${stall.inSeconds}s (threshold: ${stalledThreshold.inSeconds}s)');
      _stallController.add(stall);
    }
  }

  void dispose() {
    stopMonitoring();
    _stallController.close();
  }
}
