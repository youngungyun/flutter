import 'package:flutter/material.dart';

class ScrollFloatingAction extends StatelessWidget {
  final void Function() _onPressed;
  const ScrollFloatingAction({super.key, required void Function() onPressed})
    : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _onPressed,
      child: Icon(
        Icons.arrow_upward,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
