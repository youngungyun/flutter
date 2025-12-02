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
      context.push("/book/${book.isbn}");
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 2.0,
            ),
          ),
          elevation: 3.0,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 20.0,
                  right: 30.0,
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: Image.network(book.thumbnailUrl),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${book.authors.join(', ')} 지음'),
                    Text(book.publisher),
                    Text(book.isbn),
                    Text(DateFormat('yyyy-MM-dd').format(book.publishDate)),
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
