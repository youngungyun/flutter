import 'package:flutter/material.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/widgets/book/radio_text.dart';

class BookSortTypeSelector extends StatefulWidget {
  final void Function(SortType) _onChange;
  const BookSortTypeSelector({
    super.key,
    required void Function(SortType) onChange,
  }) : _onChange = onChange;

  @override
  State<BookSortTypeSelector> createState() => _BookSortTypeSelectorState();
}

class _BookSortTypeSelectorState extends State<BookSortTypeSelector> {
  SortType _groupValue = SortType.accurcy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: RadioGroup<SortType>(
          groupValue: _groupValue,
          onChanged: (SortType? value) {
            setState(() {
              _groupValue = value!;
            });
            if (value != null) {
              widget._onChange(value);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: SortType.values.map((type) {
              return RadioText(
                key: ValueKey(type),
                type: type,
                label: type.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
