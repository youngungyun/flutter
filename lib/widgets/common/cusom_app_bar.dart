import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  const CustomAppBar({super.key, required String title}) : _title = title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      centerTitle: true,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
