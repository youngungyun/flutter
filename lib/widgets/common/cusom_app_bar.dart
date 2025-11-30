import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  const CustomAppBar({super.key, required String title}) : _title = title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        _title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
