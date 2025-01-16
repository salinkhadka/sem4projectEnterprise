import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:nepali_utils/nepali_utils.dart';

class CategoryBudgetByDateTime {
  final CategoryData categoryData;
  final double budget;
  final bool isIncome;
  final String categoryHeadingName;
  CategoryBudgetByDateTime({
    required this.categoryData,
    required this.budget,
    required this.isIncome,
    required this.categoryHeadingName,
  });
}

class MonthlyBudgetReportByDateTime {
  final NepaliDateTime projectedDateTime;
  final List<CategoryBudgetByDateTime> categoryBudgetData;
  MonthlyBudgetReportByDateTime({
    required this.projectedDateTime,
    required this.categoryBudgetData,
  });
}
