import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';
import 'package:byaparlekha/models/transactionItemSummary.dart';
import 'package:nepali_utils/nepali_utils.dart';

part 'transactionItem.g.dart';

class TransactionItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer()();
  IntColumn get itemId => integer()();
  IntColumn get personId => integer()();
  RealColumn get quantity => real()();
  RealColumn get amount => real()();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
}

@DriftAccessor(tables: [TransactionItem])
class TransactionItemDao extends DatabaseAccessor<MyDatabase> with _$TransactionItemDaoMixin {
  TransactionItemDao(MyDatabase db) : super(db);
  Future<List<TransactionItemData>> getAll() async => await select(transactionItem).get();
  Future<int> insertData(TransactionItemCompanion data) async => await into(transactionItem).insert(data);
  Future<TransactionItemData> getById(int id) async => await (select(transactionItem)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<List<TransactionItemData>> getAllByTransactionId(int transactionId) async => await (select(transactionItem)..where((tbl) => tbl.transactionId.equals(transactionId))).get();

  Future<void> updateData(TransactionItemCompanion data) async => await (update(transactionItem)).replace(data);
  Future<void> deleteById(int id) async {
    await (delete(transactionItem)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> deleteByTransactionId(int transactionId) async {
    await (delete(transactionItem)..where((tbl) => tbl.transactionId.equals(transactionId))).go();
  }

  Stream<List<TransactionItemSummary>> watchTransactionByDay(NepaliDateTime nepaliDateTime) {
    final DateTime date = NepaliDateTime(nepaliDateTime.year, nepaliDateTime.month, nepaliDateTime.day).toDateTime();
    final rows = customSelect(
      '''SELECT ti.*,t.id as transaction_id,  pi.id as person_id,pi.name as person_name,i.name as item_name, t.created_date as transaction_created_date,t.bill_number,
      c.id as category_id, c.name as category_name, c.nepali_name as category_nepali_name, c.is_system as category_is_system,
      ch.is_income,ch.id as category_heading_id,ch.name as category_heading_name,ch.nepali_name as category_heading_nepali_name,
      ch.is_system as category_heading_is_system, t.transaction_date  FROM transaction_item ti
      INNER JOIN [transactions] AS t on t.id = ti.transaction_id
      INNER JOIN category c ON c.[Id] = t.[category_id]
      INNER JOIN category_heading ch ON ch.Id = c.category_heading_id
      INNER JOIN person pi on pi.id = ti.person_id
      INNER JOIN item i on i.id = ti.item_id
      WHERE date(t.[transaction_date], 'unixepoch','localtime') = ? ORDER BY t.transaction_date
''',
      variables: [
        Variable.withString((date).toIso8601String().split('T').first),
      ],
      readsFrom: {
        transactionItem,
      },
    ).watch();
    return rows.map((event) => event.map((e) {
          return TransactionItemSummary.fromDatabase(e.data);
        }).toList());
  }

  Future<List<TransactionItemSummary>> getTransactionItem(NepaliDateTime fromNepaliDateTime, NepaliDateTime toNepaliDateTime) async {
    final DateTime fromDate = NepaliDateTime(fromNepaliDateTime.year, fromNepaliDateTime.month, fromNepaliDateTime.day).toDateTime();
    final DateTime toDate = NepaliDateTime(toNepaliDateTime.year, toNepaliDateTime.month, toNepaliDateTime.day).toDateTime();
    final rows = await customSelect(
      '''SELECT ti.*,t.id as transaction_id,pi.id as person_id,pi.name as person_name,i.name as item_name, t.created_date as transaction_created_date,t.bill_number,
      c.id as category_id, c.name as category_name, c.nepali_name as category_nepali_name, c.is_system as category_is_system,
      ch.is_income,ch.id as category_heading_id,ch.name as category_heading_name,ch.nepali_name as category_heading_nepali_name,
      ch.is_system as category_heading_is_system, t.transaction_date  FROM transaction_item ti
      INNER JOIN [transactions] AS t on t.id = ti.transaction_id
      INNER JOIN category c ON c.[Id] = t.[category_id]
      INNER JOIN category_heading ch ON ch.Id = c.category_heading_id
      INNER JOIN person pi on pi.id = ti.person_id
      INNER JOIN item i on i.id = ti.item_id
    WHERE date(t.[transaction_date], 'unixepoch','localtime') BETWEEN ? AND ? ORDER BY t.transaction_date
''',
      variables: [
        Variable.withString((fromDate).toIso8601String().split('T').first),
        Variable.withString((toDate).toIso8601String().split('T').first),
      ],
      readsFrom: {
        transactionItem,
      },
    ).get();
    return rows.map((e) {
      return TransactionItemSummary.fromDatabase(e.data);
    }).toList();
  }
}
