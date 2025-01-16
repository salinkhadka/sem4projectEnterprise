// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountTable extends Account with TableInfo<$AccountTable, AccountData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nepaliNameMeta =
      const VerificationMeta('nepaliName');
  @override
  late final GeneratedColumn<String> nepaliName = GeneratedColumn<String>(
      'nepali_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _accountTypeIdMeta =
      const VerificationMeta('accountTypeId');
  @override
  late final GeneratedColumn<int> accountTypeId = GeneratedColumn<int>(
      'account_type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _openingBalanceDateMeta =
      const VerificationMeta('openingBalanceDate');
  @override
  late final GeneratedColumn<DateTime> openingBalanceDate =
      GeneratedColumn<DateTime>('opening_balance_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        nepaliName,
        balance,
        accountTypeId,
        isSystem,
        openingBalanceDate,
        createdDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account';
  @override
  VerificationContext validateIntegrity(Insertable<AccountData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nepali_name')) {
      context.handle(
          _nepaliNameMeta,
          nepaliName.isAcceptableOrUnknown(
              data['nepali_name']!, _nepaliNameMeta));
    } else if (isInserting) {
      context.missing(_nepaliNameMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('account_type_id')) {
      context.handle(
          _accountTypeIdMeta,
          accountTypeId.isAcceptableOrUnknown(
              data['account_type_id']!, _accountTypeIdMeta));
    } else if (isInserting) {
      context.missing(_accountTypeIdMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('opening_balance_date')) {
      context.handle(
          _openingBalanceDateMeta,
          openingBalanceDate.isAcceptableOrUnknown(
              data['opening_balance_date']!, _openingBalanceDateMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nepaliName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nepali_name'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      accountTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_type_id'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      openingBalanceDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}opening_balance_date']),
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $AccountTable createAlias(String alias) {
    return $AccountTable(attachedDatabase, alias);
  }
}

class AccountData extends DataClass implements Insertable<AccountData> {
  final int id;
  final String name;
  final String nepaliName;
  final double balance;
  final int accountTypeId;
  final bool isSystem;
  final DateTime? openingBalanceDate;
  final DateTime createdDate;
  const AccountData(
      {required this.id,
      required this.name,
      required this.nepaliName,
      required this.balance,
      required this.accountTypeId,
      required this.isSystem,
      this.openingBalanceDate,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['nepali_name'] = Variable<String>(nepaliName);
    map['balance'] = Variable<double>(balance);
    map['account_type_id'] = Variable<int>(accountTypeId);
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || openingBalanceDate != null) {
      map['opening_balance_date'] = Variable<DateTime>(openingBalanceDate);
    }
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  AccountCompanion toCompanion(bool nullToAbsent) {
    return AccountCompanion(
      id: Value(id),
      name: Value(name),
      nepaliName: Value(nepaliName),
      balance: Value(balance),
      accountTypeId: Value(accountTypeId),
      isSystem: Value(isSystem),
      openingBalanceDate: openingBalanceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(openingBalanceDate),
      createdDate: Value(createdDate),
    );
  }

  factory AccountData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nepaliName: serializer.fromJson<String>(json['nepaliName']),
      balance: serializer.fromJson<double>(json['balance']),
      accountTypeId: serializer.fromJson<int>(json['accountTypeId']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      openingBalanceDate:
          serializer.fromJson<DateTime?>(json['openingBalanceDate']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nepaliName': serializer.toJson<String>(nepaliName),
      'balance': serializer.toJson<double>(balance),
      'accountTypeId': serializer.toJson<int>(accountTypeId),
      'isSystem': serializer.toJson<bool>(isSystem),
      'openingBalanceDate': serializer.toJson<DateTime?>(openingBalanceDate),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  AccountData copyWith(
          {int? id,
          String? name,
          String? nepaliName,
          double? balance,
          int? accountTypeId,
          bool? isSystem,
          Value<DateTime?> openingBalanceDate = const Value.absent(),
          DateTime? createdDate}) =>
      AccountData(
        id: id ?? this.id,
        name: name ?? this.name,
        nepaliName: nepaliName ?? this.nepaliName,
        balance: balance ?? this.balance,
        accountTypeId: accountTypeId ?? this.accountTypeId,
        isSystem: isSystem ?? this.isSystem,
        openingBalanceDate: openingBalanceDate.present
            ? openingBalanceDate.value
            : this.openingBalanceDate,
        createdDate: createdDate ?? this.createdDate,
      );
  AccountData copyWithCompanion(AccountCompanion data) {
    return AccountData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nepaliName:
          data.nepaliName.present ? data.nepaliName.value : this.nepaliName,
      balance: data.balance.present ? data.balance.value : this.balance,
      accountTypeId: data.accountTypeId.present
          ? data.accountTypeId.value
          : this.accountTypeId,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      openingBalanceDate: data.openingBalanceDate.present
          ? data.openingBalanceDate.value
          : this.openingBalanceDate,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('balance: $balance, ')
          ..write('accountTypeId: $accountTypeId, ')
          ..write('isSystem: $isSystem, ')
          ..write('openingBalanceDate: $openingBalanceDate, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nepaliName, balance, accountTypeId,
      isSystem, openingBalanceDate, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nepaliName == this.nepaliName &&
          other.balance == this.balance &&
          other.accountTypeId == this.accountTypeId &&
          other.isSystem == this.isSystem &&
          other.openingBalanceDate == this.openingBalanceDate &&
          other.createdDate == this.createdDate);
}

class AccountCompanion extends UpdateCompanion<AccountData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nepaliName;
  final Value<double> balance;
  final Value<int> accountTypeId;
  final Value<bool> isSystem;
  final Value<DateTime?> openingBalanceDate;
  final Value<DateTime> createdDate;
  const AccountCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nepaliName = const Value.absent(),
    this.balance = const Value.absent(),
    this.accountTypeId = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.openingBalanceDate = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  AccountCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nepaliName,
    this.balance = const Value.absent(),
    required int accountTypeId,
    this.isSystem = const Value.absent(),
    this.openingBalanceDate = const Value.absent(),
    this.createdDate = const Value.absent(),
  })  : name = Value(name),
        nepaliName = Value(nepaliName),
        accountTypeId = Value(accountTypeId);
  static Insertable<AccountData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nepaliName,
    Expression<double>? balance,
    Expression<int>? accountTypeId,
    Expression<bool>? isSystem,
    Expression<DateTime>? openingBalanceDate,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nepaliName != null) 'nepali_name': nepaliName,
      if (balance != null) 'balance': balance,
      if (accountTypeId != null) 'account_type_id': accountTypeId,
      if (isSystem != null) 'is_system': isSystem,
      if (openingBalanceDate != null)
        'opening_balance_date': openingBalanceDate,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  AccountCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nepaliName,
      Value<double>? balance,
      Value<int>? accountTypeId,
      Value<bool>? isSystem,
      Value<DateTime?>? openingBalanceDate,
      Value<DateTime>? createdDate}) {
    return AccountCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      balance: balance ?? this.balance,
      accountTypeId: accountTypeId ?? this.accountTypeId,
      isSystem: isSystem ?? this.isSystem,
      openingBalanceDate: openingBalanceDate ?? this.openingBalanceDate,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nepaliName.present) {
      map['nepali_name'] = Variable<String>(nepaliName.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (accountTypeId.present) {
      map['account_type_id'] = Variable<int>(accountTypeId.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (openingBalanceDate.present) {
      map['opening_balance_date'] =
          Variable<DateTime>(openingBalanceDate.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('balance: $balance, ')
          ..write('accountTypeId: $accountTypeId, ')
          ..write('isSystem: $isSystem, ')
          ..write('openingBalanceDate: $openingBalanceDate, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $CategoryTable extends Category
    with TableInfo<$CategoryTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nepaliNameMeta =
      const VerificationMeta('nepaliName');
  @override
  late final GeneratedColumn<String> nepaliName = GeneratedColumn<String>(
      'nepali_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryHeadingIdMeta =
      const VerificationMeta('categoryHeadingId');
  @override
  late final GeneratedColumn<int> categoryHeadingId = GeneratedColumn<int>(
      'category_heading_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        nepaliName,
        iconName,
        categoryHeadingId,
        orderId,
        isSystem,
        createdDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nepali_name')) {
      context.handle(
          _nepaliNameMeta,
          nepaliName.isAcceptableOrUnknown(
              data['nepali_name']!, _nepaliNameMeta));
    } else if (isInserting) {
      context.missing(_nepaliNameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('category_heading_id')) {
      context.handle(
          _categoryHeadingIdMeta,
          categoryHeadingId.isAcceptableOrUnknown(
              data['category_heading_id']!, _categoryHeadingIdMeta));
    } else if (isInserting) {
      context.missing(_categoryHeadingIdMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nepaliName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nepali_name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      categoryHeadingId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}category_heading_id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String name;
  final String nepaliName;
  final String? iconName;
  final int categoryHeadingId;
  final int orderId;
  final bool isSystem;
  final DateTime createdDate;
  const CategoryData(
      {required this.id,
      required this.name,
      required this.nepaliName,
      this.iconName,
      required this.categoryHeadingId,
      required this.orderId,
      required this.isSystem,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['nepali_name'] = Variable<String>(nepaliName);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['category_heading_id'] = Variable<int>(categoryHeadingId);
    map['order_id'] = Variable<int>(orderId);
    map['is_system'] = Variable<bool>(isSystem);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      name: Value(name),
      nepaliName: Value(nepaliName),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      categoryHeadingId: Value(categoryHeadingId),
      orderId: Value(orderId),
      isSystem: Value(isSystem),
      createdDate: Value(createdDate),
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nepaliName: serializer.fromJson<String>(json['nepaliName']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      categoryHeadingId: serializer.fromJson<int>(json['categoryHeadingId']),
      orderId: serializer.fromJson<int>(json['orderId']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nepaliName': serializer.toJson<String>(nepaliName),
      'iconName': serializer.toJson<String?>(iconName),
      'categoryHeadingId': serializer.toJson<int>(categoryHeadingId),
      'orderId': serializer.toJson<int>(orderId),
      'isSystem': serializer.toJson<bool>(isSystem),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  CategoryData copyWith(
          {int? id,
          String? name,
          String? nepaliName,
          Value<String?> iconName = const Value.absent(),
          int? categoryHeadingId,
          int? orderId,
          bool? isSystem,
          DateTime? createdDate}) =>
      CategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        nepaliName: nepaliName ?? this.nepaliName,
        iconName: iconName.present ? iconName.value : this.iconName,
        categoryHeadingId: categoryHeadingId ?? this.categoryHeadingId,
        orderId: orderId ?? this.orderId,
        isSystem: isSystem ?? this.isSystem,
        createdDate: createdDate ?? this.createdDate,
      );
  CategoryData copyWithCompanion(CategoryCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nepaliName:
          data.nepaliName.present ? data.nepaliName.value : this.nepaliName,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      categoryHeadingId: data.categoryHeadingId.present
          ? data.categoryHeadingId.value
          : this.categoryHeadingId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('iconName: $iconName, ')
          ..write('categoryHeadingId: $categoryHeadingId, ')
          ..write('orderId: $orderId, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nepaliName, iconName,
      categoryHeadingId, orderId, isSystem, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nepaliName == this.nepaliName &&
          other.iconName == this.iconName &&
          other.categoryHeadingId == this.categoryHeadingId &&
          other.orderId == this.orderId &&
          other.isSystem == this.isSystem &&
          other.createdDate == this.createdDate);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nepaliName;
  final Value<String?> iconName;
  final Value<int> categoryHeadingId;
  final Value<int> orderId;
  final Value<bool> isSystem;
  final Value<DateTime> createdDate;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nepaliName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.categoryHeadingId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nepaliName,
    this.iconName = const Value.absent(),
    required int categoryHeadingId,
    required int orderId,
    this.isSystem = const Value.absent(),
    this.createdDate = const Value.absent(),
  })  : name = Value(name),
        nepaliName = Value(nepaliName),
        categoryHeadingId = Value(categoryHeadingId),
        orderId = Value(orderId);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nepaliName,
    Expression<String>? iconName,
    Expression<int>? categoryHeadingId,
    Expression<int>? orderId,
    Expression<bool>? isSystem,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nepaliName != null) 'nepali_name': nepaliName,
      if (iconName != null) 'icon_name': iconName,
      if (categoryHeadingId != null) 'category_heading_id': categoryHeadingId,
      if (orderId != null) 'order_id': orderId,
      if (isSystem != null) 'is_system': isSystem,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  CategoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nepaliName,
      Value<String?>? iconName,
      Value<int>? categoryHeadingId,
      Value<int>? orderId,
      Value<bool>? isSystem,
      Value<DateTime>? createdDate}) {
    return CategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      iconName: iconName ?? this.iconName,
      categoryHeadingId: categoryHeadingId ?? this.categoryHeadingId,
      orderId: orderId ?? this.orderId,
      isSystem: isSystem ?? this.isSystem,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nepaliName.present) {
      map['nepali_name'] = Variable<String>(nepaliName.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (categoryHeadingId.present) {
      map['category_heading_id'] = Variable<int>(categoryHeadingId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('iconName: $iconName, ')
          ..write('categoryHeadingId: $categoryHeadingId, ')
          ..write('orderId: $orderId, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $CategoryHeadingTable extends CategoryHeading
    with TableInfo<$CategoryHeadingTable, CategoryHeadingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryHeadingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nepaliNameMeta =
      const VerificationMeta('nepaliName');
  @override
  late final GeneratedColumn<String> nepaliName = GeneratedColumn<String>(
      'nepali_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isIncomeMeta =
      const VerificationMeta('isIncome');
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
      'is_income', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_income" IN (0, 1))'));
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nepaliName, iconName, isIncome, isSystem, createdDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_heading';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoryHeadingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nepali_name')) {
      context.handle(
          _nepaliNameMeta,
          nepaliName.isAcceptableOrUnknown(
              data['nepali_name']!, _nepaliNameMeta));
    } else if (isInserting) {
      context.missing(_nepaliNameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('is_income')) {
      context.handle(_isIncomeMeta,
          isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta));
    } else if (isInserting) {
      context.missing(_isIncomeMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryHeadingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryHeadingData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nepaliName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nepali_name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      isIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_income'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $CategoryHeadingTable createAlias(String alias) {
    return $CategoryHeadingTable(attachedDatabase, alias);
  }
}

class CategoryHeadingData extends DataClass
    implements Insertable<CategoryHeadingData> {
  final int id;
  final String name;
  final String nepaliName;
  final String? iconName;
  final bool isIncome;
  final bool isSystem;
  final DateTime createdDate;
  const CategoryHeadingData(
      {required this.id,
      required this.name,
      required this.nepaliName,
      this.iconName,
      required this.isIncome,
      required this.isSystem,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['nepali_name'] = Variable<String>(nepaliName);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['is_income'] = Variable<bool>(isIncome);
    map['is_system'] = Variable<bool>(isSystem);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  CategoryHeadingCompanion toCompanion(bool nullToAbsent) {
    return CategoryHeadingCompanion(
      id: Value(id),
      name: Value(name),
      nepaliName: Value(nepaliName),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      isIncome: Value(isIncome),
      isSystem: Value(isSystem),
      createdDate: Value(createdDate),
    );
  }

  factory CategoryHeadingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryHeadingData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nepaliName: serializer.fromJson<String>(json['nepaliName']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nepaliName': serializer.toJson<String>(nepaliName),
      'iconName': serializer.toJson<String?>(iconName),
      'isIncome': serializer.toJson<bool>(isIncome),
      'isSystem': serializer.toJson<bool>(isSystem),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  CategoryHeadingData copyWith(
          {int? id,
          String? name,
          String? nepaliName,
          Value<String?> iconName = const Value.absent(),
          bool? isIncome,
          bool? isSystem,
          DateTime? createdDate}) =>
      CategoryHeadingData(
        id: id ?? this.id,
        name: name ?? this.name,
        nepaliName: nepaliName ?? this.nepaliName,
        iconName: iconName.present ? iconName.value : this.iconName,
        isIncome: isIncome ?? this.isIncome,
        isSystem: isSystem ?? this.isSystem,
        createdDate: createdDate ?? this.createdDate,
      );
  CategoryHeadingData copyWithCompanion(CategoryHeadingCompanion data) {
    return CategoryHeadingData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nepaliName:
          data.nepaliName.present ? data.nepaliName.value : this.nepaliName,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryHeadingData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('iconName: $iconName, ')
          ..write('isIncome: $isIncome, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, nepaliName, iconName, isIncome, isSystem, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryHeadingData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nepaliName == this.nepaliName &&
          other.iconName == this.iconName &&
          other.isIncome == this.isIncome &&
          other.isSystem == this.isSystem &&
          other.createdDate == this.createdDate);
}

class CategoryHeadingCompanion extends UpdateCompanion<CategoryHeadingData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nepaliName;
  final Value<String?> iconName;
  final Value<bool> isIncome;
  final Value<bool> isSystem;
  final Value<DateTime> createdDate;
  const CategoryHeadingCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nepaliName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  CategoryHeadingCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nepaliName,
    this.iconName = const Value.absent(),
    required bool isIncome,
    this.isSystem = const Value.absent(),
    this.createdDate = const Value.absent(),
  })  : name = Value(name),
        nepaliName = Value(nepaliName),
        isIncome = Value(isIncome);
  static Insertable<CategoryHeadingData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nepaliName,
    Expression<String>? iconName,
    Expression<bool>? isIncome,
    Expression<bool>? isSystem,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nepaliName != null) 'nepali_name': nepaliName,
      if (iconName != null) 'icon_name': iconName,
      if (isIncome != null) 'is_income': isIncome,
      if (isSystem != null) 'is_system': isSystem,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  CategoryHeadingCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nepaliName,
      Value<String?>? iconName,
      Value<bool>? isIncome,
      Value<bool>? isSystem,
      Value<DateTime>? createdDate}) {
    return CategoryHeadingCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      iconName: iconName ?? this.iconName,
      isIncome: isIncome ?? this.isIncome,
      isSystem: isSystem ?? this.isSystem,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nepaliName.present) {
      map['nepali_name'] = Variable<String>(nepaliName.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryHeadingCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('iconName: $iconName, ')
          ..write('isIncome: $isIncome, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $PersonTable extends Person with TableInfo<$PersonTable, PersonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'person';
  @override
  VerificationContext validateIntegrity(Insertable<PersonData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $PersonTable createAlias(String alias) {
    return $PersonTable(attachedDatabase, alias);
  }
}

class PersonData extends DataClass implements Insertable<PersonData> {
  final int id;
  final String name;
  const PersonData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PersonCompanion toCompanion(bool nullToAbsent) {
    return PersonCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory PersonData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  PersonData copyWith({int? id, String? name}) => PersonData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  PersonData copyWithCompanion(PersonCompanion data) {
    return PersonData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonData && other.id == this.id && other.name == this.name);
}

class PersonCompanion extends UpdateCompanion<PersonData> {
  final Value<int> id;
  final Value<String> name;
  const PersonCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PersonCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<PersonData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PersonCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PersonCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ItemTable extends Item with TableInfo<$ItemTable, ItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item';
  @override
  VerificationContext validateIntegrity(Insertable<ItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ItemTable createAlias(String alias) {
    return $ItemTable(attachedDatabase, alias);
  }
}

class ItemData extends DataClass implements Insertable<ItemData> {
  final int id;
  final String name;
  const ItemData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ItemCompanion toCompanion(bool nullToAbsent) {
    return ItemCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory ItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  ItemData copyWith({int? id, String? name}) => ItemData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  ItemData copyWithCompanion(ItemCompanion data) {
    return ItemData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemData && other.id == this.id && other.name == this.name);
}

class ItemCompanion extends UpdateCompanion<ItemData> {
  final Value<int> id;
  final Value<String> name;
  const ItemCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ItemCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ItemData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ItemCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ItemCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDailySalesMeta =
      const VerificationMeta('isDailySales');
  @override
  late final GeneratedColumn<bool> isDailySales = GeneratedColumn<bool>(
      'is_daily_sales', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_daily_sales" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _billNumberMeta =
      const VerificationMeta('billNumber');
  @override
  late final GeneratedColumn<String> billNumber = GeneratedColumn<String>(
      'bill_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _modifiedDateMeta =
      const VerificationMeta('modifiedDate');
  @override
  late final GeneratedColumn<DateTime> modifiedDate = GeneratedColumn<DateTime>(
      'modified_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        description,
        image,
        amount,
        accountId,
        isDailySales,
        billNumber,
        transactionDate,
        createdDate,
        modifiedDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('is_daily_sales')) {
      context.handle(
          _isDailySalesMeta,
          isDailySales.isAcceptableOrUnknown(
              data['is_daily_sales']!, _isDailySalesMeta));
    }
    if (data.containsKey('bill_number')) {
      context.handle(
          _billNumberMeta,
          billNumber.isAcceptableOrUnknown(
              data['bill_number']!, _billNumberMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    if (data.containsKey('modified_date')) {
      context.handle(
          _modifiedDateMeta,
          modifiedDate.isAcceptableOrUnknown(
              data['modified_date']!, _modifiedDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      isDailySales: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_daily_sales'])!,
      billNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_number']),
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      modifiedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_date']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int categoryId;
  final String? description;
  final String? image;
  final double amount;
  final int accountId;
  final bool isDailySales;
  final String? billNumber;
  final DateTime transactionDate;
  final DateTime createdDate;
  final DateTime? modifiedDate;
  const Transaction(
      {required this.id,
      required this.categoryId,
      this.description,
      this.image,
      required this.amount,
      required this.accountId,
      required this.isDailySales,
      this.billNumber,
      required this.transactionDate,
      required this.createdDate,
      this.modifiedDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    map['amount'] = Variable<double>(amount);
    map['account_id'] = Variable<int>(accountId);
    map['is_daily_sales'] = Variable<bool>(isDailySales);
    if (!nullToAbsent || billNumber != null) {
      map['bill_number'] = Variable<String>(billNumber);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['created_date'] = Variable<DateTime>(createdDate);
    if (!nullToAbsent || modifiedDate != null) {
      map['modified_date'] = Variable<DateTime>(modifiedDate);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      amount: Value(amount),
      accountId: Value(accountId),
      isDailySales: Value(isDailySales),
      billNumber: billNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(billNumber),
      transactionDate: Value(transactionDate),
      createdDate: Value(createdDate),
      modifiedDate: modifiedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedDate),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String?>(json['image']),
      amount: serializer.fromJson<double>(json['amount']),
      accountId: serializer.fromJson<int>(json['accountId']),
      isDailySales: serializer.fromJson<bool>(json['isDailySales']),
      billNumber: serializer.fromJson<String?>(json['billNumber']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      modifiedDate: serializer.fromJson<DateTime?>(json['modifiedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String?>(image),
      'amount': serializer.toJson<double>(amount),
      'accountId': serializer.toJson<int>(accountId),
      'isDailySales': serializer.toJson<bool>(isDailySales),
      'billNumber': serializer.toJson<String?>(billNumber),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'modifiedDate': serializer.toJson<DateTime?>(modifiedDate),
    };
  }

  Transaction copyWith(
          {int? id,
          int? categoryId,
          Value<String?> description = const Value.absent(),
          Value<String?> image = const Value.absent(),
          double? amount,
          int? accountId,
          bool? isDailySales,
          Value<String?> billNumber = const Value.absent(),
          DateTime? transactionDate,
          DateTime? createdDate,
          Value<DateTime?> modifiedDate = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        description: description.present ? description.value : this.description,
        image: image.present ? image.value : this.image,
        amount: amount ?? this.amount,
        accountId: accountId ?? this.accountId,
        isDailySales: isDailySales ?? this.isDailySales,
        billNumber: billNumber.present ? billNumber.value : this.billNumber,
        transactionDate: transactionDate ?? this.transactionDate,
        createdDate: createdDate ?? this.createdDate,
        modifiedDate:
            modifiedDate.present ? modifiedDate.value : this.modifiedDate,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      description:
          data.description.present ? data.description.value : this.description,
      image: data.image.present ? data.image.value : this.image,
      amount: data.amount.present ? data.amount.value : this.amount,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      isDailySales: data.isDailySales.present
          ? data.isDailySales.value
          : this.isDailySales,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
      modifiedDate: data.modifiedDate.present
          ? data.modifiedDate.value
          : this.modifiedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('amount: $amount, ')
          ..write('accountId: $accountId, ')
          ..write('isDailySales: $isDailySales, ')
          ..write('billNumber: $billNumber, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdDate: $createdDate, ')
          ..write('modifiedDate: $modifiedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      categoryId,
      description,
      image,
      amount,
      accountId,
      isDailySales,
      billNumber,
      transactionDate,
      createdDate,
      modifiedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.description == this.description &&
          other.image == this.image &&
          other.amount == this.amount &&
          other.accountId == this.accountId &&
          other.isDailySales == this.isDailySales &&
          other.billNumber == this.billNumber &&
          other.transactionDate == this.transactionDate &&
          other.createdDate == this.createdDate &&
          other.modifiedDate == this.modifiedDate);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String?> description;
  final Value<String?> image;
  final Value<double> amount;
  final Value<int> accountId;
  final Value<bool> isDailySales;
  final Value<String?> billNumber;
  final Value<DateTime> transactionDate;
  final Value<DateTime> createdDate;
  final Value<DateTime?> modifiedDate;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.amount = const Value.absent(),
    this.accountId = const Value.absent(),
    this.isDailySales = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.modifiedDate = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    required double amount,
    required int accountId,
    this.isDailySales = const Value.absent(),
    this.billNumber = const Value.absent(),
    required DateTime transactionDate,
    this.createdDate = const Value.absent(),
    this.modifiedDate = const Value.absent(),
  })  : categoryId = Value(categoryId),
        amount = Value(amount),
        accountId = Value(accountId),
        transactionDate = Value(transactionDate);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? description,
    Expression<String>? image,
    Expression<double>? amount,
    Expression<int>? accountId,
    Expression<bool>? isDailySales,
    Expression<String>? billNumber,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? createdDate,
    Expression<DateTime>? modifiedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (amount != null) 'amount': amount,
      if (accountId != null) 'account_id': accountId,
      if (isDailySales != null) 'is_daily_sales': isDailySales,
      if (billNumber != null) 'bill_number': billNumber,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (createdDate != null) 'created_date': createdDate,
      if (modifiedDate != null) 'modified_date': modifiedDate,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String?>? description,
      Value<String?>? image,
      Value<double>? amount,
      Value<int>? accountId,
      Value<bool>? isDailySales,
      Value<String?>? billNumber,
      Value<DateTime>? transactionDate,
      Value<DateTime>? createdDate,
      Value<DateTime?>? modifiedDate}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      image: image ?? this.image,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      isDailySales: isDailySales ?? this.isDailySales,
      billNumber: billNumber ?? this.billNumber,
      transactionDate: transactionDate ?? this.transactionDate,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (isDailySales.present) {
      map['is_daily_sales'] = Variable<bool>(isDailySales.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<String>(billNumber.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (modifiedDate.present) {
      map['modified_date'] = Variable<DateTime>(modifiedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('amount: $amount, ')
          ..write('accountId: $accountId, ')
          ..write('isDailySales: $isDailySales, ')
          ..write('billNumber: $billNumber, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdDate: $createdDate, ')
          ..write('modifiedDate: $modifiedDate')
          ..write(')'))
        .toString();
  }
}

class $TransactionItemTable extends TransactionItem
    with TableInfo<$TransactionItemTable, TransactionItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, transactionId, itemId, personId, quantity, amount, createdDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_item';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $TransactionItemTable createAlias(String alias) {
    return $TransactionItemTable(attachedDatabase, alias);
  }
}

class TransactionItemData extends DataClass
    implements Insertable<TransactionItemData> {
  final int id;
  final int transactionId;
  final int itemId;
  final int personId;
  final double quantity;
  final double amount;
  final DateTime createdDate;
  const TransactionItemData(
      {required this.id,
      required this.transactionId,
      required this.itemId,
      required this.personId,
      required this.quantity,
      required this.amount,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['item_id'] = Variable<int>(itemId);
    map['person_id'] = Variable<int>(personId);
    map['quantity'] = Variable<double>(quantity);
    map['amount'] = Variable<double>(amount);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  TransactionItemCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      itemId: Value(itemId),
      personId: Value(personId),
      quantity: Value(quantity),
      amount: Value(amount),
      createdDate: Value(createdDate),
    );
  }

  factory TransactionItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItemData(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      personId: serializer.fromJson<int>(json['personId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      amount: serializer.fromJson<double>(json['amount']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'itemId': serializer.toJson<int>(itemId),
      'personId': serializer.toJson<int>(personId),
      'quantity': serializer.toJson<double>(quantity),
      'amount': serializer.toJson<double>(amount),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  TransactionItemData copyWith(
          {int? id,
          int? transactionId,
          int? itemId,
          int? personId,
          double? quantity,
          double? amount,
          DateTime? createdDate}) =>
      TransactionItemData(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        itemId: itemId ?? this.itemId,
        personId: personId ?? this.personId,
        quantity: quantity ?? this.quantity,
        amount: amount ?? this.amount,
        createdDate: createdDate ?? this.createdDate,
      );
  TransactionItemData copyWithCompanion(TransactionItemCompanion data) {
    return TransactionItemData(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      personId: data.personId.present ? data.personId.value : this.personId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemData(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('quantity: $quantity, ')
          ..write('amount: $amount, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, transactionId, itemId, personId, quantity, amount, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionItemData &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.itemId == this.itemId &&
          other.personId == this.personId &&
          other.quantity == this.quantity &&
          other.amount == this.amount &&
          other.createdDate == this.createdDate);
}

class TransactionItemCompanion extends UpdateCompanion<TransactionItemData> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> itemId;
  final Value<int> personId;
  final Value<double> quantity;
  final Value<double> amount;
  final Value<DateTime> createdDate;
  const TransactionItemCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.personId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  TransactionItemCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int itemId,
    required int personId,
    required double quantity,
    required double amount,
    this.createdDate = const Value.absent(),
  })  : transactionId = Value(transactionId),
        itemId = Value(itemId),
        personId = Value(personId),
        quantity = Value(quantity),
        amount = Value(amount);
  static Insertable<TransactionItemData> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? itemId,
    Expression<int>? personId,
    Expression<double>? quantity,
    Expression<double>? amount,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (itemId != null) 'item_id': itemId,
      if (personId != null) 'person_id': personId,
      if (quantity != null) 'quantity': quantity,
      if (amount != null) 'amount': amount,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  TransactionItemCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<int>? itemId,
      Value<int>? personId,
      Value<double>? quantity,
      Value<double>? amount,
      Value<DateTime>? createdDate}) {
    return TransactionItemCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      itemId: itemId ?? this.itemId,
      personId: personId ?? this.personId,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('itemId: $itemId, ')
          ..write('personId: $personId, ')
          ..write('quantity: $quantity, ')
          ..write('amount: $amount, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $BudgetTable extends Budget with TableInfo<$BudgetTable, BudgetData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
      'budget', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, year, month, budget, createdDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    } else if (isInserting) {
      context.missing(_budgetMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}budget'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $BudgetTable createAlias(String alias) {
    return $BudgetTable(attachedDatabase, alias);
  }
}

class BudgetData extends DataClass implements Insertable<BudgetData> {
  final int id;
  final int categoryId;
  final int year;
  final int month;
  final double budget;
  final DateTime createdDate;
  const BudgetData(
      {required this.id,
      required this.categoryId,
      required this.year,
      required this.month,
      required this.budget,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['budget'] = Variable<double>(budget);
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  BudgetCompanion toCompanion(bool nullToAbsent) {
    return BudgetCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      year: Value(year),
      month: Value(month),
      budget: Value(budget),
      createdDate: Value(createdDate),
    );
  }

  factory BudgetData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetData(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      budget: serializer.fromJson<double>(json['budget']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'budget': serializer.toJson<double>(budget),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  BudgetData copyWith(
          {int? id,
          int? categoryId,
          int? year,
          int? month,
          double? budget,
          DateTime? createdDate}) =>
      BudgetData(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        year: year ?? this.year,
        month: month ?? this.month,
        budget: budget ?? this.budget,
        createdDate: createdDate ?? this.createdDate,
      );
  BudgetData copyWithCompanion(BudgetCompanion data) {
    return BudgetData(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      budget: data.budget.present ? data.budget.value : this.budget,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetData(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('budget: $budget, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, year, month, budget, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetData &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.year == this.year &&
          other.month == this.month &&
          other.budget == this.budget &&
          other.createdDate == this.createdDate);
}

class BudgetCompanion extends UpdateCompanion<BudgetData> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<int> year;
  final Value<int> month;
  final Value<double> budget;
  final Value<DateTime> createdDate;
  const BudgetCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.budget = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  BudgetCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required int year,
    required int month,
    required double budget,
    this.createdDate = const Value.absent(),
  })  : categoryId = Value(categoryId),
        year = Value(year),
        month = Value(month),
        budget = Value(budget);
  static Insertable<BudgetData> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<double>? budget,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (budget != null) 'budget': budget,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  BudgetCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<int>? year,
      Value<int>? month,
      Value<double>? budget,
      Value<DateTime>? createdDate}) {
    return BudgetCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      year: year ?? this.year,
      month: month ?? this.month,
      budget: budget ?? this.budget,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('budget: $budget, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

class $AccountTypeTable extends AccountType
    with TableInfo<$AccountTypeTable, AccountTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountTypeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nepaliNameMeta =
      const VerificationMeta('nepaliName');
  @override
  late final GeneratedColumn<String> nepaliName = GeneratedColumn<String>(
      'nepali_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nepaliName, iconName, createdDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_type';
  @override
  VerificationContext validateIntegrity(Insertable<AccountTypeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nepali_name')) {
      context.handle(
          _nepaliNameMeta,
          nepaliName.isAcceptableOrUnknown(
              data['nepali_name']!, _nepaliNameMeta));
    } else if (isInserting) {
      context.missing(_nepaliNameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountTypeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nepaliName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nepali_name'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
    );
  }

  @override
  $AccountTypeTable createAlias(String alias) {
    return $AccountTypeTable(attachedDatabase, alias);
  }
}

class AccountTypeData extends DataClass implements Insertable<AccountTypeData> {
  final int id;
  final String name;
  final String nepaliName;
  final String? iconName;
  final DateTime createdDate;
  const AccountTypeData(
      {required this.id,
      required this.name,
      required this.nepaliName,
      this.iconName,
      required this.createdDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['nepali_name'] = Variable<String>(nepaliName);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['created_date'] = Variable<DateTime>(createdDate);
    return map;
  }

  AccountTypeCompanion toCompanion(bool nullToAbsent) {
    return AccountTypeCompanion(
      id: Value(id),
      name: Value(name),
      nepaliName: Value(nepaliName),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      createdDate: Value(createdDate),
    );
  }

  factory AccountTypeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountTypeData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nepaliName: serializer.fromJson<String>(json['nepaliName']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nepaliName': serializer.toJson<String>(nepaliName),
      'iconName': serializer.toJson<String?>(iconName),
      'createdDate': serializer.toJson<DateTime>(createdDate),
    };
  }

  AccountTypeData copyWith(
          {int? id,
          String? name,
          String? nepaliName,
          Value<String?> iconName = const Value.absent(),
          DateTime? createdDate}) =>
      AccountTypeData(
        id: id ?? this.id,
        name: name ?? this.name,
        nepaliName: nepaliName ?? this.nepaliName,
        iconName: iconName.present ? iconName.value : this.iconName,
        createdDate: createdDate ?? this.createdDate,
      );
  AccountTypeData copyWithCompanion(AccountTypeCompanion data) {
    return AccountTypeData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nepaliName:
          data.nepaliName.present ? data.nepaliName.value : this.nepaliName,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      createdDate:
          data.createdDate.present ? data.createdDate.value : this.createdDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountTypeData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('iconName: $iconName, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nepaliName, iconName, createdDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountTypeData &&
          other.id == this.id &&
          other.name == this.name &&
          other.nepaliName == this.nepaliName &&
          other.iconName == this.iconName &&
          other.createdDate == this.createdDate);
}

class AccountTypeCompanion extends UpdateCompanion<AccountTypeData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nepaliName;
  final Value<String?> iconName;
  final Value<DateTime> createdDate;
  const AccountTypeCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nepaliName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.createdDate = const Value.absent(),
  });
  AccountTypeCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nepaliName,
    this.iconName = const Value.absent(),
    this.createdDate = const Value.absent(),
  })  : name = Value(name),
        nepaliName = Value(nepaliName);
  static Insertable<AccountTypeData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nepaliName,
    Expression<String>? iconName,
    Expression<DateTime>? createdDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nepaliName != null) 'nepali_name': nepaliName,
      if (iconName != null) 'icon_name': iconName,
      if (createdDate != null) 'created_date': createdDate,
    });
  }

  AccountTypeCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? nepaliName,
      Value<String?>? iconName,
      Value<DateTime>? createdDate}) {
    return AccountTypeCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      iconName: iconName ?? this.iconName,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nepaliName.present) {
      map['nepali_name'] = Variable<String>(nepaliName.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountTypeCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nepaliName: $nepaliName, ')
          ..write('iconName: $iconName, ')
          ..write('createdDate: $createdDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $AccountTable account = $AccountTable(this);
  late final $CategoryTable category = $CategoryTable(this);
  late final $CategoryHeadingTable categoryHeading =
      $CategoryHeadingTable(this);
  late final $PersonTable person = $PersonTable(this);
  late final $ItemTable item = $ItemTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemTable transactionItem =
      $TransactionItemTable(this);
  late final $BudgetTable budget = $BudgetTable(this);
  late final $AccountTypeTable accountType = $AccountTypeTable(this);
  late final AccountDao accountDao = AccountDao(this as MyDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as MyDatabase);
  late final CategoryHeadingDao categoryHeadingDao =
      CategoryHeadingDao(this as MyDatabase);
  late final PersonDao personDao = PersonDao(this as MyDatabase);
  late final ItemDao itemDao = ItemDao(this as MyDatabase);
  late final TransactionsDao transactionsDao =
      TransactionsDao(this as MyDatabase);
  late final TransactionItemDao transactionItemDao =
      TransactionItemDao(this as MyDatabase);
  late final BudgetDao budgetDao = BudgetDao(this as MyDatabase);
  late final AccountTypeDao accountTypeDao = AccountTypeDao(this as MyDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        account,
        category,
        categoryHeading,
        person,
        item,
        transactions,
        transactionItem,
        budget,
        accountType
      ];
}

typedef $$AccountTableCreateCompanionBuilder = AccountCompanion Function({
  Value<int> id,
  required String name,
  required String nepaliName,
  Value<double> balance,
  required int accountTypeId,
  Value<bool> isSystem,
  Value<DateTime?> openingBalanceDate,
  Value<DateTime> createdDate,
});
typedef $$AccountTableUpdateCompanionBuilder = AccountCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> nepaliName,
  Value<double> balance,
  Value<int> accountTypeId,
  Value<bool> isSystem,
  Value<DateTime?> openingBalanceDate,
  Value<DateTime> createdDate,
});

class $$AccountTableFilterComposer
    extends Composer<_$MyDatabase, $AccountTable> {
  $$AccountTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountTypeId => $composableBuilder(
      column: $table.accountTypeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openingBalanceDate => $composableBuilder(
      column: $table.openingBalanceDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));
}

class $$AccountTableOrderingComposer
    extends Composer<_$MyDatabase, $AccountTable> {
  $$AccountTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountTypeId => $composableBuilder(
      column: $table.accountTypeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openingBalanceDate => $composableBuilder(
      column: $table.openingBalanceDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$AccountTableAnnotationComposer
    extends Composer<_$MyDatabase, $AccountTable> {
  $$AccountTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<int> get accountTypeId => $composableBuilder(
      column: $table.accountTypeId, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<DateTime> get openingBalanceDate => $composableBuilder(
      column: $table.openingBalanceDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);
}

class $$AccountTableTableManager extends RootTableManager<
    _$MyDatabase,
    $AccountTable,
    AccountData,
    $$AccountTableFilterComposer,
    $$AccountTableOrderingComposer,
    $$AccountTableAnnotationComposer,
    $$AccountTableCreateCompanionBuilder,
    $$AccountTableUpdateCompanionBuilder,
    (AccountData, BaseReferences<_$MyDatabase, $AccountTable, AccountData>),
    AccountData,
    PrefetchHooks Function()> {
  $$AccountTableTableManager(_$MyDatabase db, $AccountTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nepaliName = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<int> accountTypeId = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<DateTime?> openingBalanceDate = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              AccountCompanion(
            id: id,
            name: name,
            nepaliName: nepaliName,
            balance: balance,
            accountTypeId: accountTypeId,
            isSystem: isSystem,
            openingBalanceDate: openingBalanceDate,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String nepaliName,
            Value<double> balance = const Value.absent(),
            required int accountTypeId,
            Value<bool> isSystem = const Value.absent(),
            Value<DateTime?> openingBalanceDate = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              AccountCompanion.insert(
            id: id,
            name: name,
            nepaliName: nepaliName,
            balance: balance,
            accountTypeId: accountTypeId,
            isSystem: isSystem,
            openingBalanceDate: openingBalanceDate,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $AccountTable,
    AccountData,
    $$AccountTableFilterComposer,
    $$AccountTableOrderingComposer,
    $$AccountTableAnnotationComposer,
    $$AccountTableCreateCompanionBuilder,
    $$AccountTableUpdateCompanionBuilder,
    (AccountData, BaseReferences<_$MyDatabase, $AccountTable, AccountData>),
    AccountData,
    PrefetchHooks Function()>;
typedef $$CategoryTableCreateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  required String name,
  required String nepaliName,
  Value<String?> iconName,
  required int categoryHeadingId,
  required int orderId,
  Value<bool> isSystem,
  Value<DateTime> createdDate,
});
typedef $$CategoryTableUpdateCompanionBuilder = CategoryCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> nepaliName,
  Value<String?> iconName,
  Value<int> categoryHeadingId,
  Value<int> orderId,
  Value<bool> isSystem,
  Value<DateTime> createdDate,
});

class $$CategoryTableFilterComposer
    extends Composer<_$MyDatabase, $CategoryTable> {
  $$CategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryHeadingId => $composableBuilder(
      column: $table.categoryHeadingId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));
}

class $$CategoryTableOrderingComposer
    extends Composer<_$MyDatabase, $CategoryTable> {
  $$CategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryHeadingId => $composableBuilder(
      column: $table.categoryHeadingId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$CategoryTableAnnotationComposer
    extends Composer<_$MyDatabase, $CategoryTable> {
  $$CategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get categoryHeadingId => $composableBuilder(
      column: $table.categoryHeadingId, builder: (column) => column);

  GeneratedColumn<int> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);
}

class $$CategoryTableTableManager extends RootTableManager<
    _$MyDatabase,
    $CategoryTable,
    CategoryData,
    $$CategoryTableFilterComposer,
    $$CategoryTableOrderingComposer,
    $$CategoryTableAnnotationComposer,
    $$CategoryTableCreateCompanionBuilder,
    $$CategoryTableUpdateCompanionBuilder,
    (CategoryData, BaseReferences<_$MyDatabase, $CategoryTable, CategoryData>),
    CategoryData,
    PrefetchHooks Function()> {
  $$CategoryTableTableManager(_$MyDatabase db, $CategoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nepaliName = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int> categoryHeadingId = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              CategoryCompanion(
            id: id,
            name: name,
            nepaliName: nepaliName,
            iconName: iconName,
            categoryHeadingId: categoryHeadingId,
            orderId: orderId,
            isSystem: isSystem,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String nepaliName,
            Value<String?> iconName = const Value.absent(),
            required int categoryHeadingId,
            required int orderId,
            Value<bool> isSystem = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              CategoryCompanion.insert(
            id: id,
            name: name,
            nepaliName: nepaliName,
            iconName: iconName,
            categoryHeadingId: categoryHeadingId,
            orderId: orderId,
            isSystem: isSystem,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoryTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $CategoryTable,
    CategoryData,
    $$CategoryTableFilterComposer,
    $$CategoryTableOrderingComposer,
    $$CategoryTableAnnotationComposer,
    $$CategoryTableCreateCompanionBuilder,
    $$CategoryTableUpdateCompanionBuilder,
    (CategoryData, BaseReferences<_$MyDatabase, $CategoryTable, CategoryData>),
    CategoryData,
    PrefetchHooks Function()>;
typedef $$CategoryHeadingTableCreateCompanionBuilder = CategoryHeadingCompanion
    Function({
  Value<int> id,
  required String name,
  required String nepaliName,
  Value<String?> iconName,
  required bool isIncome,
  Value<bool> isSystem,
  Value<DateTime> createdDate,
});
typedef $$CategoryHeadingTableUpdateCompanionBuilder = CategoryHeadingCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> nepaliName,
  Value<String?> iconName,
  Value<bool> isIncome,
  Value<bool> isSystem,
  Value<DateTime> createdDate,
});

class $$CategoryHeadingTableFilterComposer
    extends Composer<_$MyDatabase, $CategoryHeadingTable> {
  $$CategoryHeadingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));
}

class $$CategoryHeadingTableOrderingComposer
    extends Composer<_$MyDatabase, $CategoryHeadingTable> {
  $$CategoryHeadingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$CategoryHeadingTableAnnotationComposer
    extends Composer<_$MyDatabase, $CategoryHeadingTable> {
  $$CategoryHeadingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);
}

class $$CategoryHeadingTableTableManager extends RootTableManager<
    _$MyDatabase,
    $CategoryHeadingTable,
    CategoryHeadingData,
    $$CategoryHeadingTableFilterComposer,
    $$CategoryHeadingTableOrderingComposer,
    $$CategoryHeadingTableAnnotationComposer,
    $$CategoryHeadingTableCreateCompanionBuilder,
    $$CategoryHeadingTableUpdateCompanionBuilder,
    (
      CategoryHeadingData,
      BaseReferences<_$MyDatabase, $CategoryHeadingTable, CategoryHeadingData>
    ),
    CategoryHeadingData,
    PrefetchHooks Function()> {
  $$CategoryHeadingTableTableManager(
      _$MyDatabase db, $CategoryHeadingTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryHeadingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryHeadingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryHeadingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nepaliName = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<bool> isIncome = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              CategoryHeadingCompanion(
            id: id,
            name: name,
            nepaliName: nepaliName,
            iconName: iconName,
            isIncome: isIncome,
            isSystem: isSystem,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String nepaliName,
            Value<String?> iconName = const Value.absent(),
            required bool isIncome,
            Value<bool> isSystem = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              CategoryHeadingCompanion.insert(
            id: id,
            name: name,
            nepaliName: nepaliName,
            iconName: iconName,
            isIncome: isIncome,
            isSystem: isSystem,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoryHeadingTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $CategoryHeadingTable,
    CategoryHeadingData,
    $$CategoryHeadingTableFilterComposer,
    $$CategoryHeadingTableOrderingComposer,
    $$CategoryHeadingTableAnnotationComposer,
    $$CategoryHeadingTableCreateCompanionBuilder,
    $$CategoryHeadingTableUpdateCompanionBuilder,
    (
      CategoryHeadingData,
      BaseReferences<_$MyDatabase, $CategoryHeadingTable, CategoryHeadingData>
    ),
    CategoryHeadingData,
    PrefetchHooks Function()>;
typedef $$PersonTableCreateCompanionBuilder = PersonCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$PersonTableUpdateCompanionBuilder = PersonCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$PersonTableFilterComposer extends Composer<_$MyDatabase, $PersonTable> {
  $$PersonTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$PersonTableOrderingComposer
    extends Composer<_$MyDatabase, $PersonTable> {
  $$PersonTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$PersonTableAnnotationComposer
    extends Composer<_$MyDatabase, $PersonTable> {
  $$PersonTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$PersonTableTableManager extends RootTableManager<
    _$MyDatabase,
    $PersonTable,
    PersonData,
    $$PersonTableFilterComposer,
    $$PersonTableOrderingComposer,
    $$PersonTableAnnotationComposer,
    $$PersonTableCreateCompanionBuilder,
    $$PersonTableUpdateCompanionBuilder,
    (PersonData, BaseReferences<_$MyDatabase, $PersonTable, PersonData>),
    PersonData,
    PrefetchHooks Function()> {
  $$PersonTableTableManager(_$MyDatabase db, $PersonTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              PersonCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              PersonCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $PersonTable,
    PersonData,
    $$PersonTableFilterComposer,
    $$PersonTableOrderingComposer,
    $$PersonTableAnnotationComposer,
    $$PersonTableCreateCompanionBuilder,
    $$PersonTableUpdateCompanionBuilder,
    (PersonData, BaseReferences<_$MyDatabase, $PersonTable, PersonData>),
    PersonData,
    PrefetchHooks Function()>;
typedef $$ItemTableCreateCompanionBuilder = ItemCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$ItemTableUpdateCompanionBuilder = ItemCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$ItemTableFilterComposer extends Composer<_$MyDatabase, $ItemTable> {
  $$ItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$ItemTableOrderingComposer extends Composer<_$MyDatabase, $ItemTable> {
  $$ItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$ItemTableAnnotationComposer extends Composer<_$MyDatabase, $ItemTable> {
  $$ItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$ItemTableTableManager extends RootTableManager<
    _$MyDatabase,
    $ItemTable,
    ItemData,
    $$ItemTableFilterComposer,
    $$ItemTableOrderingComposer,
    $$ItemTableAnnotationComposer,
    $$ItemTableCreateCompanionBuilder,
    $$ItemTableUpdateCompanionBuilder,
    (ItemData, BaseReferences<_$MyDatabase, $ItemTable, ItemData>),
    ItemData,
    PrefetchHooks Function()> {
  $$ItemTableTableManager(_$MyDatabase db, $ItemTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              ItemCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              ItemCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ItemTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $ItemTable,
    ItemData,
    $$ItemTableFilterComposer,
    $$ItemTableOrderingComposer,
    $$ItemTableAnnotationComposer,
    $$ItemTableCreateCompanionBuilder,
    $$ItemTableUpdateCompanionBuilder,
    (ItemData, BaseReferences<_$MyDatabase, $ItemTable, ItemData>),
    ItemData,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required int categoryId,
  Value<String?> description,
  Value<String?> image,
  required double amount,
  required int accountId,
  Value<bool> isDailySales,
  Value<String?> billNumber,
  required DateTime transactionDate,
  Value<DateTime> createdDate,
  Value<DateTime?> modifiedDate,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String?> description,
  Value<String?> image,
  Value<double> amount,
  Value<int> accountId,
  Value<bool> isDailySales,
  Value<String?> billNumber,
  Value<DateTime> transactionDate,
  Value<DateTime> createdDate,
  Value<DateTime?> modifiedDate,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$MyDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDailySales => $composableBuilder(
      column: $table.isDailySales, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedDate => $composableBuilder(
      column: $table.modifiedDate, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$MyDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDailySales => $composableBuilder(
      column: $table.isDailySales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedDate => $composableBuilder(
      column: $table.modifiedDate,
      builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$MyDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get isDailySales => $composableBuilder(
      column: $table.isDailySales, builder: (column) => column);

  GeneratedColumn<String> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedDate => $composableBuilder(
      column: $table.modifiedDate, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$MyDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$MyDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$MyDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> accountId = const Value.absent(),
            Value<bool> isDailySales = const Value.absent(),
            Value<String?> billNumber = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
            Value<DateTime?> modifiedDate = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            categoryId: categoryId,
            description: description,
            image: image,
            amount: amount,
            accountId: accountId,
            isDailySales: isDailySales,
            billNumber: billNumber,
            transactionDate: transactionDate,
            createdDate: createdDate,
            modifiedDate: modifiedDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            Value<String?> description = const Value.absent(),
            Value<String?> image = const Value.absent(),
            required double amount,
            required int accountId,
            Value<bool> isDailySales = const Value.absent(),
            Value<String?> billNumber = const Value.absent(),
            required DateTime transactionDate,
            Value<DateTime> createdDate = const Value.absent(),
            Value<DateTime?> modifiedDate = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            categoryId: categoryId,
            description: description,
            image: image,
            amount: amount,
            accountId: accountId,
            isDailySales: isDailySales,
            billNumber: billNumber,
            transactionDate: transactionDate,
            createdDate: createdDate,
            modifiedDate: modifiedDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$MyDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$TransactionItemTableCreateCompanionBuilder = TransactionItemCompanion
    Function({
  Value<int> id,
  required int transactionId,
  required int itemId,
  required int personId,
  required double quantity,
  required double amount,
  Value<DateTime> createdDate,
});
typedef $$TransactionItemTableUpdateCompanionBuilder = TransactionItemCompanion
    Function({
  Value<int> id,
  Value<int> transactionId,
  Value<int> itemId,
  Value<int> personId,
  Value<double> quantity,
  Value<double> amount,
  Value<DateTime> createdDate,
});

class $$TransactionItemTableFilterComposer
    extends Composer<_$MyDatabase, $TransactionItemTable> {
  $$TransactionItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));
}

class $$TransactionItemTableOrderingComposer
    extends Composer<_$MyDatabase, $TransactionItemTable> {
  $$TransactionItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transactionId => $composableBuilder(
      column: $table.transactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$TransactionItemTableAnnotationComposer
    extends Composer<_$MyDatabase, $TransactionItemTable> {
  $$TransactionItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get transactionId => $composableBuilder(
      column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);
}

class $$TransactionItemTableTableManager extends RootTableManager<
    _$MyDatabase,
    $TransactionItemTable,
    TransactionItemData,
    $$TransactionItemTableFilterComposer,
    $$TransactionItemTableOrderingComposer,
    $$TransactionItemTableAnnotationComposer,
    $$TransactionItemTableCreateCompanionBuilder,
    $$TransactionItemTableUpdateCompanionBuilder,
    (
      TransactionItemData,
      BaseReferences<_$MyDatabase, $TransactionItemTable, TransactionItemData>
    ),
    TransactionItemData,
    PrefetchHooks Function()> {
  $$TransactionItemTableTableManager(
      _$MyDatabase db, $TransactionItemTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> transactionId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              TransactionItemCompanion(
            id: id,
            transactionId: transactionId,
            itemId: itemId,
            personId: personId,
            quantity: quantity,
            amount: amount,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int transactionId,
            required int itemId,
            required int personId,
            required double quantity,
            required double amount,
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              TransactionItemCompanion.insert(
            id: id,
            transactionId: transactionId,
            itemId: itemId,
            personId: personId,
            quantity: quantity,
            amount: amount,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionItemTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $TransactionItemTable,
    TransactionItemData,
    $$TransactionItemTableFilterComposer,
    $$TransactionItemTableOrderingComposer,
    $$TransactionItemTableAnnotationComposer,
    $$TransactionItemTableCreateCompanionBuilder,
    $$TransactionItemTableUpdateCompanionBuilder,
    (
      TransactionItemData,
      BaseReferences<_$MyDatabase, $TransactionItemTable, TransactionItemData>
    ),
    TransactionItemData,
    PrefetchHooks Function()>;
typedef $$BudgetTableCreateCompanionBuilder = BudgetCompanion Function({
  Value<int> id,
  required int categoryId,
  required int year,
  required int month,
  required double budget,
  Value<DateTime> createdDate,
});
typedef $$BudgetTableUpdateCompanionBuilder = BudgetCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<int> year,
  Value<int> month,
  Value<double> budget,
  Value<DateTime> createdDate,
});

class $$BudgetTableFilterComposer extends Composer<_$MyDatabase, $BudgetTable> {
  $$BudgetTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));
}

class $$BudgetTableOrderingComposer
    extends Composer<_$MyDatabase, $BudgetTable> {
  $$BudgetTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$BudgetTableAnnotationComposer
    extends Composer<_$MyDatabase, $BudgetTable> {
  $$BudgetTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);
}

class $$BudgetTableTableManager extends RootTableManager<
    _$MyDatabase,
    $BudgetTable,
    BudgetData,
    $$BudgetTableFilterComposer,
    $$BudgetTableOrderingComposer,
    $$BudgetTableAnnotationComposer,
    $$BudgetTableCreateCompanionBuilder,
    $$BudgetTableUpdateCompanionBuilder,
    (BudgetData, BaseReferences<_$MyDatabase, $BudgetTable, BudgetData>),
    BudgetData,
    PrefetchHooks Function()> {
  $$BudgetTableTableManager(_$MyDatabase db, $BudgetTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<double> budget = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              BudgetCompanion(
            id: id,
            categoryId: categoryId,
            year: year,
            month: month,
            budget: budget,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required int year,
            required int month,
            required double budget,
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              BudgetCompanion.insert(
            id: id,
            categoryId: categoryId,
            year: year,
            month: month,
            budget: budget,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $BudgetTable,
    BudgetData,
    $$BudgetTableFilterComposer,
    $$BudgetTableOrderingComposer,
    $$BudgetTableAnnotationComposer,
    $$BudgetTableCreateCompanionBuilder,
    $$BudgetTableUpdateCompanionBuilder,
    (BudgetData, BaseReferences<_$MyDatabase, $BudgetTable, BudgetData>),
    BudgetData,
    PrefetchHooks Function()>;
typedef $$AccountTypeTableCreateCompanionBuilder = AccountTypeCompanion
    Function({
  Value<int> id,
  required String name,
  required String nepaliName,
  Value<String?> iconName,
  Value<DateTime> createdDate,
});
typedef $$AccountTypeTableUpdateCompanionBuilder = AccountTypeCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> nepaliName,
  Value<String?> iconName,
  Value<DateTime> createdDate,
});

class $$AccountTypeTableFilterComposer
    extends Composer<_$MyDatabase, $AccountTypeTable> {
  $$AccountTypeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnFilters(column));
}

class $$AccountTypeTableOrderingComposer
    extends Composer<_$MyDatabase, $AccountTypeTable> {
  $$AccountTypeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => ColumnOrderings(column));
}

class $$AccountTypeTableAnnotationComposer
    extends Composer<_$MyDatabase, $AccountTypeTable> {
  $$AccountTypeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nepaliName => $composableBuilder(
      column: $table.nepaliName, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate => $composableBuilder(
      column: $table.createdDate, builder: (column) => column);
}

class $$AccountTypeTableTableManager extends RootTableManager<
    _$MyDatabase,
    $AccountTypeTable,
    AccountTypeData,
    $$AccountTypeTableFilterComposer,
    $$AccountTypeTableOrderingComposer,
    $$AccountTypeTableAnnotationComposer,
    $$AccountTypeTableCreateCompanionBuilder,
    $$AccountTypeTableUpdateCompanionBuilder,
    (
      AccountTypeData,
      BaseReferences<_$MyDatabase, $AccountTypeTable, AccountTypeData>
    ),
    AccountTypeData,
    PrefetchHooks Function()> {
  $$AccountTypeTableTableManager(_$MyDatabase db, $AccountTypeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountTypeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountTypeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountTypeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nepaliName = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              AccountTypeCompanion(
            id: id,
            name: name,
            nepaliName: nepaliName,
            iconName: iconName,
            createdDate: createdDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String nepaliName,
            Value<String?> iconName = const Value.absent(),
            Value<DateTime> createdDate = const Value.absent(),
          }) =>
              AccountTypeCompanion.insert(
            id: id,
            name: name,
            nepaliName: nepaliName,
            iconName: iconName,
            createdDate: createdDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountTypeTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $AccountTypeTable,
    AccountTypeData,
    $$AccountTypeTableFilterComposer,
    $$AccountTypeTableOrderingComposer,
    $$AccountTypeTableAnnotationComposer,
    $$AccountTypeTableCreateCompanionBuilder,
    $$AccountTypeTableUpdateCompanionBuilder,
    (
      AccountTypeData,
      BaseReferences<_$MyDatabase, $AccountTypeTable, AccountTypeData>
    ),
    AccountTypeData,
    PrefetchHooks Function()>;

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$AccountTableTableManager get account =>
      $$AccountTableTableManager(_db, _db.account);
  $$CategoryTableTableManager get category =>
      $$CategoryTableTableManager(_db, _db.category);
  $$CategoryHeadingTableTableManager get categoryHeading =>
      $$CategoryHeadingTableTableManager(_db, _db.categoryHeading);
  $$PersonTableTableManager get person =>
      $$PersonTableTableManager(_db, _db.person);
  $$ItemTableTableManager get item => $$ItemTableTableManager(_db, _db.item);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionItemTableTableManager get transactionItem =>
      $$TransactionItemTableTableManager(_db, _db.transactionItem);
  $$BudgetTableTableManager get budget =>
      $$BudgetTableTableManager(_db, _db.budget);
  $$AccountTypeTableTableManager get accountType =>
      $$AccountTypeTableTableManager(_db, _db.accountType);
}
