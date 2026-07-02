import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime startTime;
  final TextStyle style;

  const CountdownTimerWidget({
    super.key,
    required this.startTime,
    required this.style,
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
    _timeRemaining = widget.startTime.difference(DateTime.now());
    if (_timeRemaining.isNegative) {
      _timeRemaining = Duration.zero;
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
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
    return Text(
      _formatDuration(_timeRemaining),
      style: widget.style,
    );
  }
}
