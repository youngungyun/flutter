import 'package:flutter/material.dart';

class BookDetailsCardSkeleton extends StatelessWidget {
  const BookDetailsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        height: 215.0,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
