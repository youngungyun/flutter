import 'package:flutter/material.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  final BookService bookService = BookService.instance;
  ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: "내 정보"));
  }
}
