import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/router.dart';
import '../providers/update_notifier.dart';
import '../providers/app_providers.dart';
import 'update_dialog.dart';

/// A wrapper widget that listens for update events and monitors the app lifecycle (resumes).
/// This should wrap the child of [MaterialApp.router].
class UpdateHandler extends ConsumerStatefulWidget {
  final Widget child;

  const UpdateHandler({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<UpdateHandler> createState() => _UpdateHandlerState();
}

class _UpdateHandlerState extends ConsumerState<UpdateHandler> with WidgetsBindingObserver {
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Trigger initial check for updates on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updateProvider.notifier).checkForUpdates(isManual: false);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Trigger a silent update check when the app returns to the foreground
      ref.read(updateProvider.notifier).checkForUpdates(isManual: false);
      // Trigger a silent sync with Supabase to get the latest matches/channels
      ref.read(syncServiceProvider).sync();
    }
  }

  void _triggerUpdateDialog() async {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    try {
      // If the app is currently on the splash screen ('/'), wait until it navigates away
      // to avoid showing/dismissing the dialog during the initial route transition.
      if (appRouter.routerDelegate.currentConfiguration.uri.path == '/') {
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 200));
          return appRouter.routerDelegate.currentConfiguration.uri.path == '/';
        });
      }

      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        await UpdateDialog.show(context);
      }
    } catch (_) {
      // Dialog failed to open or closed unexpectedly
    } finally {
      _isDialogShowing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in the update state
    ref.listen<UpdateState>(updateProvider, (previous, next) {
      if (next.status == UpdateStatus.updateAvailable &&
          previous?.status != UpdateStatus.updateAvailable) {
        _triggerUpdateDialog();
      }
    });

    return widget.child;
  }
}
