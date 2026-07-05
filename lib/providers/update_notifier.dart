import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../models/update_info.dart';
import '../services/update_service.dart';
import '../repositories/update_repository.dart';

/// Status states for the In-App Update flow.
enum UpdateStatus {
  idle,
  checking,
  updateAvailable,
  alreadyUpToDate,
  downloading,
  downloadSuccess,
  downloadFailed,
  installing,
  error,
}

/// State data model for [UpdateNotifier].
class UpdateState {
  final UpdateStatus status;
  final double downloadProgress; // 0.0 to 1.0
  final UpdateInfo? updateInfo;
  final String currentVersion;
  final bool isForceUpdate;
  final DateTime? lastCheckTime;
  final String? errorMessage;
  final String? apkPath;

  const UpdateState({
    this.status = UpdateStatus.idle,
    this.downloadProgress = 0.0,
    this.updateInfo,
    this.currentVersion = '',
    this.isForceUpdate = false,
    this.lastCheckTime,
    this.errorMessage,
    this.apkPath,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    double? downloadProgress,
    UpdateInfo? updateInfo,
    String? currentVersion,
    bool? isForceUpdate,
    DateTime? lastCheckTime,
    String? errorMessage,
    String? apkPath,
    bool clearError = false,
    bool clearApkPath = false,
  }) {
    return UpdateState(
      status: status ?? this.status,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      updateInfo: updateInfo ?? this.updateInfo,
      currentVersion: currentVersion ?? this.currentVersion,
      isForceUpdate: isForceUpdate ?? this.isForceUpdate,
      lastCheckTime: lastCheckTime ?? this.lastCheckTime,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      apkPath: clearApkPath ? null : (apkPath ?? this.apkPath),
    );
  }
}

// ─── Riverpod Providers ──────────────────────────────────────────

/// Provides a standard [Dio] client for updates.
final updateDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
});

/// Provides the [UpdateService].
final updateServiceProvider = Provider<UpdateService>((ref) {
  final dio = ref.watch(updateDioProvider);
  return UpdateService(dio);
});

/// Provides the [UpdateRepository].
final updateRepositoryProvider = Provider<UpdateRepository>((ref) {
  final service = ref.watch(updateServiceProvider);
  return UpdateRepository(service);
});

/// State Notifier provider for managing updates.
final updateProvider = NotifierProvider<UpdateNotifier, UpdateState>(
  UpdateNotifier.new,
);

class UpdateNotifier extends Notifier<UpdateState> {
  CancelToken? _cancelToken;

  @override
  UpdateState build() {
    // Read cached metadata synchronously on build
    final repo = ref.watch(updateRepositoryProvider);
    final lastCheck = repo.getLastCheckTimestamp();
    
    // Read packages asynchronously inside an initialization function
    _initCurrentVersion();

    return UpdateState(
      status: UpdateStatus.idle,
      currentVersion: AppConstants.appVersion,
      lastCheckTime: lastCheck,
    );
  }

  Future<void> _initCurrentVersion() async {
    try {
      final repo = ref.read(updateRepositoryProvider);
      final currentVersion = await repo.getCurrentVersion();
      state = state.copyWith(currentVersion: currentVersion);
    } catch (_) {}
  }

