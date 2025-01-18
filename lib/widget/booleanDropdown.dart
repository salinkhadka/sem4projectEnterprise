import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:byaparlekha/components/customDropDown.dart';
import 'package:byaparlekha/models/valueModel.dart';

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