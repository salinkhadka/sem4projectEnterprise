import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:drift/drift.dart';

// assuming that your file is called filename.dart. This will give an error at
// first, but it's needed for drift to know about the generated code
part 'user.g.dart';

// this will generate a table called "User" for us. The rows of that table will
// be represented by a class called "Todo".
class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get mobileNumber => text()();
  TextColumn get userData => text()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
}

@DriftAccessor(tables: [User])
class UserDao extends DatabaseAccessor<MyDatabase> with _$UserDaoMixin {
  UserDao(MyDatabase db) : super(db);
  Future<List<UserData>> getAll() async => await select(user).get();
  Future<int> insertData(UserCompanion data) async {
    if (data.id.present) {
      await (delete(user)..where((tbl) => tbl.id.equals(data.id.value))).go();
    }
    return await into(user).insert(data);
  }

  Future<UserData> getById(int id) async => (select(user)
        ..where(
          (tbl) => tbl.id.equals(id),
        ))
      .getSingle();

  Future<UserData> getUserData() async => await (select(user)..limit(1)).getSingle();
  Future<UserData> getUserDataInformation() async => await (select(user)..limit(1)).getSingle();

  Future<void> updateData(UserCompanion data) async => await (update(user)).replace(data);

  Future<String?> getExpiryDate() async {
    final data = await customSelect('''SELECT expiry_date FROM user LIMIT 1''').getSingleOrNull();
    return data?.read<String>('expiry_date');
  }

  Future<bool> isUserSubscribed() async {
    try {
      final data = await customSelect('''SELECT expiry_date FROM user LIMIT 1''').getSingleOrNull();
      if (data == null) return false;
      final DateTime? expiryDate = DateTime.tryParse(data.read<String?>('expiry_date') ?? '');
      if (expiryDate == null) return false;
      return expiryDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
