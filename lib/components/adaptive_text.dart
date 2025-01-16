import 'package:flutter/widgets.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:provider/provider.dart';

import 'package:byaparlekha/providers/preference_provider.dart';

import '../config/utility/resource_map.dart';

class AdaptiveText extends StatelessWidget {
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final bool? isProviderEnabled;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? textScaleFactor;
  final TextModel text;
  final String? suffixText;

  AdaptiveText(this.text, {Key? key, this.isProviderEnabled, this.maxLines, this.overflow, this.softWrap, this.style, this.textAlign, this.textDirection, this.textScaleFactor, this.suffixText});

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, preferenceProvider, _) => Text(
        (preferenceProvider.language == Lang.EN
                ? text.name
                : text.nepaliName == null
                    ? (ResourceMap[text.name.toLowerCase()] ?? text.name)
                    : text.nepaliName!) +
            '${suffixText ?? ""}',
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: textScaleFactor,
      ),
    );
  }
}
