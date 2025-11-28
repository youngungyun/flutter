import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: "도서 검색"));
  }
}
