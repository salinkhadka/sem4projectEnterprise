import 'package:byaparlekha/components/customDropDown.dart';
import 'package:byaparlekha/models/valueModel.dart';
import 'package:flutter/src/widgets/framework.dart';

class BooleanDropDown extends StatelessWidget {
  final bool? selectedValue;
  final Function(bool) onValueSelected;

  final String? Function(int?)? validator;
  final String? nepaliYesTranslation;
  final String? nepaliNoTranslation;
  const BooleanDropDown({
    Key? key,
    required this.selectedValue,
    this.nepaliYesTranslation,
    this.nepaliNoTranslation,
    required this.onValueSelected,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropDown(
        validator: validator,
        selectedValue: selectedValue == null
            ? null
            : selectedValue == true
                ? 1
                : 2,
        onValueSelected: (value) {
          return onValueSelected(value == 1);
        },
        values: [
          ValueModel(id: 1, name: 'Yes', nepaliName: nepaliYesTranslation ?? 'हुन्छ'),
          ValueModel(id: 2, name: 'No', nepaliName: nepaliNoTranslation ?? 'हुदैन'),
        ]);
  }
}
