import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rebook/dto/book/book_result.dart';

class BookCard extends StatelessWidget {
  final BookResponse book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    void onTap() {
      context.push("/book/$book.isbn");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 20.0,
                  right: 30.0,
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: book.thumbnailUrl == null
                    ? null
                    : Image.network(book.thumbnailUrl!),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(book.authors.join(',')),
                    Text(book.publisher),
                    Text(book.isbn),
                    Text(DateFormat('yyyy-MM-dd').format(book.publishDate!)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
