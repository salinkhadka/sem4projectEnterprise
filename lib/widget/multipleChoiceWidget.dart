import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/models/textModel.dart';

import 'package:byaparlekha/models/valueModel.dart';

class MultipleChoiceWidget extends StatelessWidget {
  final List<int> selected;
  final List<ValueModel> values;
  final Function(int) onSelect;
  final Function(int) onRemove;
  const MultipleChoiceWidget({
    Key? key,
    required this.selected,
    required this.values,
    required this.onSelect,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: values.map((e) {
        final isSelected = selected.contains(e.id);
        return ChoiceChip(
          onSelected: (value) {
            if (value)
              onSelect(e.id);
            else
              onRemove(e.id);
          },
          selected: isSelected,
          selectedColor: Colors.green,
          label: AdaptiveText(
            TextModel(e.name, nepaliName: e.nepaliName),
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
