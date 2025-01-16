import 'dart:convert';

import 'package:nepali_date_picker/nepali_date_picker.dart';

class ExportDataModel {
  final NepaliDateTime date;
  final double outflow;
  final double inflow;
  final double inflowMINUSoutflow;
  final double cf;
  ExportDataModel({
    required this.date,
    required this.outflow,
    required this.inflow,
    required this.inflowMINUSoutflow,
    required this.cf,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'outflow': outflow,
      'inflow': inflow,
      'inflowMINUSoutflow': inflowMINUSoutflow,
      'cf': cf,
    };
  }

  ExportDataModel copyWith({
    NepaliDateTime? date,
    double? outflow,
    double? inflow,
    double? inflowMINUSoutflow,
    double? cf,
  }) {
    return ExportDataModel(
      date: date ?? this.date,
      outflow: outflow ?? this.outflow,
      inflow: inflow ?? this.inflow,
      inflowMINUSoutflow: inflowMINUSoutflow ?? this.inflowMINUSoutflow,
      cf: cf ?? this.cf,
    );
  }

  factory ExportDataModel.fromMap(Map<String, dynamic> map) {
    return ExportDataModel(
      date: NepaliDateTime(map['date']),
      outflow: map['outflow']?.toDouble() ?? 0.0,
      inflow: map['inflow']?.toDouble() ?? 0.0,
      inflowMINUSoutflow: map['inflowMINUSoutflow']?.toDouble() ?? 0.0,
      cf: map['cf']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportDataModel.fromJson(String source) => ExportDataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ExportDataModel(date: $date, outflow: $outflow, inflow: $inflow, inflowMINUSoutflow: $inflowMINUSoutflow, cf: $cf)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExportDataModel && other.date == date && other.outflow == outflow && other.inflow == inflow && other.inflowMINUSoutflow == inflowMINUSoutflow && other.cf == cf;
  }

  @override
  int get hashCode {
    return date.hashCode ^ outflow.hashCode ^ inflow.hashCode ^ inflowMINUSoutflow.hashCode ^ cf.hashCode;
  }
}
