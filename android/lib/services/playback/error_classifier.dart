import 'package:flutter/foundation.dart';
import 'connectivity_service.dart';
import 'playback_state.dart';

/// Classifies raw ExoPlayer errors into structured [ClassifiedError] objects.
///
/// Classification uses a priority chain:
/// 1. Connectivity state (offline → [ErrorType.noInternet])
/// 2. HTTP status code (403 → geo-block, 401/410 → auth expired, 5xx → server)
/// 3. ExoPlayer error code range (6000–6999 → DRM)
/// 4. Exception class / message heuristics
/// 5. Buffer state (buffer growing but playback stalled → slow network)
///
/// This ensures the [PlaybackStateMachine] always receives a typed error with
/// a recommended recovery strategy, instead of raw exception strings.
class ErrorClassifier {
  const ErrorClassifier();

  /// Classify a raw error payload from the native ExoPlayer layer.
  ///
  /// [rawError] contains the enriched error map from NativePlayerView.kt:
  /// - `code`: int — ExoPlayer error code
  /// - `message`: String — error message
  /// - `errorCodeName`: String — e.g. "ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT"
  /// - `httpStatus`: int? — extracted HTTP status from cause chain
  /// - `isDrmError`: bool — native-side DRM detection
  /// - `causeName`: String — exception class name
  /// - `causeMessage`: String — cause exception message
  ///
  /// [internetState] is the current connectivity state.
  /// [isBufferGrowing] indicates whether the buffer was progressing before error.
  ClassifiedError classify({
    required Map<String, dynamic> rawError,
    required InternetState internetState,
    required bool isBufferGrowing,
  }) {
    final code = rawError['code'] as int? ?? -1;
    final message = (rawError['message'] as String? ?? '').toLowerCase();
    final codeName = (rawError['errorCodeName'] as String? ?? '').toLowerCase();
    final httpStatus = rawError['httpStatus'] as int?;
    final isDrmError = rawError['isDrmError'] as bool? ?? false;
    final causeName = (rawError['causeName'] as String? ?? '').toLowerCase();
    final causeMessage = (rawError['causeMessage'] as String? ?? '').toLowerCase();
    final rawMsg = rawError['message'] as String? ?? 'Unknown playback error';

    // ── Priority 1: No Internet ───────────────────────────────────
    if (internetState == InternetState.noInternet ||
        internetState == InternetState.dnsFailure) {
      return ClassifiedError(
        type: ErrorType.noInternet,
        strategy: RecoveryStrategy.waitForInternet,
        rawMessage: rawMsg,
        httpStatus: httpStatus,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    if (internetState == InternetState.captivePortal) {
      return ClassifiedError(
        type: ErrorType.noInternet,
        strategy: RecoveryStrategy.waitForInternet,
        rawMessage: 'Captive portal detected — please sign in to your network',
        httpStatus: httpStatus,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    // ── Priority 2: HTTP Status Codes ─────────────────────────────
    if (httpStatus != null) {
      if (httpStatus == 403) {
        // Could be geo-block or auth issue
        if (message.contains('geo') ||
            message.contains('region') ||
            message.contains('country') ||
            message.contains('territory')) {
          return ClassifiedError(
            type: ErrorType.geoBlock,
            strategy: RecoveryStrategy.refreshAuth, // Retry 1 time after refresh
            rawMessage: rawMsg,
            httpStatus: httpStatus,
            exoErrorCode: code,
            exoErrorCodeName: codeName,
            isRecoverable: true,
          );
        }
        return ClassifiedError(
          type: ErrorType.authExpired,
          strategy: RecoveryStrategy.refreshAuth, // Retry 1 time after refresh
          rawMessage: rawMsg,
          httpStatus: httpStatus,
          exoErrorCode: code,
          exoErrorCodeName: codeName,
          isRecoverable: true,
        );
      }

      if (httpStatus == 401) {
        return ClassifiedError(
          type: ErrorType.authExpired,
          strategy: RecoveryStrategy.refreshAuth, // Retry 1 time after refresh
          rawMessage: rawMsg,
          httpStatus: httpStatus,
          exoErrorCode: code,
          exoErrorCodeName: codeName,
          isRecoverable: true,
        );
      }

      if (httpStatus == 410) {
        return ClassifiedError(
          type: ErrorType.authExpired,
          strategy: RecoveryStrategy.showError, // Gone permanently — no retry
          rawMessage: 'Stream is permanently unavailable (410)',
          httpStatus: httpStatus,
          exoErrorCode: code,
          exoErrorCodeName: codeName,
          isRecoverable: false,
        );
      }

      if (httpStatus == 404) {
        return ClassifiedError(
          type: ErrorType.deadStream,
          strategy: RecoveryStrategy.skip, // File doesn't exist — no retry, skip immediately
          rawMessage: 'Stream not found on server (404)',
          httpStatus: httpStatus,
          exoErrorCode: code,
          exoErrorCodeName: codeName,
          isRecoverable: false,
        );
      }

      if (httpStatus == 451) {
        // Unavailable For Legal Reasons — geo-block
        return ClassifiedError(
          type: ErrorType.geoBlock,
          strategy: RecoveryStrategy.refreshAuth, // Retry 1 time after refresh
          rawMessage: rawMsg,
          httpStatus: httpStatus,
          exoErrorCode: code,
          exoErrorCodeName: codeName,
          isRecoverable: true,
        );
      }

      if (httpStatus >= 500 && httpStatus < 600) {
        return ClassifiedError(
          type: ErrorType.serverError,
          strategy: RecoveryStrategy.retryWithBackoff, // 3 retries
          rawMessage: rawMsg,
          httpStatus: httpStatus,
          exoErrorCode: code,
          exoErrorCodeName: codeName,
          isRecoverable: true,
        );
      }
    }

    // ── Priority 3: DRM Errors (ExoPlayer code range 6000–6999) ──
    if (isDrmError || (code >= 6000 && code <= 6999)) {
      return ClassifiedError(
        type: ErrorType.drmFailure,
        strategy: RecoveryStrategy.refreshDrm,
        rawMessage: rawMsg,
        httpStatus: httpStatus,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    // ── Priority 4: Exception-based heuristics ────────────────────

    // Network timeouts
    if (codeName.contains('timeout') ||
        message.contains('timeout') ||
        causeMessage.contains('timeout') ||
        causeName.contains('timeout') ||
        codeName.contains('connection_failed')) {
      // If buffer was growing, it's just slow
      if (isBufferGrowing) {
        return ClassifiedError(
          type: ErrorType.slowNetwork,
          strategy: RecoveryStrategy.keepBuffering,
          rawMessage: rawMsg,
          exoErrorCode: code,
          exoErrorCodeName: codeName,
          isRecoverable: true,
        );
      }
      return ClassifiedError(
        type: ErrorType.cdnTimeout,
        strategy: RecoveryStrategy.retryWithBackoff,
        rawMessage: rawMsg,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    // DNS / Unknown host
    if (causeName.contains('unknownhost') ||
        causeMessage.contains('unable to resolve') ||
        causeMessage.contains('no address associated') ||
        message.contains('unknownhostexception')) {
      return ClassifiedError(
        type: ErrorType.noInternet,
        strategy: RecoveryStrategy.waitForInternet,
        rawMessage: rawMsg,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    // Connection refused / reset
    if (causeMessage.contains('connection refused') ||
        causeMessage.contains('connection reset') ||
        causeMessage.contains('broken pipe') ||
        causeName.contains('econnrefused') ||
        causeName.contains('econnreset')) {
      return ClassifiedError(
        type: ErrorType.cdnTimeout,
        strategy: RecoveryStrategy.retryWithBackoff,
        rawMessage: rawMsg,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    // Socket closed / EOF
    if (causeMessage.contains('socket closed') ||
        causeMessage.contains('unexpected end of stream') ||
        causeMessage.contains('eof') ||
        codeName.contains('io_read_position_out_of_range')) {
      return ClassifiedError(
        type: ErrorType.deadStream,
        strategy: RecoveryStrategy.retryWithBackoff,
        rawMessage: rawMsg,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    // HLS / DASH parsing errors — likely dead or malformed stream
    if (codeName.contains('parsing') ||
        codeName.contains('manifest') ||
        message.contains('playlist') ||
        message.contains('segment')) {
      return ClassifiedError(
        type: ErrorType.deadStream,
        strategy: RecoveryStrategy.retryWithBackoff,
        rawMessage: rawMsg,
        exoErrorCode: code,
        exoErrorCodeName: codeName,
        isRecoverable: true,
      );
    }

    // ── Priority 5: Fallback — Unknown ────────────────────────────
    debugPrint('ErrorClassifier: unclassified error — code=$code, '
        'codeName=$codeName, msg=$message, cause=$causeName: $causeMessage');

    return ClassifiedError(
      type: ErrorType.unknown,
      strategy: RecoveryStrategy.retryWithBackoff,
      rawMessage: rawMsg,
      httpStatus: httpStatus,
      exoErrorCode: code,
      exoErrorCodeName: codeName,
      isRecoverable: true,
    );
  }

  /// Get the appropriate retry configuration for an error type.
  RetryConfig getRetryConfig(ErrorType type) {
    switch (type) {
      case ErrorType.noInternet:
        // No retries — we wait for internet and auto-resume
        return const RetryConfig(maxAttempts: 0);
      case ErrorType.slowNetwork:
        // No retries — we keep buffering
        return const RetryConfig(maxAttempts: 0);
      case ErrorType.cdnTimeout:
        // Timeout / Connection reset — retry once
        return const RetryConfig(maxAttempts: 1, baseDelay: Duration(seconds: 2));
      case ErrorType.serverError:
        // 500 / 502 / 503 / 504 — retry twice, then skip
        return const RetryConfig(maxAttempts: 2, baseDelay: Duration(seconds: 2));
      case ErrorType.deadStream:
        // 404 / 410 — skip immediately (0 retries)
        return const RetryConfig(maxAttempts: 0);
      case ErrorType.authExpired:
        // 403 / 401 — Refresh token → retry once
        return const RetryConfig(maxAttempts: 1, baseDelay: Duration(seconds: 1));
      case ErrorType.drmFailure:
        // DRM failure — Refresh license → retry once
        return const RetryConfig(maxAttempts: 1, baseDelay: Duration(seconds: 1));
      case ErrorType.geoBlock:
        // 403 Geo Block — Refresh token → retry once
        return const RetryConfig(maxAttempts: 1, baseDelay: Duration(seconds: 1));
      case ErrorType.unknown:
        // Unknown — retry once
        return const RetryConfig(maxAttempts: 1, baseDelay: Duration(seconds: 2));
    }
  }
}

/// Configuration for retry attempts per error type.
class RetryConfig {
  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;
  final double backoffMultiplier;

  const RetryConfig({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(seconds: 2),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
  });
}
