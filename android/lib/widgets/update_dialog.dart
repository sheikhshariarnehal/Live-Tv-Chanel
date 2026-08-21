import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../core/typography.dart';
import '../providers/update_notifier.dart';

class UpdateDialog extends ConsumerWidget {
  const UpdateDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Must not dismiss by clicking outside
      builder: (context) => const UpdateDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(updateProvider);
    final notifier = ref.read(updateProvider.notifier);
    final isForce = updateState.isForceUpdate;

    // Use PopScope to prevent back button dismissals on force update
    return PopScope(
      canPop: !isForce,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        // GPU-safe: no BackdropFilter (crashes budget TV GPUs like Mali-G31)
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xF217181C), // Solid dark background (95% opacity)
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isForce
                              ? [
                                  const Color(0xFFFF5A5F),
                                  GoPlayTheme.error,
                                ]
                              : [
                                  const Color(0xFF33C2C8),
                                  GoPlayTheme.primary,
                                ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.system_update_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isForce ? 'CRITICAL UPDATE' : 'UPDATE AVAILABLE',
                            style: TextStyle(
                              fontFamily: GoPlayType.family,
                              fontSize: GoPlayType.md,
                              fontWeight: FontWeight.w800,
                              color: isForce ? GoPlayTheme.error : GoPlayTheme.primary,
                              height: GoPlayType.leadingSnug,
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isForce ? 'You must update to continue' : 'A new version is ready',
                            style: GoPlayType.bodySmall.copyWith(
                              color: GoPlayTheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.06),
                ),

                // Dynamic Body based on download/check status
                _buildDialogBody(context, updateState),

                const SizedBox(height: 24),

                // Action Buttons
                _buildActionButtons(context, updateState, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogBody(BuildContext context, UpdateState state) {
    switch (state.status) {
      case UpdateStatus.downloading:
        return Column(
          children: [
            Text(
              'Downloading update package...',
              style: GoPlayType.body.copyWith(
                fontWeight: FontWeight.w500,
                color: GoPlayTheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: state.downloadProgress,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: const AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(state.downloadProgress * 100).toStringAsFixed(0)}%',
                  style: GoPlayType.labelSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: GoPlayTheme.primary,
                  ),
                  maxLines: 1,
                ),
                Text(
                  'Please keep the app open',
                  style: GoPlayType.inter(
                    fontSize: GoPlayType.xs,
                    height: GoPlayType.leadingSnug,
                    color: GoPlayTheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        );

      case UpdateStatus.installing:
        return Column(
          children: [
            const SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(
                color: GoPlayTheme.primary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Launching package installer...',
              textAlign: TextAlign.center,
              style: GoPlayType.body.copyWith(
                fontWeight: FontWeight.w500,
                color: GoPlayTheme.onSurface,
              ),
            ),
          ],
        );

      case UpdateStatus.downloadFailed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: GoPlayTheme.error, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Download Failed',
                  style: TextStyle(
                    color: GoPlayTheme.error,
                    fontWeight: FontWeight.w700,
                    fontSize: GoPlayType.base,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: GoPlayTheme.error.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GoPlayTheme.error.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Text(
                state.errorMessage ?? 'An unexpected network error occurred while downloading the APK file. Please check your connection.',
                style: GoPlayType.bodySmall.copyWith(
                  color: GoPlayTheme.onSurface,
                ),
                // errorMessage comes off the wire and can be arbitrarily long.
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );

      default:
        // Shows details (release notes & version metadata)
        final info = state.updateInfo;
        if (info == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Versions and dates info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoTile('CURRENT', state.currentVersion),
                _buildInfoTile('LATEST', info.latestVersion, isHighlight: true),
                _buildInfoTile(
                  'PUBLISHED',
                  DateFormat('MMM dd, yyyy').format(info.publishedAt),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Release Notes Header
            Text(
              'WHAT\'S NEW',
              style: GoPlayType.meta.copyWith(
                color: GoPlayTheme.onSurfaceVariant,
                letterSpacing: GoPlayType.trackingWide,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 8),

            // Release Notes list
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 130),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: info.releaseNotes.map((note) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                fontFamily: GoPlayType.family,
                                color: GoPlayTheme.primary,
                                fontSize: GoPlayType.base,
                                fontWeight: FontWeight.w700,
                                height: GoPlayType.leadingBody,
                              ),
                            ),
                            Expanded(
                              // Release notes are server-supplied and of
                              // unbounded length; cap them so a long note
                              // cannot blow out the 130px scroll region.
                              child: Text(
                                note,
                                style: GoPlayType.body.copyWith(
                                  color: GoPlayTheme.onSurface,
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildInfoTile(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoPlayType.meta.copyWith(
            color: GoPlayTheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoPlayType.inter(
            fontSize: GoPlayType.base,
            fontWeight: FontWeight.w800,
            height: GoPlayType.leadingSnug,
            color: isHighlight ? GoPlayTheme.primary : GoPlayTheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, UpdateState state, UpdateNotifier notifier) {
    final isForce = state.isForceUpdate;

    if (state.status == UpdateStatus.downloading) {
      return TextButton.icon(
        onPressed: () {
          notifier.cancelDownload();
        },
        icon: const Icon(Icons.cancel_rounded, color: GoPlayTheme.error, size: 18),
        label: const Text('CANCEL DOWNLOAD'),
        style: TextButton.styleFrom(
          foregroundColor: GoPlayTheme.error,
          backgroundColor: GoPlayTheme.error.withValues(alpha: 0.08),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: GoPlayType.family,
            fontSize: GoPlayType.sm,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    if (state.status == UpdateStatus.installing) {
      return const SizedBox.shrink(); // Prevent actions during installation request
    }

    if (state.status == UpdateStatus.downloadFailed) {
      return Row(
        children: [
          if (!isForce)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  notifier.resetStatus();
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                  backgroundColor: Colors.white.withValues(alpha: 0.02),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('LATER', style: GoPlayType.label.copyWith(color: GoPlayTheme.onSurfaceVariant)),
              ),
            ),
          if (!isForce) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                notifier.retryDownload();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GoPlayTheme.primary,
                foregroundColor: const Color(0xFF071F21),
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(
                  fontFamily: GoPlayType.family,
                  fontSize: GoPlayType.base,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              child: const Text('RETRY DOWNLOAD'),
            ),
          ),
        ],
      );
    }

    if (state.status == UpdateStatus.downloadSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.errorMessage != null) ...[
            Text(
              state.errorMessage!,
              style: GoPlayType.bodySmall.copyWith(color: GoPlayTheme.error),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              if (!isForce)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      notifier.resetStatus();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                      backgroundColor: Colors.white.withValues(alpha: 0.02),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('LATER', style: GoPlayType.label.copyWith(color: GoPlayTheme.onSurfaceVariant)),
                  ),
                ),
              if (!isForce) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    notifier.installApk();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GoPlayTheme.primary,
                    foregroundColor: const Color(0xFF071F21),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: GoPlayType.base,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  child: const Text('INSTALL NOW'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Default Update Available buttons
    return Row(
      children: [
        if (!isForce)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                backgroundColor: Colors.white.withValues(alpha: 0.02),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'LATER',
                style: GoPlayType.label.copyWith(
                  color: GoPlayTheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        if (!isForce) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            autofocus: true, // TV remote: auto-focus primary action
            onPressed: () {
              notifier.startDownload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GoPlayTheme.primary,
              foregroundColor: const Color(0xFF071F21),
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(
                fontFamily: GoPlayType.family,
                fontSize: GoPlayType.base,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            child: const Text('UPDATE NOW'),
          ),
        ),
      ],
    );
  }
}
