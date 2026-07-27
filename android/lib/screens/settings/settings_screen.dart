import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../providers/update_notifier.dart';
import '../../widgets/tv_focus_wrapper.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Playback Preferences
  bool _isHwAccelEnabled = true;
  bool _isAutoPlayEnabled = true;
  bool _isBackgroundAudioEnabled = false;
  String _selectedBufferMode = 'Balanced';
  String _selectedAspectRatio = 'Fit Screen (16:9)';

  // Sync Preferences
  String _selectedSyncRate = 'Every 6 Hours';
  bool _isSyncing = false;
  bool _isClearingCache = false;

  final List<String> _bufferModes = ['Fast Load', 'Balanced', 'High Stability'];
  final List<String> _aspectRatios = ['Fit Screen (16:9)', 'Stretch', 'Original'];
  final List<String> _syncRates = ['Every 1 Hour', 'Every 6 Hours', 'Manual Only'];

  Future<void> _handleForceSync() async {
    setState(() => _isSyncing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(syncServiceProvider).sync();
      ref.invalidate(channelsProvider);
      ref.invalidate(eventsProvider);
      ref.invalidate(categoriesProvider);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: GoPlayTheme.primary),
                SizedBox(width: 10),
                Text(
                  'Channels and events synchronized successfully!',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            backgroundColor: GoPlayTheme.darkSurfaceContainerHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: GoPlayTheme.error),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Sync failed: $e',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: GoPlayTheme.darkSurfaceContainerHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _handleClearCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GoPlayTheme.darkSurfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Application Cache?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will clear stored channel icons and offline schedule data. Fresh data will be redownloaded automatically.',
          style: TextStyle(color: GoPlayTheme.darkOnSurfaceVariant, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL', style: TextStyle(color: GoPlayTheme.darkOnSurfaceMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: GoPlayTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('CLEAR CACHE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isClearingCache = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(cacheServiceProvider).clearAllCache();
      ref.invalidate(channelsProvider);
      ref.invalidate(eventsProvider);
      ref.invalidate(categoriesProvider);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cleaning_services_rounded, color: GoPlayTheme.primary),
                SizedBox(width: 10),
                Text(
                  'Application cache cleared!',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            backgroundColor: GoPlayTheme.darkSurfaceContainerHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isClearingCache = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProvider);
    final notifier = ref.read(updateProvider.notifier);

    return Scaffold(
      backgroundColor: GoPlayTheme.darkSurface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Pinned Header
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: GoPlayTheme.darkSurface,
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              centerTitle: false,
            ),

            // Settings Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 12),

                  // ================== SECTION: STREAM & PLAYBACK ==================
                  _buildSectionHeader('STREAM & PLAYBACK'),
                  const SizedBox(height: 12),

                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader(
                          icon: Icons.play_circle_fill_rounded,
                          title: 'Video Engine Preferences',
                          subtitle: 'Configure IPTV player, decoding, and aspect ratio',
                          iconGlowColor: GoPlayTheme.primary,
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 32),

                        // Hardware Acceleration Toggle
                        _buildToggleTile(
                          title: 'Hardware Acceleration (GPU)',
                          subtitle: 'Enable GPU decoding for smooth 60fps video playback',
                          value: _isHwAccelEnabled,
                          onChanged: (val) => setState(() => _isHwAccelEnabled = val),
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 28),

                        // Auto-Play Stream
                        _buildToggleTile(
                          title: 'Auto-Play Channel Stream',
                          subtitle: 'Immediately start video stream when a channel is selected',
                          value: _isAutoPlayEnabled,
                          onChanged: (val) => setState(() => _isAutoPlayEnabled = val),
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 28),

                        // Background Audio
                        _buildToggleTile(
                          title: 'Background Audio Playback',
                          subtitle: 'Keep playing audio when switching apps or locking screen',
                          value: _isBackgroundAudioEnabled,
                          onChanged: (val) => setState(() => _isBackgroundAudioEnabled = val),
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 28),

                        // Buffer Mode Selector
                        _buildDropdownTile(
                          title: 'Stream Buffer Strategy',
                          subtitle: 'Control stream buffer depth for network stability',
                          currentValue: _selectedBufferMode,
                          options: _bufferModes,
                          onSelected: (val) => setState(() => _selectedBufferMode = val),
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 28),

                        // Aspect Ratio Selector
                        _buildDropdownTile(
                          title: 'Default Aspect Ratio',
                          subtitle: 'Preferred video display ratio for live broadcasts',
                          currentValue: _selectedAspectRatio,
                          options: _aspectRatios,
                          onSelected: (val) => setState(() => _selectedAspectRatio = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ================== SECTION: DATA & SYNCHRONIZATION ==================
                  _buildSectionHeader('DATA & SYNCHRONIZATION'),
                  const SizedBox(height: 12),

                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader(
                          icon: Icons.sync_rounded,
                          title: 'Database & Sync Controls',
                          subtitle: 'Manage local IPTV database and sync schedule',
                          iconGlowColor: GoPlayTheme.primary,
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 32),

                        // Auto Sync Rate
                        _buildDropdownTile(
                          title: 'Background Sync Frequency',
                          subtitle: 'How often to check Supabase for new channels and events',
                          currentValue: _selectedSyncRate,
                          options: _syncRates,
                          onSelected: (val) => setState(() => _selectedSyncRate = val),
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 28),

                        // Action Buttons Row
                        Row(
                          children: [
                            // Force Sync Button
                            Expanded(
                              child: _buildActionButton(
                                label: _isSyncing ? 'SYNCING...' : 'FORCE SYNC NOW',
                                icon: Icons.sync_rounded,
                                isLoading: _isSyncing,
                                color: GoPlayTheme.primary,
                                onPressed: _isSyncing ? null : _handleForceSync,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Clear Cache Button
                            Expanded(
                              child: _buildActionButton(
                                label: _isClearingCache ? 'CLEARING...' : 'CLEAR CACHE',
                                icon: Icons.cleaning_services_rounded,
                                isLoading: _isClearingCache,
                                color: GoPlayTheme.error,
                                onPressed: _isClearingCache ? null : _handleClearCache,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ================== SECTION: SYSTEM & OTA UPDATES ==================
                  _buildSectionHeader('SYSTEM & OTA UPDATES'),
                  const SizedBox(height: 12),

                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader(
                          icon: Icons.system_update_rounded,
                          title: 'App Maintenance',
                          subtitle: 'Manage self-hosted OTA application updates',
                          iconGlowColor: GoPlayTheme.primary,
                        ),
                        const Divider(color: GoPlayTheme.darkCardBorder, height: 32),

                        // Version Info
                        _buildVersionRow('Current App Version', updateState.currentVersion),
                        const SizedBox(height: 12),
                        _buildVersionRow(
                          'Latest Available Version',
                          updateState.updateInfo?.latestVersion ?? 'Checking...',
                          isHighlight: updateState.updateInfo != null,
                        ),
                        const SizedBox(height: 12),
                        _buildVersionRow(
                          'Last Update Check',
                          updateState.lastCheckTime != null
                              ? DateFormat('MMM dd, yyyy • hh:mm a').format(updateState.lastCheckTime!)
                              : 'Never',
                        ),

                        const SizedBox(height: 20),

                        // Error Alerts
                        if (updateState.status == UpdateStatus.error && updateState.errorMessage != null)
                          _buildErrorDisplay(updateState.errorMessage!)
                        else if (updateState.status == UpdateStatus.downloadFailed && updateState.errorMessage != null)
                          _buildErrorDisplay(updateState.errorMessage!),

                        // Download Progress Indicator
                        if (updateState.status == UpdateStatus.downloading) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: updateState.downloadProgress,
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
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
                                  minimumSize: Size.zero,
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

                        // Installing Status
                        if (updateState.status == UpdateStatus.installing) ...[
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: GoPlayTheme.primary,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Launching Android installer...',
                                style: TextStyle(color: GoPlayTheme.darkOnSurfaceVariant, fontSize: 13),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 16),
                        _buildCardActionButton(context, updateState, notifier),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ================== ABOUT FOOTER ==================
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'GOPLAY TV STREAMING',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: GoPlayTheme.darkOnSurfaceVariant.withValues(alpha: 0.6),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'High-Performance IPTV Player • Build v${updateState.currentVersion}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: GoPlayTheme.darkOnSurfaceVariant.withValues(alpha: 0.4),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: GoPlayTheme.darkOnSurfaceVariant,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GoPlayTheme.darkSurfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: GoPlayTheme.darkCardBorder,
          width: 1.0,
        ),
      ),
      child: child,
    );
  }

  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconGlowColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconGlowColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: iconGlowColor.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Icon(
            icon,
            color: iconGlowColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: GoPlayTheme.darkOnSurfaceVariant,
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
            color: GoPlayTheme.darkOnSurfaceVariant,
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
          color: GoPlayTheme.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GoPlayTheme.error.withValues(alpha: 0.2), width: 1.0),
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
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: GoPlayTheme.darkOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        TvFocusable(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 46,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: value ? GoPlayTheme.primary : Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: value ? Colors.transparent : Colors.white.withValues(alpha: 0.15),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(3),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
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

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: GoPlayTheme.darkOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            final isSelected = option == currentValue;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TvFocusable(
                onTap: () => onSelected(option),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? GoPlayTheme.primary : GoPlayTheme.darkSurfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? GoPlayTheme.primary : GoPlayTheme.darkCardBorder,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.6), width: 1.0),
          foregroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(color: color, strokeWidth: 2),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardActionButton(BuildContext context, UpdateState state, UpdateNotifier notifier) {
    final isChecking = state.status == UpdateStatus.checking;
    final isDownloading = state.status == UpdateStatus.downloading;

    if (isChecking) {
      return SizedBox(
        width: double.infinity,
        height: 46,
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: GoPlayTheme.darkCardBorder),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(color: GoPlayTheme.primary, strokeWidth: 2),
              ),
              SizedBox(width: 10),
              Text(
                'CHECKING FOR UPDATES...',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: GoPlayTheme.darkOnSurfaceVariant,
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
        gradientColors: [const Color(0xFF10B981), const Color(0xFF059669)],
      );
    }

    if (state.status == UpdateStatus.downloadFailed) {
      return _buildGradientButton(
        onPressed: () => notifier.retryDownload(),
        icon: Icons.refresh_rounded,
        label: 'RETRY DOWNLOAD',
        gradientColors: [GoPlayTheme.error, const Color(0xFFDC2626)],
      );
    }

    if (state.status == UpdateStatus.updateAvailable) {
      return _buildGradientButton(
        onPressed: () => notifier.startDownload(),
        icon: Icons.download_rounded,
        label: 'DOWNLOAD & UPDATE',
        gradientColors: [GoPlayTheme.primary, GoPlayTheme.primaryDark],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          await notifier.checkForUpdates(isManual: true);
          if (ref.read(updateProvider).status == UpdateStatus.alreadyUpToDate) {
            messenger.showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: GoPlayTheme.primary),
                    SizedBox(width: 10),
                    Text(
                      'App is already up to date!',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: GoPlayTheme.darkSurfaceContainerHigh,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
