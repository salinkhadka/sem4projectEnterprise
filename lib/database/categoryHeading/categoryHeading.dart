import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';

part 'categoryHeading.g.dart';

class CategoryHeading extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nepaliName => text()();
  TextColumn get iconName => text().nullable()();
  BoolColumn get isIncome => boolean()();
  BoolColumn get isSystem => boolean().withDefault(Constant(false))();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
}

@DriftAccessor(tables: [CategoryHeading])
class CategoryHeadingDao extends DatabaseAccessor<MyDatabase> with _$CategoryHeadingDaoMixin {
  CategoryHeadingDao(MyDatabase db) : super(db);
  Future<List<CategoryHeadingData>> getAll() async => await select(categoryHeading).get();
  Future<List<CategoryHeadingData>> getByIncomeExpense(bool isIncome) async => await (select(categoryHeading)..where((tbl) => tbl.isIncome.equals(isIncome))).get();
  Future<int> insertData(CategoryHeadingCompanion data) async => await into(categoryHeading).insert(data);
  Future<CategoryHeadingData> getById(int id) async => await (select(categoryHeading)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> updateData(CategoryHeadingCompanion data) async => await (update(categoryHeading)).replace(data);
}
