import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime startTime;
  final TextStyle style;
  final VoidCallback? onTimerFinished;

  const CountdownTimerWidget({
    super.key,
    required this.startTime,
    required this.style,
    this.onTimerFinished,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer? _timer;
  late Duration _timeRemaining;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _startTimerIfNeeded();
  }

  void _startTimerIfNeeded() {
    if (!_timeRemaining.isNegative && _timeRemaining > Duration.zero) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _calculateTimeRemaining();
          });
        }
      });
    }
  }

  void _calculateTimeRemaining() {
    final diff = widget.startTime.difference(DateTime.now());
    if (diff.isNegative || diff == Duration.zero) {
      _timeRemaining = Duration.zero;
      if (_timer != null) {
        _timer?.cancel();
        _timer = null;
        if (widget.onTimerFinished != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onTimerFinished!();
            }
          });
        }
      }
    } else {
      _timeRemaining = diff;
    }
  }

  @override
  void didUpdateWidget(covariant CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime != widget.startTime) {
      _timer?.cancel();
      _timer = null;
      _calculateTimeRemaining();
      _startTimerIfNeeded();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration <= Duration.zero) {
      return "LIVE";
    }
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return "${days}d ${hours}h ${minutes}m";
    }

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    return "${hStr}h ${mStr}m ${sStr}s";
  }

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary isolates per-second timer repaints from parent list tiles.
    return RepaintBoundary(
      child: Text(
        _formatDuration(_timeRemaining),
        style: widget.style,
      ),
    );
  }
}
