import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';

part 'accountType.g.dart';

class AccountType extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nepaliName => text()();
  TextColumn get iconName => text().nullable()();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
}

@DriftAccessor(tables: [AccountType])
class AccountTypeDao extends DatabaseAccessor<MyDatabase> with _$AccountTypeDaoMixin {
  AccountTypeDao(MyDatabase db) : super(db);

  Future<List<AccountTypeData>> getAll() async => await select(accountType).get();
  Future<int> insertData(AccountTypeCompanion data) async => await into(accountType).insert(data);
  Future<AccountTypeData> getById(int id) async => await (select(accountType)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> updateData(AccountTypeCompanion data) async => await (update(accountType)).replace(data);
}
