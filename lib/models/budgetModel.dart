class BudgetModel {
  final int? id;
  final double? budget;
  final double? amount;
  final String categoryName;
  final String categoryNepaliName;
  final String? categoryIcon;
  final String categoryHeadingName;
  final int categoryHeadingId;
  final int categoryId;
  final String? categoryHeadingNepaliName;
  BudgetModel({
    this.id,
    required this.budget,
    required this.amount,
    required this.categoryName,
    required this.categoryNepaliName,
    this.categoryIcon,
    required this.categoryHeadingName,
    required this.categoryHeadingId,
    required this.categoryId,
    this.categoryHeadingNepaliName,
  });

  factory BudgetModel.fromDatabase(Map<String, dynamic> map) {
    return BudgetModel(
        id: map['budget_id']?.toInt(),
        budget: map['budget']?.toDouble(),
        amount: map['amount']?.toDouble(),
        categoryName: map['category_name'] ?? '',
        categoryNepaliName: map['category_nepali_name'] ?? '',
        categoryIcon: map['category_icon'],
        categoryId: map['category_id']?.toInt() ?? 0,
        categoryHeadingName: map['category_heading_name'] ?? '',
        categoryHeadingId: map['category_heading_id']?.toInt() ?? 0,
        categoryHeadingNepaliName: map['category_heading_nepali_name']);
  }

  @override
  String toString() {
    return 'BudgetModel(id: $id, budget: $budget, amount: $amount, categoryName: $categoryName, categoryNepaliName: $categoryNepaliName, categoryIcon: $categoryIcon, categoryHeadingName: $categoryHeadingName, categoryHeadingId: $categoryHeadingId, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BudgetModel &&
        other.id == id &&
        other.budget == budget &&
        other.amount == amount &&
        other.categoryName == categoryName &&
        other.categoryNepaliName == categoryNepaliName &&
        other.categoryIcon == categoryIcon &&
        other.categoryHeadingName == categoryHeadingName &&
        other.categoryHeadingId == categoryHeadingId &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        budget.hashCode ^
        amount.hashCode ^
        categoryName.hashCode ^
        categoryNepaliName.hashCode ^
        categoryIcon.hashCode ^
        categoryHeadingName.hashCode ^
        categoryHeadingId.hashCode ^
        categoryId.hashCode;
  }
}
