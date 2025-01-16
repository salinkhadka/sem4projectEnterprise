import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';
import 'package:byaparlekha/models/categoryModel.dart';

part 'category.g.dart';

class Category extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nepaliName => text()();
  TextColumn get iconName => text().nullable()();
  IntColumn get categoryHeadingId => integer()();
  IntColumn get orderId => integer()();
  BoolColumn get isSystem => boolean().withDefault(Constant(false))();
  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();
}

@DriftAccessor(tables: [Category])
class CategoryDao extends DatabaseAccessor<MyDatabase> with _$CategoryDaoMixin {
  CategoryDao(MyDatabase db) : super(db);

  Future<List<CategoryData>> getAll() async => await select(category).get();

  Future<int> insertData(CategoryCompanion data) async {
    final isExistsWithIdenticalName = await customSelect('''SELECT id from category WHERE name = ? LIMIT 1''', variables: [Variable.withString(data.name.value)]).getSingleOrNull();
    if (isExistsWithIdenticalName != null) throw ('Category with same name already exists');
    final maxOrder = await customSelect('''SELECT MAX(order_id)as value from category ''').getSingleOrNull();
    return await into(category).insert(data.copyWith(orderId: Value<int>((maxOrder?.read<int?>('value') ?? 0) + 1)));
  }

  Future<CategoryData> getById(int id) async => await (select(category)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<void> updateData(CategoryCompanion data) async => await (update(category)).replace(data);
  Future<int> updateCategoryName(int categoryId, String name) async => await (update(category)
            ..where(
              (tbl) => tbl.id.equals(categoryId),
            ))
          .write(CategoryCompanion(
        id: Value<int>(categoryId),
        categoryHeadingId: Value.absent(),
        createdDate: Value.absent(),
        iconName: Value.absent(),
        isSystem: Value.absent(),
        name: Value<String>(name),
        nepaliName: Value.absent(),
        orderId: Value.absent(),
      ));
  Future<List<CategoryData>> getByCategoryHeadingId(int categoryHeadingId) async => await (select(category)
        ..where(
          (tbl) => tbl.categoryHeadingId.equals(categoryHeadingId),
        ))
      .get();
  Future<List<CategoryData>> getCategoryByIncomeExpense(bool isIncome) async {
    final data = await customSelect(
      '''SELECT c.*, ch.icon_name as categoryHeadingIconName from category c 
      INNER JOIN category_heading ch ON ch.id = c.category_heading_id WHERE ch.is_income = ? ORDER BY lower(c.name)''',
      variables: [Variable.withInt(isIncome ? 1 : 0)],
      readsFrom: {category},
    ).get();

    return data
        .map(
          (p0) => CategoryData(
            orderId: p0.read<int>('order_id'),
            id: p0.read<int>('id'),
            iconName: p0.read<String?>('categoryHeadingIconName'),
            name: p0.read<String>('name'),
            nepaliName: p0.read<String>('nepali_name'),
            categoryHeadingId: p0.read<int>('category_heading_id'),
            isSystem: p0.read<int>('is_system') == 1,
            createdDate: DateTime.fromMillisecondsSinceEpoch(p0.read<int>('created_date') * 1000),
          ),
        )
        .toList();
  }

  Future<List<CategoryData>> getCategoryByIncomeExpenseForReport(bool isIncome) async {
    final data = await customSelect(
      '''SELECT c.*, ch.name as categoryHeadingName from category c 
      INNER JOIN category_heading ch ON ch.id = c.category_heading_id WHERE ch.is_income = ? ORDER BY ch.name,lower(c.name) asc''',
      variables: [Variable.withInt(isIncome ? 1 : 0)],
      readsFrom: {category},
    ).get();

    return data
        .map(
          (p0) => CategoryData(
            orderId: p0.read<int>('order_id'),
            id: p0.read<int>('id'),
            iconName: p0.read<String?>('categoryHeadingName'),
            name: p0.read<String>('name'),
            nepaliName: p0.read<String>('nepali_name'),
            categoryHeadingId: p0.read<int>('category_heading_id'),
            isSystem: p0.read<int>('is_system') == 1,
            createdDate: DateTime.fromMillisecondsSinceEpoch(p0.read<int>('created_date') * 1000),
          ),
        )
        .toList();
  }

  Stream<List<CategoryModel>> watchCategoryByIncomeExpense(bool isIncome) {
    final data = customSelect('''SELECT c.*, ch.icon_name as categoryHeadingIconName,ch.name as category_heading_name  from category c 
        INNER JOIN category_heading ch ON ch.id = c.category_heading_id WHERE ch.is_income = ? ORDER BY ch.name''', variables: [Variable.withInt(isIncome ? 1 : 0)], readsFrom: {category}).watch();
    return data.map((event) => event.map((p0) => CategoryModel.fromDatabase(p0.data)).toList());
  }

  Future<void> deleteCategory(int id) async {
    final data = await customSelect('''SELECT t.id FROM transactions t WHERE t.category_id = ?  ''', variables: [Variable.withInt(id)]).getSingleOrNull();
    if (data != null)
      throw ('Cannot delete! This category is linked with some transactions.');
    else
      await (delete(category)..where((tbl) => tbl.id.equals(id))).go();
  }
}
