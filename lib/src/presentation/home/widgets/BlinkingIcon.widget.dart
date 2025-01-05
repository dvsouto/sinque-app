import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingIcon extends StatefulWidget {
  late bool blinkActive;
  late Widget child;

  BlinkingIcon({super.key, this.blinkActive = true, required this.child});

  @override
  State<BlinkingIcon> createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<BlinkingIcon> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible || !widget.blinkActive ? 1.0 : 0.0,
      duration: Duration(seconds: 1),
      child: widget.child,
    );
  }
}
