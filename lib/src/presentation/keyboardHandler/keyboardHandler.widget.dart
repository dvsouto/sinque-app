import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardHandler extends StatefulWidget {
  final Widget child;
  const KeyboardHandler({super.key, required this.child});

  @override
  State<KeyboardHandler> createState() => _KeyboardHandlerState();
}

class _KeyboardHandlerState extends State<KeyboardHandler> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initialState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyPress(KeyEvent event) {
    print("haha");
    if (event is KeyDownEvent) {
      final bool isControlPressed =
          event.logicalKey == LogicalKeyboardKey.controlLeft ||
              event.logicalKey == LogicalKeyboardKey.controlRight;

      if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyV) {
        print("Ctrl + V Pressed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyPress,
      child: GestureDetector(
        onTap: () {
          print("Tap");
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: widget.child,
      ),
    );
  }
}