  /// Checks for updates.
  /// Set [isManual] to true if triggered by the user clicking a button.
  /// Non-manual checks handle network errors gracefully without interrupting the user.
  Future<void> checkForUpdates({bool isManual = false}) async {
    if (state.status == UpdateStatus.checking || state.status == UpdateStatus.downloading) {
      return;
    }

    state = state.copyWith(
      status: UpdateStatus.checking,
      clearError: true,
    );

    try {
      final repo = ref.read(updateRepositoryProvider);
      final result = await repo.checkForUpdates(forceCheck: isManual);
      final lastCheck = repo.getLastCheckTimestamp();

      if (result.error != null && isManual) {
        state = state.copyWith(
          status: UpdateStatus.error,
          errorMessage: result.error,
          lastCheckTime: lastCheck,
        );
        return;
      }

      if (result.isUpdateAvailable && result.updateInfo != null) {
        state = state.copyWith(
          status: UpdateStatus.updateAvailable,
          updateInfo: result.updateInfo,
          currentVersion: result.currentVersion,
          isForceUpdate: result.isForceUpdate,
          lastCheckTime: lastCheck,
        );
      } else {
        state = state.copyWith(
          status: UpdateStatus.alreadyUpToDate,
          currentVersion: result.currentVersion,
          lastCheckTime: lastCheck,
        );
        
        // Reset manual checks back to idle after a brief moment
        if (isManual) {
          await Future.delayed(const Duration(seconds: 2));
          if (state.status == UpdateStatus.alreadyUpToDate) {
            state = state.copyWith(status: UpdateStatus.idle);
          }
        }
      }
    } catch (e) {
      final repo = ref.read(updateRepositoryProvider);
      final lastCheck = repo.getLastCheckTimestamp();
      
      state = state.copyWith(
        status: isManual ? UpdateStatus.error : UpdateStatus.idle,
        errorMessage: e.toString(),
        lastCheckTime: lastCheck,
      );
    }
  }

  /// Starts downloading the APK.
  Future<void> startDownload() async {
    final info = state.updateInfo;
    if (info == null) return;

    state = state.copyWith(
      status: UpdateStatus.downloading,
      downloadProgress: 0.0,
      clearError: true,
    );

    _cancelToken = CancelToken();

    try {
      final service = ref.read(updateServiceProvider);
      final fileName = 'goplay-${info.latestVersion}.apk';

      final file = await service.downloadApk(
        url: info.apkUrl,
        fileName: fileName,
        onProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            state = state.copyWith(downloadProgress: progress);
          }
        },
        cancelToken: _cancelToken!,
      );

      state = state.copyWith(
        status: UpdateStatus.downloadSuccess,
        apkPath: file.path,
      );

      // Automatically launch installation on successful download
      await installApk();
    } catch (e) {
      if (_cancelToken?.isCancelled == true) {
        return;
      }
      state = state.copyWith(
        status: UpdateStatus.downloadFailed,
        errorMessage: e.toString(),
      );
    } finally {
      _cancelToken = null;
    }
  }

  /// Cancels the running download.
  void cancelDownload() {
    if (_cancelToken != null) {
      _cancelToken!.cancel();
      _cancelToken = null;
    }
    state = state.copyWith(
      status: UpdateStatus.idle,
      downloadProgress: 0.0,
      clearError: true,
    );
  }

  /// Retries a failed download.
  Future<void> retryDownload() async {
    await startDownload();
  }

  /// Manually launches the package installation if it didn't run or needs to be retried.
  Future<void> installApk() async {
    final path = state.apkPath;
    if (path == null) {
      state = state.copyWith(
        status: UpdateStatus.downloadFailed,
        errorMessage: 'No downloaded APK file found to install.',
      );
      return;
    }

    state = state.copyWith(status: UpdateStatus.installing);

    try {
      final service = ref.read(updateServiceProvider);

      // Check if permission to install unknown apps is granted (Android 8+)
      final hasPermission = await service.isInstallPermissionGranted();
      if (!hasPermission) {
        state = state.copyWith(
          status: UpdateStatus.downloadSuccess, // keep state as success so they can retry
          errorMessage: 'Install permission (unknown sources) is required. Opening settings...',
        );
        
        final granted = await service.requestInstallPermission();
        if (!granted) {
          state = state.copyWith(
            status: UpdateStatus.downloadSuccess,
            errorMessage: 'Please grant the "Install unknown apps" permission to install updates.',
          );
          return;
        }
      }

      final success = await service.installApk(path);
      if (success) {
        state = state.copyWith(status: UpdateStatus.idle);
      } else {
        state = state.copyWith(
          status: UpdateStatus.downloadSuccess,
          errorMessage: 'Package installation could not be completed.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.downloadSuccess,
        errorMessage: e.toString(),
      );
    }
  }

  /// Resets the update status back to idle or updateAvailable.
  void resetStatus() {
    if (state.updateInfo != null) {
      state = state.copyWith(status: UpdateStatus.updateAvailable);
    } else {
      state = state.copyWith(status: UpdateStatus.idle);
    }
  }
}
