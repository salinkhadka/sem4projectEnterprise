import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ValueModel {
  final int id;
  final String name;
  final String? nepaliName;
  final Widget? iconData;
  ValueModel({
    required this.id,
    required this.name,
    this.nepaliName,
    this.iconData,
  });

  ValueModel copyWith({
    int? id,
    String? name,
    String? nepaliName,
    Widget? iconData,
  }) {
    return ValueModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nepaliName: nepaliName ?? this.nepaliName,
      iconData: iconData ?? this.iconData,
    );
  }

  @override
  String toString() {
    return 'ValueModel(id: $id, name: $name, nepaliName: $nepaliName, iconData: $iconData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueModel &&
        other.id == id &&
        other.name == name &&
        other.nepaliName == nepaliName &&
        other.iconData == iconData;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        nepaliName.hashCode ^
        iconData.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nepaliName': nepaliName,
      'iconData': iconData,
    };
  }

  factory ValueModel.fromMap(Map<String, dynamic> map) {
    return ValueModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      nepaliName: map['nepaliName'] ?? map['name'],
      iconData: map['iconData'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ValueModel.fromJson(String source) =>
      ValueModel.fromMap(json.decode(source));
}
