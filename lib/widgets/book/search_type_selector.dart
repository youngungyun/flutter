import 'package:flutter/material.dart';
import 'package:rebook/services/book_service.dart';
import 'package:rebook/widgets/book/radio_text.dart';

class SearchTypeSelector extends StatefulWidget {
  final void Function(SearchType) _onChange;
  const SearchTypeSelector({
    super.key,
    required void Function(SearchType) onChange,
  }) : _onChange = onChange;

  @override
  State<StatefulWidget> createState() => _SearchTypeSelectorState();
}

class _SearchTypeSelectorState extends State<SearchTypeSelector> {
  SearchType _groupValue = SearchType.title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: RadioGroup<SearchType>(
          groupValue: _groupValue,
          onChanged: (SearchType? value) {
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
            children: SearchType.values.map((type) {
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
