import 'package:flutter/material.dart';

class RadioText<T> extends StatelessWidget {
  final T type;
  final String label;

  const RadioText({super.key, required this.type, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(key: ValueKey(type), value: type),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}
