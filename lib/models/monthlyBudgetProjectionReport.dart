import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:nepali_utils/nepali_utils.dart';

class MonthlyBudgetProjectionReport {
  final CategoryData categoryData;
  final double budget;
  final bool isIncome;
  final NepaliDateTime? reportDate;
  final String categoryHeadingName;
  MonthlyBudgetProjectionReport({
    required this.categoryData,
    required this.budget,
    required this.isIncome,
    required this.reportDate,
    required this.categoryHeadingName,
  });

  factory MonthlyBudgetProjectionReport.fromDatabase(Map<String, dynamic> map) {
    return MonthlyBudgetProjectionReport(
        categoryData: CategoryData(
          id: map['id'],
          name: map['name'],
          nepaliName: map['nepali_name'],
          categoryHeadingId: map['category_heading_id'],
          orderId: map['order_id'],
          isSystem: map['is_system'] == 1,
          createdDate: DateTime.now(),
        ),
        reportDate: map['year'] == null ? null : NepaliDateTime(map['year'], map['month']),
        budget: map['budget'] ?? 0.0,
        isIncome: map['is_income'] == 1,
        categoryHeadingName: map['category_heading_name']);
  }

  MonthlyBudgetProjectionReport copyWith({
    CategoryData? categoryData,
    double? budget,
    bool? isIncome,
    NepaliDateTime? reportDate,
    String? categoryHeadingName,
  }) {
    return MonthlyBudgetProjectionReport(
      categoryData: categoryData ?? this.categoryData,
      budget: budget ?? this.budget,
      isIncome: isIncome ?? this.isIncome,
      reportDate: reportDate ?? this.reportDate,
      categoryHeadingName: categoryHeadingName ?? this.categoryHeadingName,
    );
  }
}
