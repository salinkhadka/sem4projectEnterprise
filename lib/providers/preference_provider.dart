import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:flutter/foundation.dart';
import 'package:nepali_utils/nepali_utils.dart';

enum Lang { EN, NP }

class PreferenceProvider extends ChangeNotifier {
  Lang _language = SharedPreferenceService().getLanguage;
  Lang get language => _language;
  bool get isEnglish => language == Lang.EN;
  set language(Lang lang) {
    _language = lang;
    SharedPreferenceService().setLanguage = _language;
    NepaliUtils(isEnglish ? Language.english : Language.nepali);
    notifyListeners();
  }
}
