import 'package:flutter/material.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferenceService? _instance;
  static late SharedPreferences _prefs;

  static ValueNotifier<bool> isReady = ValueNotifier(false);

  SharedPreferenceService._() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _prefs = prefs;
        isReady.value = true;
      },
    );
  }

  factory SharedPreferenceService() {
    _instance ??= SharedPreferenceService._();
    return _instance!;
  }

  String get accessToken => _prefs.getString('USER_TOKEN') ?? '';
  set accessToken(String value) => _prefs.setString('USER_TOKEN', value);
  //
  bool get isFirstTime => _prefs.getBool('isFirstTime') ?? true;
  set isFirstTime(bool value) => _prefs.setBool('isFirstTime', false);

  String get userName => _prefs.getString('userName') ?? '';
  set userName(String value) => _prefs.setString('userName', value);

  String get _language => _prefs.getString('LANGUAGE') ?? 'en';
  set _language(String value) => _prefs.setString('LANGUAGE', value);

  String? get lastBackupDate => _prefs.getString('lastBackupDate');
  set lastBackupDate(String? value) => _prefs.setString('lastBackupDate', value!);

  String? get lastSyncDate => _prefs.getString('lastSyncDate');
  set lastSyncDate(String? value) => _prefs.setString('lastSyncDate', value!);

  Lang get getLanguage => Lang.values.firstWhere((element) => element.name.toUpperCase().compareTo(_language.toUpperCase()) == 0, orElse: () {
        return Lang.EN;
      });

  set setLanguage(Lang lang) {
    if (lang == Lang.EN)
      _language = 'en';
    else
      _language = 'np';
  }

  clearPreference() {
    final userNameValue = userName;
    final isFirstTimeValue = isFirstTime;
    _prefs.clear();
    userName = userNameValue;
    isFirstTime = isFirstTimeValue;
  }
}
