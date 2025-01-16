import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';
import 'package:byaparlekha/models/accountDataModel.dart';
import 'package:nepali_utils/nepali_utils.dart';

part 'account.g.dart';

class Account extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nepaliName => text()();
  RealColumn get balance => real().withDefault(Constant(0))();
  IntColumn get accountTypeId => integer()();
  BoolColumn get isSystem => boolean().withDefault(Constant(false))();
  DateTimeColumn get openingBalanceDate => dateTime().nullable()();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
}

@DriftAccessor(tables: [Account])
class AccountDao extends DatabaseAccessor<MyDatabase> with _$AccountDaoMixin {
  AccountDao(MyDatabase db) : super(db);

  Future<List<AccountData>> getAll() async => await select(account).get();

  Future<double> getOpeningBalance() async {
    final data = await customSelect('''select SUM(balance) as balance from account ''').getSingle();
    return data.data['balance'] ?? 0.0;
  }

  Future<List<AccountDataModel>> getAccountWithIcon() async {
    final data = await customSelect('''select a.*,at.icon_name as icon_name FROM account a INNER JOIN account_type at on a.account_type_id = at.id''').get();
    return data
        .map((e) => AccountDataModel(
              incomeExpenseAmount: 0.0,
              id: e.data['id'],
              name: e.data['name'],
              iconName: e.data['icon_name'],
              nepaliName: e.data['nepali_name'],
              balance: e.data['balance'],
              accountTypeId: e.data['account_type_id'],
              isSystem: e.data['is_system'] == 1,
              createdDate: DateTime.fromMillisecondsSinceEpoch(e.data['created_date'] * 1000),
            ))
        .toList();
  }

  Future<double> openingBalanceOfCurrentMonth(int year, int month) async {
    final data = await customSelect(
      '''select SUM(a.balance) balance from account a WHERE 
       strftime('%m', date(COALESCE(a.opening_balance_date,a.created_date), 'unixepoch','localtime')) = ? AND 
       strftime('%Y', date(COALESCE(a.opening_balance_date,a.created_date), 'unixepoch','localtime')) = ?''',
      variables: [
        Variable.withInt(year),
        Variable.withInt(month),
      ],
      readsFrom: {
        account,
      },
    ).getSingle();
    return (data.read<double?>('balance') ?? 0.0);
  }

  Stream<double> watchOpeningBalanceTillNow(int year, int month) {
    final DateTime endDate = NepaliDateTime(year, month + 1, 0).toDateTime();
    final row = customSelect(
      '''select SUM(a.balance)balance from account a WHERE 
        date(COALESCE(a.opening_balance_date,a.created_date), 'unixepoch','localtime')< ?''',
      variables: [
        Variable.withString((endDate).toIso8601String().split('T').first),
      ],
      readsFrom: {
        account,
      },
    ).watchSingle();
    return row.map((data) => (data.read<double?>('balance') ?? 0.0));
  }

  Future<int> insertData(AccountCompanion data) async => await into(account).insert(data);
  Future<AccountData> getById(int id) async => await (select(account)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> updateData(AccountCompanion data) async => await (update(account)).replace(data);

  Stream<List<AccountDataModel>> watchAccountInformation() {
    final data = customSelect('''SELECT a.*,at.icon_name as icon_name, coalesce(SUM(CASE WHEN coalesce(ch.is_income,0) = 1 THEN t.amount ELSE t.amount*-1 END),0) income_expense_amount from account a 
        INNER JOIN account_type at on a.account_type_id = at.id
        LEFT JOIN transactions t ON a.id = t.account_id
        LEFT JOIN category c on c.id=t.category_id
        LEFT JOIN category_heading ch on ch.id=c.category_heading_id
        GROUP BY a.id''', readsFrom: {account}).watch();

    return data.map((event) => event
        .map((e) => AccountDataModel(
              incomeExpenseAmount: e.data['income_expense_amount'].toDouble(),
              id: e.data['id'],
              name: e.data['name'],
              iconName: e.data['icon_name'],
              nepaliName: e.data['nepali_name'],
              balance: e.data['balance'],
              accountTypeId: e.data['account_type_id'],
              isSystem: e.data['is_system'] == 1,
              createdDate: DateTime.fromMillisecondsSinceEpoch(e.data['created_date'] * 1000),
              openingBalanceDate: e.data['opening_balance_date'] != null ? DateTime.fromMillisecondsSinceEpoch(e.data['opening_balance_date'] * 1000) : null,
            ))
        .toList());
  }

  Future<void> deleteAccount(int id) async {
    final data = await customSelect('''SELECT t.id FROM transactions t WHERE t.account_id = ?  ''', variables: [Variable.withInt(id)]).getSingleOrNull();
    if (data != null)
      throw ('Cannot delete! This account is linked with some transactions.');
    else
      await (delete(account)..where((tbl) => tbl.id.equals(id))).go();
  }
}
