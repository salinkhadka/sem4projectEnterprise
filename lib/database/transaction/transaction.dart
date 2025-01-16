import 'dart:io';

import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/monthlyBudgetProjectionReport.dart';
import 'package:byaparlekha/models/monthyCategoryReport.dart';
import 'package:byaparlekha/models/transactionSummary.dart';
import 'package:drift/drift.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

part 'transaction.g.dart';

/// 0= Income , 1= Expense
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get image => text().nullable()();
  RealColumn get amount => real()();
  IntColumn get accountId => integer()();
  //For Day Logs
  BoolColumn get isDailySales => boolean().withDefault(Constant(false))();
  TextColumn get billNumber => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get modifiedDate => dateTime().nullable()();
}

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<MyDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(MyDatabase db) : super(db);

  Future<List<Transaction>> getAll() async => await select(transactions).get();
  Future<int> insertData(
    TransactionsCompanion data,
  ) async =>
      await into(transactions).insert(data);
  Future<int> insertDataWithDailySales(TransactionsCompanion data, List<TransactionItemData> items, int personId) async {
    return await transaction(() async {
      final tId = await insertData(data);
      for (TransactionItemData item in items) {
        await AppDatabase().myDatabase.transactionItemDao.insertData(
              TransactionItemCompanion(
                amount: Value<double>(item.amount),
                itemId: Value<int>(item.itemId),
                personId: Value<int>(personId),
                quantity: Value<double>(item.quantity),
                transactionId: Value<int>(tId),
              ),
            );
      }
      return tId;
    });
  }

  Future<void> updateDataWithDailySales(TransactionsCompanion data, List<TransactionItemData> items, List<int> itemsToBeDeleted, int personId) async {
    return await transaction(() async {
      await update(transactions).replace(data);
      for (TransactionItemData item in items) {
        bool isUpdating = item.id > 0;
        TransactionItemCompanion dataToBeInsertedOrUpdated = TransactionItemCompanion(
            amount: Value<double>(item.amount),
            itemId: Value<int>(item.itemId),
            personId: Value<int>(personId),
            quantity: Value<double>(item.quantity),
            transactionId: Value<int>(data.id.value),
            createdDate: !isUpdating ? Value.absent() : Value<DateTime>(item.createdDate),
            id: !isUpdating ? Value.absent() : Value(item.id));

        if (isUpdating) {
          await AppDatabase().myDatabase.transactionItemDao.updateData(dataToBeInsertedOrUpdated);
        } else {
          await AppDatabase().myDatabase.transactionItemDao.insertData(dataToBeInsertedOrUpdated);
        }
      }
      for (int itemId in itemsToBeDeleted) {
        await AppDatabase().myDatabase.transactionItemDao.deleteById(itemId);
      }
    });
  }

  Future<Transaction?> getById(int id) async => await (select(transactions)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  Future<void> updateData(TransactionsCompanion data) async {
    await AppDatabase().myDatabase.transactionItemDao.deleteByTransactionId(data.id.value);
    await update(transactions).replace(data);
  }

  Stream<List<TransactionSummary>> watchTransactionByMonth(NepaliDateTime nepaliDateTime) {
    final DateTime startDate = NepaliDateTime(nepaliDateTime.year, nepaliDateTime.month, 1).toDateTime();
    final DateTime endDate = NepaliDateTime(nepaliDateTime.year, nepaliDateTime.month, nepaliDateTime.totalDays).toDateTime();
    final rows = customSelect(
      ''' SELECT t.*, c.name,c.nepali_name, c.category_heading_id,c.id as category_id,c.order_id as category_order_id, 
    ch.icon_name as category_icon_name,c.created_date, ch.is_income 
    FROM [transactions] AS t
    INNER JOIN category c ON c.[Id] = t.[category_id]
    INNER JOIN category_heading ch ON ch.Id = c.category_heading_id
    WHERE date(t.[transaction_date], 'unixepoch','localtime') BETWEEN ? AND ?''',
      variables: [
        Variable.withString((startDate).toIso8601String().split('T').first),
        Variable.withString((endDate).toIso8601String().split('T').first),
      ],
      readsFrom: {
        transactions,
      },
    ).watch();
    return rows.map((event) => event.map((e) => TransactionSummary.fromDatabase(e.data)).toList());
  }

  Stream<double> watchCumulativeCashPosition(int year, int month) {
    final DateTime endDate = NepaliDateTime(year, month + 1, 0).toDateTime();
    final rows = customSelect(
      '''SELECT SUM(CASE WHEN ch.is_income=1 THEN t.amount ELSE -t.amount END) amount
    FROM [transactions] AS t
    INNER JOIN category c ON c.[Id] = t.[category_id]
    INNER JOIN category_heading ch ON ch.Id = c.category_heading_id
    WHERE date(t.[transaction_date], 'unixepoch','localtime') <= ? ORDER BY t.transaction_date''',
      variables: [
        Variable.withString((endDate).toIso8601String().split('T').first),
      ],
      readsFrom: {
        transactions,
      },
    ).watchSingle();

    return rows.map((event) => (event.data['amount'] ?? 0.0));
  }

  Future<List<MonthlyCategoryReport>> getMonthlyTransactionReportByCategory(NepaliDateTime date) async {
    final DateTime startDate = NepaliDateTime(date.year, date.month, 1).toDateTime();
    final DateTime endDate = NepaliDateTime(date.year, date.month, date.totalDays).toDateTime();
    final rows = await customSelect(
      ''' SELECT c.*, t.transaction_date,ch.is_income,ch.name as category_heading_name,
      SUM(CASE WHEN ch.is_income  = 1 THEN coalesce(t.[amount],0) ELSE 0 END) AS [inflowAmount],
      SUM(CASE WHEN ch.is_income = 0 THEN coalesce(t.[amount],0) ELSE 0 END) AS [outflowAmount]
    FROM category c 
    INNER JOIN category_heading ch ON ch.Id = c.category_heading_id
    LEFT JOIN [transactions] AS t ON c.[Id] = t.[category_id]
    WHERE date(t.[transaction_date], 'unixepoch','localtime') BETWEEN ? AND ? Group by c.id ORDER BY t.transaction_date''',
      variables: [
        Variable.withString((startDate).toIso8601String().split('T').first),
        Variable.withString((endDate).toIso8601String().split('T').first),
      ],
      readsFrom: {
        transactions,
      },
    ).get();
    return rows.map((e) => MonthlyCategoryReport.fromDatabase(e.data)).toList();
  }

  Future<List<MonthlyCategoryReport>> getMonthlyTransactionReportByCategoryId(NepaliDateTime date) async {
    final DateTime startDate = NepaliDateTime(date.year, date.month, 1).toDateTime();
    final DateTime endDate = NepaliDateTime(date.year, date.month, date.totalDays).toDateTime();
    final rows = await customSelect(
      ''' SELECT c.*, t.transaction_date,ch.name as category_heading_name,ch.is_income,
      SUM(CASE WHEN ch.is_income  = 1 THEN coalesce(t.[amount],0) ELSE 0 END) AS [inflowAmount],
      SUM(CASE WHEN ch.is_income = 0 THEN coalesce(t.[amount],0) ELSE 0 END) AS [outflowAmount]
    FROM category c 
    INNER JOIN category_heading ch ON ch.Id = c.category_heading_id
    LEFT JOIN [transactions] AS t ON c.[Id] = t.[category_id]
    WHERE date(t.[transaction_date], 'unixepoch','localtime') BETWEEN ? AND ? Group by c.id ORDER BY t.transaction_date''',
      variables: [
        Variable.withString((startDate).toIso8601String().split('T').first),
        Variable.withString((endDate).toIso8601String().split('T').first),
      ],
      readsFrom: {
        transactions,
      },
    ).get();
    return rows.map((e) => MonthlyCategoryReport.fromDatabase(e.data)).toList();
  }

  Future<List<MonthlyBudgetProjectionReport>> getActualCashflowForCategoryForReportBetweemDates(bool isIncome, NepaliDateTime startDateTime, NepaliDateTime endDateTime) async {
    List<NepaliDateTime> _dateResolver = [];
    List<MonthlyBudgetProjectionReport> data = [];
    int noOfMonths = ((((endDateTime.year - startDateTime.year) * 12) + endDateTime.month) - startDateTime.month);
    int initYear = startDateTime.year;
    int indexYear = initYear;
    for (int i = startDateTime.month; i <= (noOfMonths + startDateTime.month); i++) {
      _dateResolver.add(NepaliDateTime(indexYear, (i % 12 == 0) ? 12 : i % 12));
      if (i % 12 == 0) {
        indexYear++;
      }
    }
    final categories = await AppDatabase().myDatabase.categoryDao.getCategoryByIncomeExpenseForReport(isIncome);
    for (NepaliDateTime currentDateTime in _dateResolver) {
      final transactionData = await getMonthlyTransactionReportByCategoryId(currentDateTime);
      for (CategoryData currentCategory in categories) {
        final double currentCategoryTransactionData = transactionData
            .where((element) => element.categoryData.id == currentCategory.id)
            .fold(0.0, (previousValue, element) => previousValue + (element.isIncome ? element.inflowAmount : element.outflowAmount));
        data.add(MonthlyBudgetProjectionReport(
          reportDate: NepaliDateTime(currentDateTime.year, currentDateTime.month),
          categoryData: currentCategory,
          budget: currentCategoryTransactionData,
          isIncome: isIncome,
          categoryHeadingName: currentCategory.iconName ?? '',
        ));
      }
    }
    return data;
  }

  Future<void> deleteTransaction(int id) async {
    final Transaction? transactionData = await getById(id);
    if (transactionData == null) throw ('Transaction doesnt exists');
    await transaction(() async {
      await AppDatabase().myDatabase.transactionItemDao.deleteByTransactionId(id);
      await (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
    });

    if (transactionData.image != null) File(transactionData.image!).delete();
  }
}
