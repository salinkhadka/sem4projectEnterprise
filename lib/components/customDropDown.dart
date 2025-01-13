import 'package:flutter/material.dart';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/models/valueModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:provider/provider.dart';

class CustomDropDown extends StatelessWidget {
  final int? selectedValue;
  final Function(int?) onValueSelected;
  final String? Function(int?)? validator;
  final List<ValueModel> values;
  final String hintText;

  final bool allowValueAddition;

  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  const CustomDropDown(
      {Key? key,
      required this.selectedValue,
      required this.onValueSelected,
      this.validator,
      this.allowValueAddition = false,
      required this.values,
      this.enabled = true,
      this.contentPadding = const EdgeInsets.fromLTRB(12, 12, 12, 12),
      this.hintText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<PreferenceProvider>(context).language;
    return IgnorePointer(
      ignoring: !enabled,
      child: DropdownButtonFormField<int>(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        validator: validator,
        decoration: InputDecoration(contentPadding: contentPadding, enabled: enabled),
        isExpanded: true,
        hint: AdaptiveText(
          TextModel(hintText),
          style: TextStyle(fontSize: 13),
        ),
        value: (selectedValue ?? 0) < 1
            ? null
            : (values).map((e) => e.id).toList().contains(selectedValue)
                ? selectedValue
                : null,
        selectedItemBuilder: (context) => [
          ...(values)
              .map(
                (e) => itemWidget(e, language),
              )
              .toList(),
          if (allowValueAddition && (selectedValue == -1)) AdaptiveText(TextModel('Add New')),
        ],
        onChanged: (value) {
          if (value == -1) {
            onValueSelected(value);
          } else {
            if (selectedValue != value) onValueSelected(value);
          }
        },
        items: [
          ...(values)
              .map((e) => DropdownMenuItem(
                    child: itemWidget(e, language),
                    value: e.id,
                  ))
              .toList(),
          if (allowValueAddition)
            DropdownMenuItem(
              child: AdaptiveText(TextModel('Add New')),
              value: -1,
            ),
        ],
      ),
    );
  }

  Widget itemWidget(ValueModel valueModel, Lang lang) {
    return Row(
      children: [
        if (valueModel.iconData != null) valueModel.iconData!,
        if (valueModel.iconData != null)
          SizedBox(
            width: 15,
          ),
        Expanded(
          child: Text(
            lang == Lang.EN ? valueModel.name : (valueModel.nepaliName ?? valueModel.name),
          ),
        ),
      ],
    );
  }
}
