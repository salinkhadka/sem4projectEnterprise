import 'package:byaparlekha/database/myDatabase/database.dart';

class AccountDataModel extends AccountData {
  final double incomeExpenseAmount;
  final String? iconName;
  AccountDataModel(
      {required this.incomeExpenseAmount,
      this.iconName,
      required super.id,
      required super.name,
      required super.nepaliName,
      required super.balance,
      required super.accountTypeId,
      required super.isSystem,
      required super.createdDate,
      super.openingBalanceDate});
}
