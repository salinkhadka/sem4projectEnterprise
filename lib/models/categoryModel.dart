import 'dart:convert';

class CategoryModel {
  final int orderId;
  final int id;
  final String? iconName;
  final String name;
  final String nepaliName;
  final int categoryHeadingId;
  final String categoryHeadingName;
  final bool isSystem;
  final DateTime createdDate;
  CategoryModel({
    required this.orderId,
    required this.id,
    this.iconName,
    required this.name,
    required this.nepaliName,
    required this.categoryHeadingId,
    required this.categoryHeadingName,
    required this.isSystem,
    required this.createdDate,
  });

  CategoryModel copyWith({
    int? orderId,
    int? id,
    String? iconName,
    String? name,
    String? nepaliName,
    int? categoryHeadingId,
    String? categoryHeadingName,
    bool? isSystem,
    DateTime? createdDate,
  }) {
    return CategoryModel(
      orderId: orderId ?? this.orderId,
      id: id ?? this.id,
      iconName: iconName ?? this.iconName,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      categoryHeadingId: categoryHeadingId ?? this.categoryHeadingId,
      categoryHeadingName: categoryHeadingName ?? this.categoryHeadingName,
      isSystem: isSystem ?? this.isSystem,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'orderId': orderId});
    result.addAll({'id': id});
    if (iconName != null) {
      result.addAll({'iconName': iconName});
    }
    result.addAll({'name': name});
    result.addAll({'nepaliName': nepaliName});
    result.addAll({'categoryHeadingId': categoryHeadingId});
    result.addAll({'categoryHeadingName': categoryHeadingName});
    result.addAll({'isSystem': isSystem});
    result.addAll({'createdDate': createdDate.millisecondsSinceEpoch});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      orderId: map['orderId']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
      iconName: map['iconName'],
      name: map['name'] ?? '',
      nepaliName: map['nepaliName'] ?? '',
      categoryHeadingId: map['categoryHeadingId']?.toInt() ?? 0,
      categoryHeadingName: map['categoryHeadingName'] ?? '',
      isSystem: map['isSystem'] == 1,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate']),
    );
  }

  factory CategoryModel.fromDatabase(Map<String, dynamic> map) {
    return CategoryModel(
      orderId: map['order_id']?.toInt() ?? 0,
      id: map['id']?.toInt() ?? 0,
      iconName: map['categoryHeadingIconName'],
      name: map['name'] ?? '',
      nepaliName: map['nepali_name'] ?? '',
      categoryHeadingId: map['category_heading_id'] ?? 0,
      categoryHeadingName: map['category_heading_name'] ?? '',
      isSystem: map['is_system'] == 1,
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['created_date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(orderId: $orderId, id: $id, iconName: $iconName, name: $name, nepaliName: $nepaliName, categoryHeadingId: $categoryHeadingId, categoryHeadingName: $categoryHeadingName, isSystem: $isSystem, createdDate: $createdDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.orderId == orderId &&
        other.id == id &&
        other.iconName == iconName &&
        other.name == name &&
        other.nepaliName == nepaliName &&
        other.categoryHeadingId == categoryHeadingId &&
        other.categoryHeadingName == categoryHeadingName &&
        other.isSystem == isSystem &&
        other.createdDate == createdDate;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        id.hashCode ^
        iconName.hashCode ^
        name.hashCode ^
        nepaliName.hashCode ^
        categoryHeadingId.hashCode ^
        categoryHeadingName.hashCode ^
        isSystem.hashCode ^
        createdDate.hashCode;
  }
}
