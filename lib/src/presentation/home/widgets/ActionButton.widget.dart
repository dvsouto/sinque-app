import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function? onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(120, 100),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
