import 'dart:convert';

import 'package:byaparlekha/database/myDatabase/database.dart';

class MonthlyProjectionModel {
  final String categoryHeadingName;
  final CategoryData categoryData;
  final double budgetAmount;
  final double actualAmount;
  final bool isIncome;
  MonthlyProjectionModel({
    required this.categoryHeadingName,
    required this.categoryData,
    required this.budgetAmount,
    required this.actualAmount,
    required this.isIncome,
  });

  MonthlyProjectionModel copyWith({
    String? categoryHeadingName,
    CategoryData? categoryData,
    double? budgetAmount,
    double? actualAmount,
    bool? isIncome,
  }) {
    return MonthlyProjectionModel(
      categoryHeadingName: categoryHeadingName ?? this.categoryHeadingName,
      categoryData: categoryData ?? this.categoryData,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      actualAmount: actualAmount ?? this.actualAmount,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryHeadingName': categoryHeadingName,
      'categoryData': categoryData.toJson(),
      'budgetAmount': budgetAmount,
      'actualAmount': actualAmount,
      'isIncome': isIncome,
    };
  }

  factory MonthlyProjectionModel.fromMap(Map<String, dynamic> map) {
    return MonthlyProjectionModel(
      categoryHeadingName: map['categoryHeadingName'] ?? '',
      categoryData: CategoryData.fromJson(map['categoryData']),
      budgetAmount: map['budgetAmount']?.toDouble() ?? 0.0,
      actualAmount: map['actualAmount']?.toDouble() ?? 0.0,
      isIncome: map['isIncome'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyProjectionModel.fromJson(String source) => MonthlyProjectionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MonthlyProjectionModel(categoryHeadingName: $categoryHeadingName, categoryData: $categoryData, budgetAmount: $budgetAmount, actualAmount: $actualAmount, isIncome: $isIncome)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthlyProjectionModel &&
        other.categoryHeadingName == categoryHeadingName &&
        other.categoryData == categoryData &&
        other.budgetAmount == budgetAmount &&
        other.actualAmount == actualAmount &&
        other.isIncome == isIncome;
  }

  @override
  int get hashCode {
    return categoryHeadingName.hashCode ^ categoryData.hashCode ^ budgetAmount.hashCode ^ actualAmount.hashCode ^ isIncome.hashCode;
  }
}
