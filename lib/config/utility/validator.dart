import 'package:byaparlekha/config/globals.dart';

class Validators {
  Validators._();
  static String? emptyFieldValidator(String? value) => value!.trim().isEmpty ? 'Field Required' : null;

  static String? phoneNumberValidator(String? value) => value!.trim().isEmpty
      ? 'Value Required'
      : value.trim().length != 10
          ? 'Phone Number must be of 10 digit'
          : null;

  static String? integerValidator(String? value) => value!.trim().isEmpty
      ? 'Value Required'
      : (int.tryParse(value.trim()) == null)
          ? 'Invalid Value'
          : null;
  static String? doubleValidator(String? value) => value!.trim().isEmpty
      ? 'Value Required'
      : (double.tryParse(value.trim()) == null)
          ? 'Invalid Value'
          : null;

  static String? dropDownFieldValidator(int? value) => (value ?? 0) < 1 ? 'Value Required' : null;
}
