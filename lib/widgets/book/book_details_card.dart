import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rebook/dto/book/book_details.dart';
import 'package:rebook/widgets/book/book_image.dart';

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
                    child: BookImage(
                      imageUrl: bookDetails.thumbnail,
                      imageWidth: 120,
                      imageHeight: 174,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          bookDetails.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${bookDetails.authors.join(', ')} 지음',
                          style: TextStyle(fontSize: 16),
                        ),
                        bookDetails.translators.isEmpty
                            ? const SizedBox.shrink()
                            : Text(
                                '${bookDetails.translators.join(', ')} 번역',
                                style: TextStyle(fontSize: 16),
                              ),
                        Text(bookDetails.isbn, style: TextStyle(fontSize: 16)),
                        Text(
                          bookDetails.publisher,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(bookDetails.datetime),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Text(
                  "도서 내용",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Text(bookDetails.contents, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
