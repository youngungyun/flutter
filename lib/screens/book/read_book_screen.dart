import 'package:flutter/material.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class ReadBookScreen extends StatefulWidget {
  const ReadBookScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends State<ReadBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: "내가 읽은 책"));
  }
}
