import 'package:flutter/material.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';

class ReviewDetailsPage extends StatelessWidget {
  const ReviewDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: "도서 상세"));
  }
}
