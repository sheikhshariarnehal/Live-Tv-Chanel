import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/update_info.dart';

class UpdateService {
  final Dio _dio;

  UpdateService(this._dio);

  /// Fetches the update configuration from the remote JSON file.
  Future<UpdateInfo> fetchUpdateInfo(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            // Bypass potential proxy/CDN caching issues
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
            'Expires': '0',
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return UpdateInfo.fromJson(data);
        } else if (data is String) {
          return UpdateInfo.fromJson(jsonDecode(data) as Map<String, dynamic>);
        }
        throw Exception('Invalid update.json format');
      }
      throw Exception('Failed to fetch update info: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error checking for updates: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Failed to parse update info: $e');
    }
  }

  /// Gets the current application version using [package_info_plus].
  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Downloads the APK to the application temporary directory with progress tracking and cancellation support.
  Future<File> downloadApk({
    required String url,
    required String fileName,
    required ProgressCallback onProgress,
    required CancelToken cancelToken,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      
      // Auto-delete old downloaded APKs to conserve space
      await deleteOldApks();
      
      final savePath = '${tempDir.path}/$fileName';
      
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            HttpHeaders.acceptEncodingHeader: '*',
          },
        ),
      );
      
      final file = File(savePath);
      if (!await file.exists()) {
        throw Exception('Downloaded file not found at $savePath');
      }
      return file;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw Exception('Download cancelled');
      }
      throw Exception('Download failed: ${e.message ?? e.toString()}');
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  /// Deletes all previously downloaded APK files in the temporary directory to clean up space.
  Future<void> deleteOldApks() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final dir = Directory(tempDir.path);
      if (await dir.exists()) {
        final list = dir.listSync();
        for (final item in list) {
          if (item is File && item.path.endsWith('.apk')) {
            await item.delete();
          }
        }
      }
    } catch (_) {
      // Fail silently for cleanup errors
    }
  }

  /// Checks if the app has permission to install packages (Android 8+).
  Future<bool> isInstallPermissionGranted() async {
    if (Platform.isAndroid) {
      return await Permission.requestInstallPackages.isGranted;
    }
    return true;
  }

  /// Requests the package installation permission (opens System Settings).
  Future<bool> requestInstallPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.requestInstallPackages.request();
      return status.isGranted;
    }
    return true;
  }

  /// Launches the package installer for the downloaded APK.
  Future<bool> installApk(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('APK file not found for installation: $filePath');
      }
      
      final result = await OpenFilex.open(
        filePath,
        type: 'application/vnd.android.package-archive',
      );
      
      if (result.type != ResultType.done) {
        throw Exception('Failed to open APK installer: ${result.message}');
      }
      return true;
    } catch (e) {
      throw Exception('Error installing APK: $e');
    }
  }
}
