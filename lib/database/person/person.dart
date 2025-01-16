import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';

part 'person.g.dart';

class Person extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

@DriftAccessor(tables: [Person])
class PersonDao extends DatabaseAccessor<MyDatabase> with _$PersonDaoMixin {
  PersonDao(MyDatabase db) : super(db);
  Future<List<PersonData>> getAll() async => await select(person).get();

  Future<int> insertData(PersonCompanion data) async {
    final isExistsWithIdenticalName = await customSelect('''SELECT id from person WHERE name = ? LIMIT 1''', variables: [Variable.withString(data.name.value)]).getSingleOrNull();
    if (isExistsWithIdenticalName != null) throw ('Customer with same already exists');
    return await into(person).insert(data);
  }

  Future<PersonData> getById(int id) async => await (select(person)
        ..where(
          (tbl) => tbl.id.equals(id),
        ))
      .getSingle();
  Future<void> updateData(PersonCompanion data) async => await (update(person)).replace(data);
  Future<void> deleteById(int id) async {
    await (delete(person)..where((tbl) => tbl.id.equals(id))).go();
  }
}
