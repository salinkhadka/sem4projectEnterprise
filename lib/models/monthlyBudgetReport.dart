import 'package:nepali_date_picker/nepali_date_picker.dart';

class MonthyBudgetReport {
  final double inflowBudget;
  final double outflowBudget;

  final DateTime reportDate;
  MonthyBudgetReport({
    required this.inflowBudget,
    required this.outflowBudget,
    required this.reportDate,
  });

  MonthyBudgetReport copyWith({
    double? inflowBudget,
    double? outflowBudget,
    DateTime? reportDate,
  }) {
    return MonthyBudgetReport(
      inflowBudget: inflowBudget ?? this.inflowBudget,
      outflowBudget: outflowBudget ?? this.outflowBudget,
      reportDate: reportDate ?? this.reportDate,
    );
  }

  factory MonthyBudgetReport.fromDatabase(Map<String, dynamic> map) {
    return MonthyBudgetReport(
      inflowBudget: map['inflowBudget']?.toDouble() ?? 0.0,
      outflowBudget: map['outflowBudget']?.toDouble() ?? 0.0,
      reportDate: NepaliDateTime(map['year'], map['month']).toDateTime(),
    );
  }

  @override
  String toString() => 'MonthyBudgetReport(inflowBudget: $inflowBudget, outflowBudget: $outflowBudget, reportDate: $reportDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthyBudgetReport && other.inflowBudget == inflowBudget && other.outflowBudget == outflowBudget && other.reportDate == reportDate;
  }

  @override
  int get hashCode => inflowBudget.hashCode ^ outflowBudget.hashCode ^ reportDate.hashCode;
}
