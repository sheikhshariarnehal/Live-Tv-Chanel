import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../providers/update_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isHwAccelEnabled = true;

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProvider);
    final notifier = ref.read(updateProvider.notifier);

    return Scaffold(
      backgroundColor: GoPlayTheme.surface, // Strictly following the app theme background
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Standard Pinned Header with Back Button and 3-Dot Icon
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: GoPlayTheme.surface.withOpacity(0.95),
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'SETTINGS',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: GoPlayTheme.primary,
                  letterSpacing: 2,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
                  onPressed: () {
                    // Action menu placeholder
                  },
                ),
              ],
            ),

            // Settings Contents
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),

                  // ================== SECTION: SYSTEM & MAINTENANCE ==================
                  _buildSectionHeader('SYSTEM & MAINTENANCE'),
                  const SizedBox(height: 12),

                  // Update Card
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader(
                          icon: Icons.system_update_rounded,
                          title: 'App Updates',
                          subtitle: 'Manage self-hosted OTA updates',
                          iconGlowColor: GoPlayTheme.primary,
                        ),
                        const Divider(color: GoPlayTheme.cardBorder, height: 32),

                        // Version rows
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

                        // Error alerts
                        if (updateState.status == UpdateStatus.error && updateState.errorMessage != null)
                          _buildErrorDisplay(updateState.errorMessage!)
                        else if (updateState.status == UpdateStatus.downloadFailed && updateState.errorMessage != null)
                          _buildErrorDisplay(updateState.errorMessage!),

                        // Downloading state
                        if (updateState.status == UpdateStatus.downloading) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: updateState.downloadProgress,
                              backgroundColor: Colors.white.withOpacity(0.05),
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
                                style: const TextStyle(
                                  fontSize: 12,
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
                                child: const Text(
                                  'CANCEL',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: GoPlayTheme.error),
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Installing state
                        if (updateState.status == UpdateStatus.installing) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: GoPlayTheme.primary,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Launching installer...',
                                style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: 13),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 16),
                        _buildCardActionButton(context, updateState, notifier),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ================== SECTION: VIDEO & PERFORMANCE ==================
                  _buildSectionHeader('VIDEO & PERFORMANCE'),
                  const SizedBox(height: 12),

                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader(
                          icon: Icons.speed_rounded,
                          title: 'Hardware Acceleration',
                          subtitle: 'Enable GPU decoding for smoother video rendering',
                          iconGlowColor: GoPlayTheme.primary,
                        ),
                        const Divider(color: GoPlayTheme.cardBorder, height: 32),

                        // Hardware acceleration toggle
                        _buildToggleTile(
                          title: 'Video Acceleration',
                          subtitle: 'Render streams using hardware GPU',
                          value: _isHwAccelEnabled,
                          onChanged: (val) {
                            setState(() {
                              _isHwAccelEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ================== ABOUT APP ==================
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'GoPlay TV app',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: GoPlayTheme.onSurfaceVariant.withOpacity(0.5),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Designed with Premium Apple Aesthetic\nBuild v${updateState.currentVersion}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: GoPlayTheme.onSurfaceVariant.withOpacity(0.3),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header title using Orbitron and theme color
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: GoPlayTheme.onSurfaceVariant,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Reusable Frosted Glass Card styled with GoPlayTheme container styling (Removed glow/shadow)
  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: GoPlayTheme.surfaceContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: GoPlayTheme.cardBorder,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  // Header of settings cards containing title, subtitle, and icon (Removed glow/shadow)
  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconGlowColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconGlowColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: iconGlowColor.withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: Icon(
            icon,
            color: iconGlowColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: GoPlayTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVersionRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: GoPlayTheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
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
          color: GoPlayTheme.error.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GoPlayTheme.error.withOpacity(0.2), width: 1.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline_rounded, color: GoPlayTheme.error, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(
                  color: Color(0xFFFCA5A5),
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

  // Premium Apple-style Toggle switches
  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: GoPlayTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Animating custom iOS toggle
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 48,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: value
                  ? const LinearGradient(
                      colors: [GoPlayTheme.primary, GoPlayTheme.primaryDark],
                    )
                  : null,
              color: value ? null : Colors.white.withOpacity(0.08),
              border: Border.all(
                color: value ? Colors.transparent : Colors.white.withOpacity(0.12),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(3),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Premium flat CTA action button for App Updates Card (Removed glow/shadow)
  Widget _buildCardActionButton(BuildContext context, UpdateState state, UpdateNotifier notifier) {
    final isChecking = state.status == UpdateStatus.checking;
    final isDownloading = state.status == UpdateStatus.downloading;

    if (isChecking) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: GoPlayTheme.cardBorder),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: GoPlayTheme.primary, strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                'CHECKING FOR UPDATES...',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: GoPlayTheme.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isDownloading) {
      return const SizedBox.shrink();
    }

    if (state.status == UpdateStatus.downloadSuccess) {
      return _buildGradientButton(
        onPressed: () => notifier.installApk(),
        icon: Icons.install_mobile_rounded,
        label: 'INSTALL UPDATE NOW',
        gradientColors: [const Color(0xFF10B981), const Color(0xFF059669)], // Success Green Gradient
      );
    }

    if (state.status == UpdateStatus.downloadFailed) {
      return _buildGradientButton(
        onPressed: () => notifier.retryDownload(),
        icon: Icons.refresh_rounded,
        label: 'RETRY DOWNLOAD',
        gradientColors: [GoPlayTheme.error, const Color(0xFFDC2626)], // Red Gradient
      );
    }

    if (state.status == UpdateStatus.updateAvailable) {
      return _buildGradientButton(
        onPressed: () => notifier.startDownload(),
        icon: Icons.download_rounded,
        label: 'DOWNLOAD & UPDATE',
        gradientColors: [GoPlayTheme.primary, GoPlayTheme.primaryDark], // Theme Green Gradient
      );
    }

    // Default Check for updates button
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          await notifier.checkForUpdates(isManual: true);
          if (ref.read(updateProvider).status == UpdateStatus.alreadyUpToDate) {
            messenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: GoPlayTheme.primary),
                    const SizedBox(width: 10),
                    Text(
                      'App is already up to date!',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: GoPlayTheme.surfaceContainerHigh.withOpacity(0.95),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        icon: const Icon(Icons.refresh_rounded, color: GoPlayTheme.primary, size: 18),
        label: const Text(
          'CHECK FOR UPDATES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: GoPlayTheme.primary, width: 1.0),
          foregroundColor: GoPlayTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  // Reusable Gradient Button (Removed glow/shadow)
  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
