import 'package:flutter/material.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class BookDetailsPage extends StatelessWidget {
  final String isbn;

  const BookDetailsPage({super.key, required this.isbn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: "도서 상세"));
  }
}
