import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../providers/update_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(updateProvider);
    final notifier = ref.read(updateProvider.notifier);

    return Scaffold(
      backgroundColor: GoPlayTheme.surface,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: GoPlayTheme.primary,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
              child: Text(
                'SYSTEM & MAINTENANCE',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: GoPlayTheme.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            // App Updates Card
            Card(
              color: GoPlayTheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: GoPlayTheme.cardBorder, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: GoPlayTheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.system_update_rounded,
                            color: GoPlayTheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'App Updates',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Manage self-hosted OTA updates',
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

                    // Version information
                    _buildVersionRow('Current Version', updateState.currentVersion),
                    const SizedBox(height: 12),
                    _buildVersionRow(
                      'Latest Version Available',
                      updateState.updateInfo?.latestVersion ?? 'Checking...',
                      isHighlight: updateState.updateInfo != null,
                    ),
                    const SizedBox(height: 12),
                    _buildVersionRow(
                      'Last Checked',
                      updateState.lastCheckTime != null
                          ? DateFormat('MMM dd, yyyy • hh:mm a').format(updateState.lastCheckTime!)
                          : 'Never',
                    ),
                    
                    const SizedBox(height: 20),

                    // Error display inside the card
                    if (updateState.status == UpdateStatus.error && updateState.errorMessage != null)
                      _buildErrorDisplay(updateState.errorMessage!)
                    else if (updateState.status == UpdateStatus.downloadFailed && updateState.errorMessage != null)
                      _buildErrorDisplay(updateState.errorMessage!),

                    // Progress indicator if downloading
                    if (updateState.status == UpdateStatus.downloading) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: updateState.downloadProgress,
                          backgroundColor: GoPlayTheme.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Downloading: ${(updateState.downloadProgress * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: GoPlayTheme.primary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => notifier.cancelDownload(),
                            style: TextButton.styleFrom(
                              foregroundColor: GoPlayTheme.error,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('CANCEL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],

                    if (updateState.status == UpdateStatus.installing) ...[
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: GoPlayTheme.primary, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Launching installer...',
                            style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Primary Action Button
                    _buildCardActionButton(context, ref, updateState, notifier),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: GoPlayTheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isHighlight ? GoPlayTheme.primary : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorDisplay(String error) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0x12FF453A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: GoPlayTheme.error.withAlpha(50), width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline_rounded, color: GoPlayTheme.error, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: GoogleFonts.inter(
                  color: GoPlayTheme.error.withAlpha(220),
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardActionButton(BuildContext context, WidgetRef ref, UpdateState state, UpdateNotifier notifier) {
    final isChecking = state.status == UpdateStatus.checking;
    final isDownloading = state.status == UpdateStatus.downloading;

    if (isChecking) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: GoPlayTheme.cardBorder),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: GoPlayTheme.primary, strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('CHECKING FOR UPDATES...', style: TextStyle(color: GoPlayTheme.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    if (isDownloading) {
      return const SizedBox.shrink(); // Hide main action button, show details & cancel above
    }

    if (state.status == UpdateStatus.downloadSuccess) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () => notifier.installApk(),
          icon: const Icon(Icons.install_mobile_rounded, color: Color(0xFF003300)),
          label: const Text('INSTALL UPDATE'),
          style: ElevatedButton.styleFrom(
            backgroundColor: GoPlayTheme.primary,
            foregroundColor: const Color(0xFF003300),
          ),
        ),
      );
    }

    if (state.status == UpdateStatus.downloadFailed) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () => notifier.retryDownload(),
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF003300)),
          label: const Text('RETRY DOWNLOAD'),
          style: ElevatedButton.styleFrom(
            backgroundColor: GoPlayTheme.primary,
            foregroundColor: const Color(0xFF003300),
          ),
        ),
      );
    }

    if (state.status == UpdateStatus.updateAvailable) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () => notifier.startDownload(),
          icon: const Icon(Icons.download_rounded, color: Color(0xFF003300)),
          label: const Text('DOWNLOAD & UPDATE'),
          style: ElevatedButton.styleFrom(
            backgroundColor: GoPlayTheme.primary,
            foregroundColor: const Color(0xFF003300),
          ),
        ),
      );
    }

    // Default: Check for updates
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          await notifier.checkForUpdates(isManual: true);
          // If update is found, the global listener will open the dialog.
          // If no update is found, we show a brief snackbar.
          if (ref.read(updateProvider).status == UpdateStatus.alreadyUpToDate) {
            messenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: GoPlayTheme.primary),
                    const SizedBox(width: 10),
                    Text(
                      'App is already up to date!',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: GoPlayTheme.surfaceContainerHigh,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        icon: const Icon(Icons.refresh_rounded, color: GoPlayTheme.primary),
        label: const Text('CHECK FOR UPDATES'),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: GoPlayTheme.primary, width: 1),
          foregroundColor: GoPlayTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
