import 'package:byaparlekha/database/category/category.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/database/transaction/transaction.dart';
import 'package:byaparlekha/models/budgetModel.dart';
import 'package:drift/drift.dart';
import 'package:byaparlekha/models/monthlyBudgetProjectionReport.dart';
import 'package:byaparlekha/models/monthlyBudgetReport.dart';
import 'package:byaparlekha/models/monthlyBudgetReportByDateTime.dart';
import 'package:byaparlekha/models/monthlyProjectionModel.dart';
import 'package:byaparlekha/models/monthyCategoryReport.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

part 'budget.g.dart';

class Budget extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  RealColumn get budget => real()();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
}

@DriftAccessor(tables: [Budget, Transactions, Category])
class BudgetDao extends DatabaseAccessor<MyDatabase> with _$BudgetDaoMixin {
  BudgetDao(MyDatabase db) : super(db);
  Stream<List<BudgetModel>> getBudgetProjectionByMonth(bool isIncome, NepaliDateTime nepaliDateTime) {
    final data = customSelect(
      '''SELECT b.id as id,b.id as budget_id,c.name as category_name, c.id as category_id,
      ch.id as category_heading_id,ch.name as category_heading_name,ch.nepali_name as category_heading_nepali_name,
    b.budget as budget,0 as amount, ch.icon_name as category_icon ,
    c.nepali_name as category_nepali_name from category c
    INNER JOIN category_heading ch on ch.id = c.category_heading_id
    LEFT JOIN budget b ON (c.id = b.category_id AND b.year=? AND b.month = ?)
    WHERE ch.is_income=? GROUP BY c.id ORDER BY c.name''',
      variables: [
        Variable.withInt(nepaliDateTime.year),
        Variable.withInt(nepaliDateTime.month),
        Variable.withBool(isIncome),
      ],
      readsFrom: {transactions, budget, category},
    ).watch();
    return data.map((event) => event.map((e) => BudgetModel.fromDatabase(e.data)).toList());
  }

  Stream<double> getCumulativeBudgetProjectionUptoDateTime(NepaliDateTime nepaliDateTime) {
    final data = customSelect(
      '''SELECT SUM(CASE WHEN ch.is_income  = 1 THEN b.[budget] ELSE -b.budget END) amount
    from budget b
    INNER JOIN category c on c.id = b.category_id
    INNER JOIN category_heading ch on ch.id = c.category_heading_id
    WHERE b.year <= ? AND b.month <= ? ORDER BY c.name''',
      variables: [
        Variable.withInt(nepaliDateTime.year),
        Variable.withInt(nepaliDateTime.month),
      ],
      readsFrom: {budget, category},
    ).watchSingleOrNull();
    return data.map((event) => event == null ? 0.0 : event.read<double>('amount'));
  }

  Future<List<MonthlyCategoryReport>> getBudgetProjectionForReport(NepaliDateTime nepaliDateTime) async {
    final event = await customSelect(
      '''SELECT c.id as id,b.id as budget_id,c.name as name,c.nepali_name as nepali_name, c.category_heading_id as category_heading_id,
      ch.name as category_heading_name,
      c.order_id as order_id, c.is_system as is_system, ? as transaction_date, ch.is_income as is_income,
    (CASE WHEN ch.is_income=1 THEN b.budget ELSE 0 END) as inflowAmount,
    (CASE WHEN ch.is_income=0 THEN b.budget ELSE 0 END) as outflowAmount,  ch.icon_name as category_icon 
     from category c
    INNER JOIN category_heading ch on ch.id = c.category_heading_id
    LEFT JOIN budget b ON (c.id = b.category_id AND b.year=? AND b.month = ?)
    ORDER BY c.id''',
      variables: [
        Variable.withInt(nepaliDateTime.millisecondsSinceEpoch),
        Variable.withInt(nepaliDateTime.year),
        Variable.withInt(nepaliDateTime.month),
      ],
      readsFrom: {transactions, budget},
    ).get();
    return event.map((e) => MonthlyCategoryReport.fromDatabase(e.data)).toList();
  }

  Future<double> getProjectedCumulativeCashPosition(int year, int month) async {
    final event = await customSelect(
      '''SELECT SUM(CASE WHEN ch.is_income  = 1 THEN b.[budget] ELSE -b.budget END) as budget
      FROM budget b 
      INNER JOIN category c on b.category_id = c.id
      INNER JOIN category_heading ch on ch.id = c.category_heading_id
     WHERE b .year <= ? AND b.month <= ? ''',
      variables: [
        Variable.withInt(year),
        Variable.withInt(month),
      ],
      readsFrom: {
        transactions,
      },
    ).getSingle();
    return (event.data['amount'] ?? 0.0);
  }

