import 'package:byaparlekha/database/myDatabase/database.dart';

class MonthlyCategoryReport {
  final CategoryData categoryData;
  final double inflowAmount;
  final double outflowAmount;
  final bool isIncome;
  final DateTime reportDate;
  final String categoryHeadingName;
  MonthlyCategoryReport({
    required this.categoryData,
    required this.inflowAmount,
    required this.outflowAmount,
    required this.isIncome,
    required this.reportDate,
    required this.categoryHeadingName,
  });

  MonthlyCategoryReport copyWith({
    CategoryData? categoryData,
    double? inflowAmount,
    double? outflowAmount,
    bool? isIncome,
    DateTime? reportDate,
    String? categoryHeadingName,
  }) {
    return MonthlyCategoryReport(
      categoryData: categoryData ?? this.categoryData,
      inflowAmount: inflowAmount ?? this.inflowAmount,
      outflowAmount: outflowAmount ?? this.outflowAmount,
      isIncome: isIncome ?? this.isIncome,
      reportDate: reportDate ?? this.reportDate,
      categoryHeadingName: categoryHeadingName ?? this.categoryHeadingName,
    );
  }

  factory MonthlyCategoryReport.fromDatabase(Map<String, dynamic> map) {
    return MonthlyCategoryReport(
        categoryData: CategoryData(
          id: map['id'],
          name: map['name'],
          nepaliName: map['nepali_name'],
          categoryHeadingId: map['category_heading_id'],
          orderId: map['order_id'],
          isSystem: map['is_system'] == 1,
          createdDate: DateTime.now(),
        ),
        reportDate: DateTime.fromMillisecondsSinceEpoch(map['transaction_date'] * 1000),
        inflowAmount: map['inflowAmount']?.toDouble() ?? 0.0,
        outflowAmount: map['outflowAmount']?.toDouble() ?? 0.0,
        isIncome: map['is_income'] == 1,
        categoryHeadingName: map['category_heading_name']);
  }

  @override
  String toString() {
    return 'MonthlyCategoryReport(categoryData: $categoryData, inflowAmount: $inflowAmount, outflowAmount: $outflowAmount, isIncome: $isIncome, reportDate: $reportDate, categoryHeadingName: $categoryHeadingName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthlyCategoryReport &&
        other.categoryData == categoryData &&
        other.inflowAmount == inflowAmount &&
        other.outflowAmount == outflowAmount &&
        other.isIncome == isIncome &&
        other.reportDate == reportDate &&
        other.categoryHeadingName == categoryHeadingName;
  }

  @override
  int get hashCode {
    return categoryData.hashCode ^ inflowAmount.hashCode ^ outflowAmount.hashCode ^ isIncome.hashCode ^ reportDate.hashCode ^ categoryHeadingName.hashCode;
  }
}
