import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/config/configuration.dart';
import 'package:byaparlekha/models/textModel.dart';

class FormWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isRequired;
  final bool makeBoldTitle;
  const FormWidget(
      {Key? key,
      required this.title,
      required this.child,
      this.makeBoldTitle = false,
      this.isRequired = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdaptiveText(
          TextModel(title),
          style: Configuration().kInputFieldTitle.copyWith(
              fontWeight: makeBoldTitle ? FontWeight.bold : FontWeight.normal),
          suffixText: isRequired ? "*" : null,
        ),
        SizedBox(
          height: 3,
        ),
        child
      ],
    );
  }
}