  Future<List<MonthlyProjectionModel>> getBudgetVsActualtProjectionForMonth(NepaliDateTime nepaliDateTime) async {
    final DateTime startDate = NepaliDateTime(nepaliDateTime.year, nepaliDateTime.month, 1).toDateTime();
    final DateTime endDate = NepaliDateTime(nepaliDateTime.year, nepaliDateTime.month, nepaliDateTime.totalDays).toDateTime();
    final event = await customSelect(
      '''SELECT c.id as id,b.id as budget_id,c.name as name,c.nepali_name as nepali_name, c.category_heading_id as category_heading_id,
      ch.name as category_heading_name,c.created_date as created_date,
      c.order_id as order_id, c.is_system as is_system,  ch.is_income as is_income,
      SUM(b.budget) as budget,
      SUM(t.amount) as actualAmount,  ch.icon_name as category_icon 
      from category c
      INNER JOIN category_heading ch on ch.id = c.category_heading_id
      LEFT JOIN budget b ON (c.id = b.category_id AND b.year=? AND b.month = ?)
      LEFT JOIN transactions t on (t.category_id = c.id   AND date(t.[transaction_date], 'unixepoch','localtime') BETWEEN ? AND ?)
      GROUP BY c.id, b.year,b.month
      ORDER BY lower(c.name)''',
      variables: [
        Variable.withInt(nepaliDateTime.year),
        Variable.withInt(nepaliDateTime.month),
        Variable.withString((startDate).toIso8601String().split('T').first),
        Variable.withString((endDate).toIso8601String().split('T').first),
      ],
      readsFrom: {transactions, budget},
    ).get();
    return event
        .map((e) => MonthlyProjectionModel(
              categoryData: CategoryData(
                id: e.data['id'],
                name: e.data['name'],
                nepaliName: e.data['nepali_name'],
                categoryHeadingId: e.data['category_heading_id'],
                orderId: e.data['order_id'],
                isSystem: e.data['is_system'] == 1,
                createdDate: DateTime.fromMillisecondsSinceEpoch(e.data['created_date'] * 1000),
              ),
              budgetAmount: e.data['budget'] ?? 0.0,
              actualAmount: e.data['actualAmount'] ?? 0.0,
              isIncome: e.data['is_income'] == 1,
              categoryHeadingName: e.data['category_heading_name'],
            ))
        .toList();
  }

  Future<List<MonthlyBudgetProjectionReport>> getBudgetProjectionForReportBetweemDates(bool isIncome, NepaliDateTime startDateTime, NepaliDateTime endDateTime) async {
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
      for (CategoryData currentCategory in categories) {
        final budgetData = await customSelect('''select b.year,b.month,b.budget FROM 
       budget b WHERE b.category_id = ? AND b.year= ? AND b.month = ?''', variables: [
          Variable.withInt(currentCategory.id),
          Variable.withInt(currentDateTime.year),
          Variable.withInt(currentDateTime.month),
        ]).getSingleOrNull();
        data.add(MonthlyBudgetProjectionReport(
          reportDate: NepaliDateTime(currentDateTime.year, currentDateTime.month),
          categoryData: currentCategory,
          budget: budgetData != null ? budgetData.read<double?>('budget') ?? 0.0 : 0.0,
          isIncome: isIncome,
          categoryHeadingName: currentCategory.iconName ?? '',
        ));
      }
    }
    return data;
  }

  Future<List<MonthyBudgetReport>> getBudgetProjectionBetweenMonths(NepaliDateTime fromDate, NepaliDateTime toDate) async {
    final NepaliDateTime startDate = NepaliDateTime(fromDate.year, fromDate.month, 1);
    final NepaliDateTime endDate = NepaliDateTime(toDate.year, toDate.month, toDate.totalDays);
    final data = await customSelect(
      '''SELECT b.year,b.month,
      SUM(CASE WHEN ch.is_income  = 1 THEN b.[budget] ELSE 0 END) AS [inflowBudget],
      SUM(CASE WHEN ch.is_income = 0 THEN b.[budget] ELSE 0 END) AS [outflowBudget]
      FROM category c 
      INNER JOIN  category_heading ch on ch.id = c.category_heading_id
      LEFT JOIN budget b on (c.id = b.category_id) AND (b.year  BETWEEN ? AND ?) AND (b.month BETWEEN ? AND ? ) 
     GROUP By b.year, b.month ORDER BY b.year, b.month
     ''',
      variables: [
        Variable.withInt(startDate.year),
        Variable.withInt(endDate.year),
        Variable.withInt(startDate.month),
        Variable.withInt(endDate.month),
      ],
      readsFrom: {transactions, budget, category},
    ).get();
    return data.map((e) => MonthyBudgetReport.fromDatabase(e.data)).toList();
  }

  // Future<int> insertData(BudgetCompanion data) async => await into(Budget).insert(data);
  Future<BudgetData> getById(int id) async => await (select(budget)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<void> clearBudget(int categoryId, int year, int month) async {
    await customUpdate('''DELETE FROM budget WHERE category_id = ? AND year =? AND month =?''',
        updateKind: UpdateKind.delete,
        updates: {budget},
        variables: [
          Variable.withInt(categoryId),
          Variable.withInt(year),
          Variable.withInt(month),
        ]);
  }

  Future<void> setBudget(int categoryId, int year, int month, double amount) async {
    await into(budget).insert(
      BudgetCompanion(
        budget: Value<double>(amount),
        year: Value<int>(year),
        month: Value<int>(month),
        categoryId: Value<int>(categoryId),
      ),
    );
  }

  Future<void> updateBudget(int budgetId, double amount) async {
    await customUpdate('''UPDATE budget SET budget = ? WHERE id = ? ''',
        updateKind: UpdateKind.delete,
        updates: {budget},
        variables: [
          Variable.withReal(amount),
          Variable.withInt(budgetId),
        ]);
  }

  Future<void> updateData(BudgetCompanion data) async => await (update(budget)).replace(data);
}
