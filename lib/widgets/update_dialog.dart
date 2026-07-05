import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
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
        backgroundColor: GoPlayTheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: GoPlayTheme.cardBorder, width: 1),
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: GoPlayTheme.primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.system_update_rounded,
                      color: GoPlayTheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isForce ? 'CRITICAL UPDATE' : 'UPDATE AVAILABLE',
                          style: GoogleFonts.orbitron(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isForce ? GoPlayTheme.error : GoPlayTheme.primary,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isForce ? 'You must update to continue' : 'A new version is ready',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: GoPlayTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: GoPlayTheme.cardBorder, height: 32),

              // Dynamic Body based on download/check status
              _buildDialogBody(context, updateState),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(context, updateState, notifier),
            ],
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
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.downloadProgress,
                backgroundColor: GoPlayTheme.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(state.downloadProgress * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: GoPlayTheme.primary,
                  ),
                ),
                Text(
                  'Please keep the app open',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: GoPlayTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        );

      case UpdateStatus.installing:
        return const Column(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: GoPlayTheme.primary,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Launching package installer...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
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
                Text(
                  'Download Failed',
                  style: GoogleFonts.inter(
                    color: GoPlayTheme.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x12FF453A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: GoPlayTheme.error.withAlpha(50), width: 0.5),
              ),
              child: Text(
                state.errorMessage ?? 'An unexpected network error occurred while downloading the APK file. Please check your connection.',
                style: GoogleFonts.inter(
                  color: GoPlayTheme.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.4,
                ),
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
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: GoPlayTheme.onSurfaceVariant,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),

            // Release Notes list
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
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
                                color: GoPlayTheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                note,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.4,
                                ),
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
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: GoPlayTheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: isHighlight ? GoPlayTheme.primary : Colors.white,
          ),
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  side: const BorderSide(color: GoPlayTheme.cardBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('LATER', style: TextStyle(color: GoPlayTheme.onSurfaceVariant)),
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
                foregroundColor: const Color(0xFF003300),
                padding: const EdgeInsets.symmetric(vertical: 14),
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
              style: GoogleFonts.inter(color: GoPlayTheme.error, fontSize: 11),
              textAlign: TextAlign.center,
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
                      side: const BorderSide(color: GoPlayTheme.cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('LATER', style: TextStyle(color: GoPlayTheme.onSurfaceVariant)),
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
                    foregroundColor: const Color(0xFF003300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                side: const BorderSide(color: GoPlayTheme.cardBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'LATER',
                style: TextStyle(
                  color: GoPlayTheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (!isForce) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              notifier.startDownload();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GoPlayTheme.primary,
              foregroundColor: const Color(0xFF003300),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('UPDATE NOW'),
          ),
        ),
      ],
    );
  }
}
