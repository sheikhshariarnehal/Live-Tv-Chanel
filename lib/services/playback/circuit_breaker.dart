import 'package:flutter/foundation.dart';

/// Tracks per-channel and global failure patterns to prevent skip storms.
///
/// Each channel has an independent circuit that opens after consecutive
/// failures, preventing the player from repeatedly trying a known-dead
/// channel. A global circuit detects ISP/provider-level outages when
/// most channels fail simultaneously.

/// The three states of a circuit breaker.
enum CircuitState {
  /// Normal — channel is eligible for playback.
  closed,

  /// Channel has too many consecutive failures — skip it entirely.
  open,

  /// Cooldown expired — allow one test attempt to see if it recovered.
  halfOpen,
}

/// Per-channel circuit state.
class ChannelCircuit {
  final String channelId;
  CircuitState state;
  int consecutiveFailures;
  int consecutiveSuccesses;
  DateTime? lastFailure;
  DateTime? lastSuccess;
  DateTime? openUntil;

  ChannelCircuit({
    required this.channelId,
    this.state = CircuitState.closed,
    this.consecutiveFailures = 0,
    this.consecutiveSuccesses = 0,
    this.lastFailure,
    this.lastSuccess,
    this.openUntil,
  });
}

class CircuitBreaker {
  CircuitBreaker({
    this.failureThreshold = 5,
    this.cooldownDuration = const Duration(minutes: 10),
    this.globalFailureRate = 0.8,
    this.globalWindowDuration = const Duration(minutes: 2),
  });

  /// Number of consecutive failures before opening a channel circuit.
  final int failureThreshold;

  /// How long an open circuit stays open before allowing a half-open test.
  final Duration cooldownDuration;

  /// Fraction of tested channels that must fail to trigger global outage.
  final double globalFailureRate;

  /// Rolling window for global outage detection.
  final Duration globalWindowDuration;

  final Map<String, ChannelCircuit> _channels = {};

  // Global circuit tracking
  final List<_GlobalEvent> _recentEvents = [];

  // ─── Per-Channel Circuit ──────────────────────────────────────

  /// Record a failure for a channel. May open the circuit.
  void recordFailure(String channelId) {
    final circuit = _getOrCreate(channelId);
    circuit.consecutiveFailures++;
    circuit.consecutiveSuccesses = 0;
    circuit.lastFailure = DateTime.now();

    if (circuit.consecutiveFailures >= failureThreshold &&
        circuit.state == CircuitState.closed) {
      circuit.state = CircuitState.open;
      circuit.openUntil = DateTime.now().add(cooldownDuration);
      debugPrint('CircuitBreaker: OPENED circuit for $channelId '
          '(${circuit.consecutiveFailures} failures)');
    }

    // Track for global outage detection
    _recentEvents.add(_GlobalEvent(
      channelId: channelId,
      isFailure: true,
      timestamp: DateTime.now(),
    ));
    _pruneOldEvents();
  }

  /// Record a success for a channel. Closes the circuit.
  void recordSuccess(String channelId) {
    final circuit = _getOrCreate(channelId);
    circuit.consecutiveSuccesses++;
    circuit.consecutiveFailures = 0;
    circuit.lastSuccess = DateTime.now();

    if (circuit.state != CircuitState.closed) {
      circuit.state = CircuitState.closed;
      circuit.openUntil = null;
      debugPrint('CircuitBreaker: CLOSED circuit for $channelId (recovered)');
    }

    // Track for global outage detection
    _recentEvents.add(_GlobalEvent(
      channelId: channelId,
      isFailure: false,
      timestamp: DateTime.now(),
    ));
    _pruneOldEvents();
  }

  /// Check if a channel's circuit is open (should be skipped).
  bool isOpen(String channelId) {
    final circuit = _channels[channelId];
    if (circuit == null) return false;
    if (circuit.state != CircuitState.open) return false;

    // Check if cooldown has expired → transition to half-open
    if (circuit.openUntil != null &&
        DateTime.now().isAfter(circuit.openUntil!)) {
      circuit.state = CircuitState.halfOpen;
      debugPrint('CircuitBreaker: $channelId → HALF-OPEN (cooldown expired)');
      return false; // Allow one test
    }

    return true;
  }

  /// Check if a channel is in half-open state (one test allowed).
  bool isHalfOpen(String channelId) {
    final circuit = _channels[channelId];
    return circuit?.state == CircuitState.halfOpen;
  }

  /// Get the current circuit state for a channel.
  CircuitState getState(String channelId) {
    final circuit = _channels[channelId];
    if (circuit == null) return CircuitState.closed;

    // Auto-transition from open to half-open if cooldown expired
    if (circuit.state == CircuitState.open &&
        circuit.openUntil != null &&
        DateTime.now().isAfter(circuit.openUntil!)) {
      circuit.state = CircuitState.halfOpen;
    }

    return circuit.state;
  }

  /// Get the number of consecutive failures for a channel.
  int getFailureCount(String channelId) {
    return _channels[channelId]?.consecutiveFailures ?? 0;
  }

  // ─── Global Circuit Breaker ───────────────────────────────────

  /// Whether a global outage is detected (most channels failing simultaneously).
  bool get isGlobalOutage {
    _pruneOldEvents();
    if (_recentEvents.isEmpty) return false;

    // Count unique channels tested and their failure state
    final channelResults = <String, bool>{};
    for (final event in _recentEvents) {
      channelResults[event.channelId] = event.isFailure;
    }

    if (channelResults.length < 8) return false; // Need at least 8 channels

    final totalChannels = channelResults.length;
    final failedChannels = channelResults.values.where((f) => f).length;
    final failureRate = failedChannels / totalChannels;

    final isOutage = failureRate >= globalFailureRate;
    if (isOutage) {
      debugPrint('CircuitBreaker: GLOBAL OUTAGE detected — '
          '$failedChannels/$totalChannels channels failed '
          '(${(failureRate * 100).toStringAsFixed(0)}%)');
    }

    return isOutage;
  }

  /// Reset all circuits. Useful on app restart or manual refresh.
  void resetAll() {
    _channels.clear();
    _recentEvents.clear();
    debugPrint('CircuitBreaker: all circuits reset');
  }

  /// Reset a specific channel's circuit.
  void resetChannel(String channelId) {
    _channels.remove(channelId);
  }

  // ─── Private ──────────────────────────────────────────────────

  ChannelCircuit _getOrCreate(String channelId) {
    return _channels.putIfAbsent(
      channelId,
      () => ChannelCircuit(channelId: channelId),
    );
  }

  void _pruneOldEvents() {
    final cutoff = DateTime.now().subtract(globalWindowDuration);
    _recentEvents.removeWhere((e) => e.timestamp.isBefore(cutoff));
  }
}

class _GlobalEvent {
  final String channelId;
  final bool isFailure;
  final DateTime timestamp;

  const _GlobalEvent({
    required this.channelId,
    required this.isFailure,
    required this.timestamp,
  });
}
