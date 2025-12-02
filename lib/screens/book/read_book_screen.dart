import 'package:flutter/material.dart';
import 'package:rebook/dto/book/book_result.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/widgets/book/book_card.dart';
import 'package:rebook/widgets/common/cusom_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReadBookScreen extends StatefulWidget {
  final BookService bookService = BookService.instance;

  ReadBookScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReadBookScreenState();
}

class _ReadBookScreenState extends State<ReadBookScreen> {
  late final ScrollController _scrollController;
  final String _userId = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "내가 읽은 책"),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<List<BookResponse>>(
              future: widget.bookService.findReadBooks(_userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text(
                      "다시 시도해주세요.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }

                List<BookResponse> result = snapshot.data!;

                if (result.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(20.0),
                      child: Text("없다!!!", style: TextStyle(fontSize: 24)),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: result.length,
                  itemBuilder: (context, index) =>
                      BookCard(key: ValueKey(index), book: result[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
