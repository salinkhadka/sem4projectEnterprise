import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';

part 'item.g.dart';

class Item extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DriftAccessor(tables: [Item])
class ItemDao extends DatabaseAccessor<MyDatabase> with _$ItemDaoMixin {
  ItemDao(MyDatabase db) : super(db);
  Future<List<ItemData>> getAll() async => await select(item).get();

  Future<int> insertData(ItemCompanion data) async {
    final isExistsWithIdenticalName = await customSelect('''SELECT id from item WHERE name = ? LIMIT 1''', variables: [Variable.withString(data.name.value)]).getSingleOrNull();
    if (isExistsWithIdenticalName != null) throw ('Item with same name already exists');
    return await into(item).insert(data);
  }

  Future<ItemData> getById(int id) async => await (select(item)
        ..where(
          (tbl) => tbl.id.equals(id),
        ))
      .getSingle();
  Future<void> updateData(ItemCompanion data) async => await (update(item)).replace(data);
  Future<void> deleteById(int id) async {
    await (delete(item)..where((tbl) => tbl.id.equals(id))).go();
  }
}
