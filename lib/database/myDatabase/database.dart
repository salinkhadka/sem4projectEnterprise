import 'dart:io';

import 'package:byaparlekha/database/account/account.dart';
import 'package:byaparlekha/database/accountType/accountType.dart';
import 'package:byaparlekha/database/budget/budget.dart';
import 'package:byaparlekha/database/category/category.dart';
import 'package:byaparlekha/database/categoryHeading/categoryHeading.dart';
import 'package:byaparlekha/database/item/item.dart';
import 'package:byaparlekha/database/person/person.dart';
import 'package:byaparlekha/database/transaction/transaction.dart';
import 'package:byaparlekha/database/transactionItem/transactionItem.dart';
import 'package:byaparlekha/services/userService.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class AppDatabase {
  MyDatabase myDatabase = MyDatabase();
  static AppDatabase? appDatabase;
  AppDatabase._();
  factory AppDatabase() {
    appDatabase ??= AppDatabase._();
    return appDatabase!;
  }
}

@DriftDatabase(
  tables: [
    Account,
    Category,
    CategoryHeading,
    Person,
    Item,
    Transactions,
    TransactionItem,
    Budget,
    AccountType,
  ],
  daos: [
    AccountDao,
    CategoryDao,
    CategoryHeadingDao,
    PersonDao,
    ItemDao,
    TransactionsDao,
    TransactionItemDao,
    BudgetDao,
    AccountTypeDao,
  ],
)
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        if (details.wasCreated) {
          final data = await UserService().getDefaultsData();
          transaction(() async {
            final List<dynamic> categoryHeadingData = data['categoryHeadings'];
            final List<dynamic> categoryData = data['categories'];
            final List<dynamic> accountTypeData = data['accountType'];
            final List<dynamic> accountsData = data['account'];
            await Future.wait(categoryHeadingData
                .map(
                  (e) => into(categoryHeading).insert(
                      CategoryHeadingCompanion(
                        id: Value<int>(e['id']),
                        iconName: Value<String?>(e['iconName']),
                        name: Value<String>(e['name']),
                        nepaliName: Value<String>(e['nepaliName'] ?? e['name']),
                        isIncome: Value<bool>(e['isIncome'] ?? false),
                        isSystem: Value<bool>(true),
                      ),
                      mode: InsertMode.insertOrIgnore,
                      onConflict: DoNothing()),
                )
                .toList());
            for (int i = 0; i < categoryData.length; i++) {
              final e = categoryData[i];
              into(category).insert(
                  CategoryCompanion(
                    categoryHeadingId: Value<int>(e['categoryHeadingId']),
                    iconName: Value<String?>(e['iconName']),
                    id: Value<int>(e['id']),
                    isSystem: Value<bool>(true),
                    orderId: Value<int>(i + 1),
                    name: Value<String>(e['name']),
                    nepaliName: Value<String>(e['nepaliName'] ?? e['name']),
                  ),
                  mode: InsertMode.insertOrIgnore,
                  onConflict: DoNothing());
            }
            await Future.wait(accountTypeData
                .map(
                  (e) => into(accountType).insert(
                      AccountTypeCompanion(
                        id: Value<int>(e['id']),
                        name: Value<String>(e['name']),
                        nepaliName: Value<String>(e['nepaliName'] ?? e['name']),
                        iconName: Value<String?>(e['iconName']),
                      ),
                      mode: InsertMode.insertOrIgnore,
                      onConflict: DoNothing()),
                )
                .toList());
            await Future.wait(accountsData
                .map(
                  (e) => into(account).insert(
                      AccountCompanion(
                        id: Value<int>(e['id']),
                        name: Value<String>(e['name']),
                        nepaliName: Value<String>(e['nepaliName'] ?? e['name']),
                        isSystem: Value<bool>(true),
                        balance: Value<double>(0.0),
                        accountTypeId: Value<int>(e['accountTypeId']),
                      ),
                      mode: InsertMode.insertOrIgnore,
                      onConflict: DoNothing()),
                )
                .toList());
          });
        }
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 3) {
          var rep = await m.database.customSelect('''SELECT name 
                                  FROM sqlite_master 
                                  WHERE type='account' 
                                  AND name='opening_balance_date LIMIT 1''').getSingleOrNull();
          if (rep != null && rep.data['name'] == null) await m.addColumn(account, account.openingBalanceDate);
        }
      },
    );
  }

  closeDatabase() async {
    await AppDatabase().myDatabase.close();
    AppDatabase.appDatabase = null;
  }

  Future<void> closeAndDeleteDatabase() async {
    await closeDatabase();
    final databasePath = await getDatabaseFilePath;
    try {
      await File(databasePath).delete();
    } catch (e) {}
  }

  Future<void> deleteAndUpdateDatabase(List<int> _fileBytes) async {
    await closeAndDeleteDatabase();
    final databasePath = await getDatabaseFilePath;
    // try {
    //   await File(databasePath).delete();
    // } catch (e) {}
    await File(databasePath).writeAsBytes(_fileBytes);
  }

  @override
  int get schemaVersion => 3;
}

const String databaseName = 'byaparlekha.db';
Future<String> get getDatabaseFilePath async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return (join(dbFolder.path, databaseName));
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(
    () async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFilePath = await getDatabaseFilePath;
      final file = File(dbFilePath);
      return NativeDatabase(
        file,
        logStatements: true,
      );
    },
  );
}
