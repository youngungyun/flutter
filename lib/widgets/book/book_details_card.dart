import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rebook/dto/book/book_details.dart';

class BookDetailsCard extends StatelessWidget {
  final BookDetails bookDetails;

  const BookDetailsCard({super.key, required this.bookDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            width: 2.0,
          ),
        ),
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      left: 10.0,
                      right: 20.0,
                    ),
                    child: Image.network(bookDetails.thumbnailUrl),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bookDetails.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text('${bookDetails.authors.join(', ')} 지음'),
                        bookDetails.translators.isEmpty
                            ? const SizedBox.shrink()
                            : Text('${bookDetails.translators.join(', ')} 번역'),
                        Text(bookDetails.isbn),
                        Text(bookDetails.publisher),
                        Text(
                          DateFormat(
                            'yyyy-MM-dd',
                          ).format(bookDetails.publishDate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
