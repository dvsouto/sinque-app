import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionTimeDisplay extends StatefulWidget {
  final DateTime actionTime;

  ActionTimeDisplay({super.key, required this.actionTime});

  @override
  _ActionTimeDisplayState createState() => _ActionTimeDisplayState();
}

class _ActionTimeDisplayState extends State<ActionTimeDisplay> {
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startUpdatingTime();
  }

  void _startUpdatingTime() {
    Future.delayed(Duration(seconds: 30, milliseconds: 999), () {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });

        _startUpdatingTime();
      }
    });
  }

  String _getTimeAgo() {
    final duration = _currentTime.difference(widget.actionTime);

    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''} ago';
    }

    if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''} ago';
    }

    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''} ago';
    }

    return 'Now';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: Text(
        _getTimeAgo(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w100,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
