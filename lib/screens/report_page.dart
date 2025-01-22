import 'dart:io';

// import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/date_selector.dart';
import 'package:byaparlekha/config/configuration.dart';
import 'package:byaparlekha/config/globals.dart' as globals;
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/monthlyBudgetProjectionReport.dart';
import 'package:byaparlekha/models/monthyCategoryReport.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../components/extra_componenets.dart';
import '../config/globals.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({
    Key? key,
  }) : super(key: key);
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with WidgetsBindingObserver {
  // List<ExportDataModel> transcationExportDataModel = [];
  // List<ExportDataModel> budgetExportDataModel = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, List<MonthlyCategoryReport>> reports = {};

  List<NepaliDateTime> initializeDateResolver(int fromyear, int frommonth, int toyear, int tomonth) {
    List<NepaliDateTime> _dateResolver = [];
    int noOfMonths = ((((toyear - fromyear) * 12) + tomonth) - frommonth);
    int initYear = fromyear;
    int indexYear = initYear;
    for (int i = frommonth; i <= (noOfMonths + frommonth); i++) {
      _dateResolver.add(NepaliDateTime(indexYear, (i % 12 == 0) ? 12 : i % 12));
      if (i % 12 == 0) {
        indexYear++;
      }
    }
    return _dateResolver;
  }

  NepaliDateTime fromDate = NepaliDateTime(NepaliDateTime.now().year, NepaliDateTime.now().month);
  NepaliDateTime toDate = NepaliDateTime(NepaliDateTime.now().year, NepaliDateTime.now().month + 1);
  bool isEnglish = true;
  @override
  void initState() {
    super.initState();
    isEnglish = Provider.of<PreferenceProvider>(context, listen: false).isEnglish;
  }

  Widget getSearchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AdaptiveText(
                          TextModel('From'.toUpperCase()),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        DateSelector(
                          textColor: Colors.black,
                          onDateChanged: (value) {
                            if (value != null)
                              setState(() {
                                fromDate = value;
                              });
                          },
                          currentDate: fromDate,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AdaptiveText(
                          TextModel('To'.toUpperCase()),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        DateSelector(
                          textColor: Colors.black,
                          initialDateYear: fromDate.year,
                          initialMonth: fromDate.month,
                          currentDate: toDate,
                          onDateChanged: (value) {
                            if (value != null)
                              setState(() {
                                toDate = value;
                              });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextButton(
                  onPressed: () {
                    if (toDate.difference(fromDate).isNegative) {
                      showSnackBar(context, 'End date cannot be behind than From date');
                      return;
                    }
                    getReportData(
                      NepaliDateTime(
                        fromDate.year,
                        fromDate.month,
                        fromDate.day,
                      ),
                      NepaliDateTime(
                        toDate.year,
                        toDate.month,
                        toDate.day,
                      ),
                    );
                  },
                  child: Center(
                    child: AdaptiveText(
                      TextModel('Search'),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearVariable() {
    reports.clear();
  }

  getReportData(
    NepaliDateTime fromDate,
    NepaliDateTime toDate,
  ) async {
    clearVariable();
    final dataToBeFetchDates = initializeDateResolver(fromDate.year, fromDate.month, toDate.year, toDate.month);
    final inflowCategories = await AppDatabase().myDatabase.categoryDao.getCategoryByIncomeExpense(true);
    final outflowCategories = await AppDatabase().myDatabase.categoryDao.getCategoryByIncomeExpense(false);
    final Map<NepaliDateTime, List<MonthlyCategoryReport>> inflowReport = {};
    final Map<NepaliDateTime, List<MonthlyCategoryReport>> outflowReport = {};
    //
    for (var currentDate in dataToBeFetchDates) {
      final data = await AppDatabase().myDatabase.transactionsDao.getMonthlyTransactionReportByCategory(currentDate);
      List<MonthlyCategoryReport> inflowData = [];
      List<MonthlyCategoryReport> outflowData = [];
      for (var currentCategory in inflowCategories) {
        final categoryData = data.firstWhere((element) => element.categoryData.id == currentCategory.id, orElse: () {
          return MonthlyCategoryReport(categoryData: currentCategory, inflowAmount: 0, outflowAmount: 0, isIncome: true, reportDate: currentDate.toDateTime(), categoryHeadingName: '');
        });
        inflowData.add(categoryData);
      }

      inflowReport.addAll({currentDate: inflowData});
      for (var currentCategory in outflowCategories) {
        final categoryData = data.firstWhere((element) => element.categoryData.id == currentCategory.id, orElse: () {
          return MonthlyCategoryReport(categoryData: currentCategory, inflowAmount: 0, outflowAmount: 0, isIncome: false, reportDate: currentDate.toDateTime(), categoryHeadingName: '');
        });
        outflowData.add(categoryData);
      }
      outflowReport.addAll({currentDate: outflowData});
    }
    final List<MonthlyCategoryReport> _reports = [];
    inflowReport.forEach((key, value) {
      _reports.addAll(value);
    });
    outflowReport.forEach((key, value) {
      _reports.addAll(value);
    });
    _reports.sort(
      (a, b) => a.reportDate.isBefore(b.reportDate) ? -1 : 1,
    );
    this.reports = _reports.groupBy<String>((a) {
      final temp = a.reportDate.toNepaliDateTime();
      return NepaliDateTime(temp.year, temp.month).toIso8601String();
    });
    this.reports = this.reports.map<String, List<MonthlyCategoryReport>>((key, value) {
      value.sort((a, b) => a.categoryData.id - b.categoryData.id);
      return MapEntry(key, value);
    });

    setState(() {});
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Configuration().appColor,
        appBar: AppBar(
          title: AdaptiveText(
            TextModel('Report'),
            style: TextStyle(fontSize: 17),
          ),
        ),
        floatingActionButton: reports.isEmpty
            ? null
            : Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.yellow[800],
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.grey,
                  hoverColor: Colors.grey,
                  onTap: _exportDataToExcel,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(Icons.import_export, size: 30, color: Colors.white),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        AdaptiveText(
                          TextModel('Export Report'),
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
        body: Padding(
          padding: const EdgeInsets.only(top: 23.0),
          child: Container(
            height: double.maxFinite,
            decoration: pageBorderDecoration,
            padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 50),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  getSearchWidget(),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currentData = reports.keys.toList()[index];
                        final currentReportList = (reports[currentData] ?? []);
                        currentReportList.sort((a, b) => a.categoryData.name.toLowerCase().compareTo(b.categoryData.name.toLowerCase()));
                        // final categoryData = (reports[currentData] ?? []).sor
                        return Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              color: Colors.green,
                              child: Text(
                                NepaliDateFormat('MMMM yyyy').format(
                                  NepaliDateTime.parse(currentData),
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: (currentReportList)
                                      .map((e) => ListTile(
                                            title: AdaptiveText(
                                              TextModel(e.categoryData.name, nepaliName: e.categoryData.nepaliName),
                                            ),
                                            trailing: Text(nepaliNumberFormatter(e.isIncome ? e.inflowAmount : e.outflowAmount)),
                                          ))
                                      .toList(),
                                ))
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 0,
                          ),
                      itemCount: reports.length),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  int colorIndex = 0;
  getAlphabetFromIndex(int index) => String.fromCharCode(65 + index);
  ExcelColor excelBackgroundColors(int index) => ExcelColor.fromInt([
        Color(0xff9fc4e9),
        Color(0xffcfe2f3),
        Color(0xffd9ebd2),
      ][index % 3]
          .value);
  //Projection Only

  int _generateProjectionExcelSheetData(Excel excel, String sheet, int row, List<MonthlyBudgetProjectionReport> data, bool isInflow, List<NepaliDateTime> dataToBeFetchDates) {
    int column = 1;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue('Projected Cash ${isInflow ? 'Inflow' : 'Outflow'}'), cellStyle: headerCellStyle);
    row++;
    List<String> headers = [
      'S.N',
      'Cash ${isInflow ? 'Inflow' : 'Outflow'} Source Heading',
      ...dataToBeFetchDates.map((element) {
        return (NepaliDateFormat('yyyy MMMM').format(element));
      })
    ];
    //Printing Headers in excel
    headers.forEach((element) {
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue(element), cellStyle: headerCellStyle);
      column++;
    });
    row++;
    column = 1;
    final groupedDataByCategoryHeading = data.groupBy((p0) => p0.categoryData.categoryHeadingId);
    int categoryHeadingIndex = 0;
    groupedDataByCategoryHeading.forEach((key, currentCategoryHeadingData) {
      //CatgeoryHeading
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue((categoryHeadingIndex + 1).toString()),
        cellStyle: numberHeaderCellStyle,
      );
      column++;
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue(currentCategoryHeadingData.first.categoryHeadingName + " (" + getAlphabetFromIndex(categoryHeadingIndex) + ")"),
        cellStyle: headerCellStyle,
      );
      column++;
      {
        final groupedDataByMonth = currentCategoryHeadingData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
        colorIndex = 0;
        for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
          final currentDate = dataToBeFetchDates[dateIndex];
          final sumAmount = (groupedDataByMonth[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
            0.0,
            (previousValue, element) => (previousValue) + element.budget,
          );
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(nepaliNumberFormatter(sumAmount, decimalDigits: 2, language: Language.english)),
            cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
          );
          column++;

          updateColor();
        }
      }
      row++;
      column = 1;
      //
      final categoryItem = currentCategoryHeadingData.groupBy((p0) => p0.categoryData.id);
      {
        for (int currentCategoryItemGroupedIndex = 0; currentCategoryItemGroupedIndex < categoryItem.keys.length; currentCategoryItemGroupedIndex++) {
          final currentItemTransactionSummaryKey = categoryItem.keys.elementAt(currentCategoryItemGroupedIndex);
          final currentItemTransactionSummary = categoryItem[currentItemTransactionSummaryKey] ?? [];
          final groupedItemDataByDate = currentItemTransactionSummary.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
          //
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue((categoryHeadingIndex + 1).toString() + '.' + (currentCategoryItemGroupedIndex + 1).toString()),
            cellStyle: numberCellStyle,
          );
          column++;
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(currentItemTransactionSummary.first.categoryData.name),
            cellStyle: cellStyle,
          );
          column++;
          colorIndex = 0;
          for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
            final currentDate = dataToBeFetchDates[dateIndex];
            final sumAmount = (groupedItemDataByDate[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
              0.0,
              (previousValue, element) => (previousValue) + element.budget,
            );

            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter(sumAmount, decimalDigits: 2, language: Language.english)),
              cellStyle: numberCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
            );
            column++;
            updateColor();
          }
          row++;
          colorIndex = 0;
          column = 1;
        }
      }
      categoryHeadingIndex++;
    });
    column = 2;
    String alphas = getAlphabetFromIndex(0);
    for (int i = 1; i < categoryHeadingIndex; i++) {
      alphas = alphas + "+" + getAlphabetFromIndex(i);
    }
    excel.updateCell(
      sheet,
      CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
      TextCellValue("Total (${getAlphabetFromIndex(categoryHeadingIndex)}) = $alphas"),
      cellStyle: headerCellStyle,
    );
    column++;
    double sumAmount = 0;
    final dateTimeGroupData = data.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
    colorIndex = 0;
    for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
      final currentDate = dataToBeFetchDates[dateIndex];
      sumAmount = (dateTimeGroupData[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
        0.0,
        (previousValue, element) => (previousValue) + element.budget,
      );
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue(nepaliNumberFormatter(sumAmount, decimalDigits: 2, language: Language.english, showSign: true)),
        cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
      );
      column++;
      updateColor();
    }
    return row;
  }

  int _generateProjectionVsActualExcelSheetData(
      Excel excel, String sheet, int row, List<MonthlyBudgetProjectionReport> projectedData, List<MonthlyBudgetProjectionReport> actualData, bool isInflow, List<NepaliDateTime> dataToBeFetchDates) {
    int column = 1;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue('Projected Cash ${isInflow ? 'Inflow' : 'Outflow'}'), cellStyle: headerCellStyle);
    row++;
    List<String> headers = [
      'S.N',
      'Cash ${isInflow ? 'Inflow' : 'Outflow'} Source Heading',
    ];
    dataToBeFetchDates.forEach((element) {
      headers.add(NepaliDateFormat('yyyy MMMM').format(element) + '(P)');
      headers.add(NepaliDateFormat('yyyy MMMM').format(element) + '(A)');
      headers.add(NepaliDateFormat('yyyy MMMM').format(element) + '(D)');
    });
    //Printing Headers in excel
    headers.forEach((element) {
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue(element), cellStyle: headerCellStyle);
      column++;
    });
    row++;
    column = 1;
    //
    final groupedProjectedDataByCategoryHeading = projectedData.groupBy((p0) => p0.categoryData.categoryHeadingId);
    final groupedActualDataByCategoryHeading = actualData.groupBy((p0) => p0.categoryData.categoryHeadingId);
    //
    int categoryHeadingIndex = 0;
    groupedProjectedDataByCategoryHeading.forEach((key, currentCategoryHeadingData) {
      final currentCategoryHeadingActualData = groupedActualDataByCategoryHeading[key] ?? [];
      //CatgeoryHeading
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue((categoryHeadingIndex + 1).toString()),
        cellStyle: numberHeaderCellStyle,
      );
      column++;
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue(currentCategoryHeadingData.first.categoryHeadingName + " (" + getAlphabetFromIndex(categoryHeadingIndex) + ")"),
        cellStyle: headerCellStyle,
      );
      column++;
      {
        final groupedDataByMonth = currentCategoryHeadingData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
        final groupedActualDataByMonth = currentCategoryHeadingActualData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
        colorIndex = 0;
        for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
          final currentDate = dataToBeFetchDates[dateIndex];
          final sumAmount = (groupedDataByMonth[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
            0.0,
            (previousValue, element) => (previousValue) + element.budget,
          );
          final actualSumAmount = (groupedActualDataByMonth[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
            0.0,
            (previousValue, element) => (previousValue) + element.budget,
          );
          //projected
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(nepaliNumberFormatter(sumAmount, decimalDigits: 2, language: Language.english)),
            cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
          );
          column++;
          //actual
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(nepaliNumberFormatter(actualSumAmount, decimalDigits: 2, language: Language.english)),
            cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
          );
          column++;
          //dep
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(nepaliNumberFormatter((sumAmount - actualSumAmount) * (isInflow ? 1 : -1), decimalDigits: 2, language: Language.english, showSign: true)),
            cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
          );
          column++;
          updateColor();
        }
      }
      row++;
      column = 1;
      //
      final categoryItem = currentCategoryHeadingData.groupBy((p0) => p0.categoryData.id);
      final actualCategoryItem = currentCategoryHeadingActualData.groupBy((p0) => p0.categoryData.id);
      {
        for (int currentCategoryItemGroupedIndex = 0; currentCategoryItemGroupedIndex < categoryItem.keys.length; currentCategoryItemGroupedIndex++) {
          final currentItemTransactionSummaryKey = categoryItem.keys.elementAt(currentCategoryItemGroupedIndex);
          final currentItemTransactionSummary = categoryItem[currentItemTransactionSummaryKey] ?? [];
          final groupedItemDataByDate = currentItemTransactionSummary.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
          final groupedActualItemDataByDate = (actualCategoryItem[currentItemTransactionSummaryKey] ?? []).groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
          //
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue((categoryHeadingIndex + 1).toString() + '.' + (currentCategoryItemGroupedIndex + 1).toString()),
            cellStyle: numberCellStyle,
          );
          column++;
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(currentItemTransactionSummary.first.categoryData.name),
            cellStyle: cellStyle,
          );
          column++;
          colorIndex = 0;
          for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
            final currentDate = dataToBeFetchDates[dateIndex];
            final sumAmount = (groupedItemDataByDate[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
              0.0,
              (previousValue, element) => (previousValue) + element.budget,
            );
            final actualSumAmount = (groupedActualItemDataByDate[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
              0.0,
              (previousValue, element) => (previousValue) + element.budget,
            );
            //projected
            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter(sumAmount, decimalDigits: 2, language: Language.english)),
              cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
            );
            column++;
            //actual
            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter(actualSumAmount, decimalDigits: 2, language: Language.english)),
              cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
            );
            column++;
            //dep
            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter((sumAmount - actualSumAmount) * (isInflow ? 1 : -1), decimalDigits: 2, language: Language.english, showSign: true)),
              cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
            );
            column++;
            updateColor();
          }
          row++;
          colorIndex = 0;
          column = 1;
        }
      }
      categoryHeadingIndex++;
    });
    column = 2;
    String alphas = getAlphabetFromIndex(0);
    for (int i = 1; i < categoryHeadingIndex; i++) {
      alphas = alphas + "+" + getAlphabetFromIndex(i);
    }
    excel.updateCell(
      sheet,
      CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
      TextCellValue("Total (${getAlphabetFromIndex(categoryHeadingIndex)}) = $alphas"),
      cellStyle: headerCellStyle,
    );
    column++;

    final dateTimeGroupData = projectedData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
    final dateTimeActualGroupData = actualData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
    colorIndex = 0;
    for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
      final currentDate = dataToBeFetchDates[dateIndex];
      final sumAmount = (dateTimeGroupData[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
        0.0,
        (previousValue, element) => (previousValue) + element.budget,
      );
      final actualSumAmount = (dateTimeActualGroupData[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
        0.0,
        (previousValue, element) => (previousValue) + element.budget,
      );
      //projected
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue(nepaliNumberFormatter(sumAmount, decimalDigits: 2, language: Language.english)),
        cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
      );
      column++;
      //actual
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue(nepaliNumberFormatter(actualSumAmount, decimalDigits: 2, language: Language.english)),
        cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
      );
      column++;
      //dep
      excel.updateCell(
        sheet,
        CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue(nepaliNumberFormatter((sumAmount - actualSumAmount) * (isInflow ? 1 : -1), decimalDigits: 2, language: Language.english, showSign: true)),
        cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)),
      );
      column++;
      updateColor();
    }
    return row;
  }

  updateColor() {
    colorIndex = (colorIndex + 1) % 3;
    // colorIndex = colorIndex == 0 ? 1 : 0;
  }

  final actualCashFlowSheetName = "Actual Cashflow Report";
  final projectCashFlowSheetName = "Projected Cashflow Report";
  final actualAndProjectedCashFlowSheetName = 'Actual vs Projected Cashflow Report';
  _exportDataToExcel() async {
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    try {
      final user = await AppDatabase().myDatabase.userDao.getUserData();
      //get list of date to be shown in excel
      List<NepaliDateTime> dataToBeFetchDates = initializeDateResolver(fromDate.year, fromDate.month, toDate.year, toDate.month);
      final double openingBalance =
          await AppDatabase().myDatabase.accountDao.watchOpeningBalanceTillNow(fromDate.month == 1 ? fromDate.year - 1 : fromDate.year, fromDate.month == 1 ? 12 : fromDate.month).first;
      final double openingActualCashPositionAmount =
          await AppDatabase().myDatabase.transactionsDao.watchCumulativeCashPosition(fromDate.month == 1 ? fromDate.year - 1 : fromDate.year, fromDate.month == 1 ? 12 : fromDate.month).first;
      // final double openingProjectedCashPositionAmount =
      //     await AppDatabase().myDatabase.budgetDao.getProjectedCumulativeCashPosition(fromDate.month == 1 ? fromDate.year - 1 : fromDate.year, fromDate.month == 1 ? 12 : fromDate.month);
      final dataList = await Future.wait([
        AppDatabase().myDatabase.budgetDao.getBudgetProjectionForReportBetweemDates(true, fromDate, toDate),
        AppDatabase().myDatabase.budgetDao.getBudgetProjectionForReportBetweemDates(false, fromDate, toDate),
        AppDatabase().myDatabase.transactionsDao.getActualCashflowForCategoryForReportBetweemDates(true, fromDate, toDate),
        AppDatabase().myDatabase.transactionsDao.getActualCashflowForCategoryForReportBetweemDates(false, fromDate, toDate)
      ]);

      final List<MonthlyBudgetProjectionReport> inflowData = dataList[0];
      final List<MonthlyBudgetProjectionReport> outflowData = dataList[1];
      final List<MonthlyBudgetProjectionReport> actualInflowFlowData = dataList[2];
      final List<MonthlyBudgetProjectionReport> actualOutflowData = dataList[3];
      Excel excel = Excel.createExcel();
      String companyName = SharedPreferenceService().userName;
      await _excelDataForProjectionCashFlow(excel, companyName, dataToBeFetchDates, user.name, inflowData, outflowData, openingBalance + openingActualCashPositionAmount);
      await _excelDataForActualCashFlow(excel, companyName, dataToBeFetchDates, user.name, actualInflowFlowData, actualOutflowData, openingBalance + openingActualCashPositionAmount);
      await _excelDataForActualVsProjectionCashFlow(
          excel, companyName, dataToBeFetchDates, user.name, inflowData, outflowData, actualInflowFlowData, actualOutflowData, openingBalance + openingActualCashPositionAmount);
      final value = excel.encode();
      if (value == null) {
        throw ('Error Generating Excel, Please try again');
      }
      Directory directory = (await (getExternalStorageDirectories(type: StorageDirectory.downloads)))!.first;
      String finalPath = directory.path + "/Report/" + "Report-${DateTime.now().toIso8601String()}.xlsx";
      await (File(finalPath)..createSync(recursive: true)).writeAsBytes(value);
      await pr.hide();
      // FlutterEmailSender.send(Email(attachmentPaths: [finalPath], subject: 'd', recipients: ['exocist1@gmail.com']));
      showSuccessToast(isEnglish ? 'Report had been generated and saved in download folder of app' : 'रिपोर्ट एपको डाउनलोड फोल्डरमा राखिएको छ');
      await pr.hide();
      await OpenFilex.open(finalPath);
    } catch (e) {
      await pr.hide();
      showSnackBar(context, e.toString());
    }
  }

  _excelDataForActualVsProjectionCashFlow(
      Excel excel,
      String companyName,
      List<NepaliDateTime> dataToBeFetchDates,
      String userName,
      List<MonthlyBudgetProjectionReport> inflowData,
      List<MonthlyBudgetProjectionReport> outflowData,
      List<MonthlyBudgetProjectionReport> actualInflowFlowData,
      List<MonthlyBudgetProjectionReport> actualOutflowData,
      double intOpeningBalance) async {
    int row = 0;
    int column = 1;
    String sheet = actualAndProjectedCashFlowSheetName;
    excel.rename("Sheet1", sheet);
    excel.setDefaultSheet(sheet);
    double openingBalance = intOpeningBalance;

    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue('Actual vs Projected Cashflow Projection of $companyName as of ${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}'),
        cellStyle: headerCellStyle);
    row++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue('Statement from "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(fromDate)}" to "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}"'),
        cellStyle: headerCellStyle);
    row++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue('Generated By: $userName'), cellStyle: headerCellStyle);

    row += 2;
    row = _generateProjectionVsActualExcelSheetData(excel, sheet, row, inflowData, actualInflowFlowData, true, dataToBeFetchDates);
    row += 2;
    row = _generateProjectionVsActualExcelSheetData(excel, sheet, row, outflowData, actualOutflowData, false, dataToBeFetchDates);
    row += 2;
    column++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue("Cash Position of the Month"), cellStyle: headerCellStyle);
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1), TextCellValue("Opening Balance"), cellStyle: headerCellStyle);
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2), TextCellValue("Cumulative Cash Position"), cellStyle: headerCellStyle);
    column++;
    final allProjectedData = [...inflowData, ...outflowData];
    final allActualData = [...actualInflowFlowData, ...actualOutflowData];

    final groupedDataByMonth = allProjectedData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));

    final groupedActualDataByMonth = allActualData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));

    colorIndex = 0;
    for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
      final currentDate = dataToBeFetchDates[dateIndex];
      final _currentMonthOpeningBalance = await AppDatabase().myDatabase.accountDao.openingBalanceOfCurrentMonth(currentDate.year, currentDate.month);
      openingBalance = openingBalance + _currentMonthOpeningBalance;
      final sumAmount = (groupedDataByMonth[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
        0.0,
        (previousValue, element) => (previousValue) + (element.budget * (element.isIncome ? 1 : -1)),
      );
      final actualSumAmount = (groupedActualDataByMonth[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
        0.0,
        (previousValue, element) => (previousValue) + (element.budget * (element.isIncome ? 1 : -1)),
      );
      //projected
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue(nepaliNumberFormatter(sumAmount, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1), TextCellValue(nepaliNumberFormatter(openingBalance, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2), TextCellValue(nepaliNumberFormatter(sumAmount + openingBalance, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      column++;
      //actual
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue(nepaliNumberFormatter(actualSumAmount, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1), TextCellValue(nepaliNumberFormatter(openingBalance, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(
          sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2), TextCellValue(nepaliNumberFormatter(actualSumAmount + openingBalance, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      column++;
      //dep
      final deprecatedAmount = actualSumAmount - sumAmount;
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue(nepaliNumberFormatter(deprecatedAmount, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1), TextCellValue(nepaliNumberFormatter(openingBalance, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      final cumulativeAmount = deprecatedAmount + openingBalance;
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2), TextCellValue(nepaliNumberFormatter(cumulativeAmount, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      openingBalance = cumulativeAmount;
      updateColor();
      column++;
    }
  }

  _excelDataForProjectionCashFlow(Excel excel, String companyName, List<NepaliDateTime> dataToBeFetchDates, String userName, List<MonthlyBudgetProjectionReport> inflowData,
      List<MonthlyBudgetProjectionReport> outflowData, double intOpeningBalance) async {
    String sheet = projectCashFlowSheetName;
    int row = 0;
    int column = 1;
    double openingBalance = intOpeningBalance;

    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue('Cashflow Projection of $companyName as of ${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}'),
        cellStyle: headerCellStyle);
    row++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue('Statement from "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(fromDate)}" to "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}"'),
        cellStyle: headerCellStyle);
    row++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue('Generated By: $userName'), cellStyle: headerCellStyle);

    row += 2;
    row = _generateProjectionExcelSheetData(excel, sheet, row, inflowData, true, dataToBeFetchDates);
    row += 2;
    row = _generateProjectionExcelSheetData(excel, sheet, row, outflowData, false, dataToBeFetchDates);
    row += 2;
    column++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue("Cash Position of the Month"), cellStyle: headerCellStyle);
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1), TextCellValue("Opening Balance"), cellStyle: headerCellStyle);
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2), TextCellValue("Cumulative Cash Position"), cellStyle: headerCellStyle);
    column++;
    final allProjectedData = [...inflowData, ...outflowData];

    final groupedDataByMonth = allProjectedData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));

    colorIndex = 0;
    for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
      final currentDate = dataToBeFetchDates[dateIndex];
      final _currentMonthOpeningBalance = await AppDatabase().myDatabase.accountDao.openingBalanceOfCurrentMonth(currentDate.year, currentDate.month);
      openingBalance = openingBalance + _currentMonthOpeningBalance;
      final sumAmount = (groupedDataByMonth[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
        0.0,
        (previousValue, element) => (previousValue) + (element.budget * (element.isIncome ? 1 : -1)),
      );
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue(nepaliNumberFormatter(sumAmount, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1), TextCellValue(nepaliNumberFormatter(openingBalance, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2), TextCellValue(nepaliNumberFormatter(sumAmount + openingBalance, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      openingBalance = sumAmount + openingBalance;
      updateColor();
      column++;
    }
  }

  _excelDataForActualCashFlow(Excel excel, String companyName, List<NepaliDateTime> dataToBeFetchDates, String userName, List<MonthlyBudgetProjectionReport> actualInflowFlowData,
      List<MonthlyBudgetProjectionReport> actualOutflowData, double intOpeningBalance) async {
    String sheet = actualCashFlowSheetName;

    int row = 0;
    int column = 1;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue('Actual Cashflow of $companyName as of ${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}'),
        cellStyle: headerCellStyle);
    row++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
        TextCellValue('Statement from "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(fromDate)}" to "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}"'),
        cellStyle: headerCellStyle);
    row++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue('Generated By: $userName'), cellStyle: headerCellStyle);
    row += 2;
    row = _generateProjectionExcelSheetData(excel, sheet, row, actualInflowFlowData, true, dataToBeFetchDates);
    row += 2;
    _generateProjectionExcelSheetData(excel, sheet, row, actualOutflowData, false, dataToBeFetchDates);
    column++;
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue("Cash Position of the Month"), cellStyle: headerCellStyle);
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1), TextCellValue("Opening Balance"), cellStyle: headerCellStyle);
    excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2), TextCellValue("Cumulative Cash Position"), cellStyle: headerCellStyle);
    column++;
    final allProjectedData = [...actualInflowFlowData, ...actualOutflowData];
    double openingBalance = intOpeningBalance;
    final groupedDataByMonth = allProjectedData.groupBy((p0) => p0.reportDate == null ? null : NepaliDateFormat.yM().format(p0.reportDate!));
    colorIndex = 0;
    for (int dateIndex = 0; dateIndex < dataToBeFetchDates.length; dateIndex++) {
      final currentDate = dataToBeFetchDates[dateIndex];
      final _currentMonthOpeningBalance = await AppDatabase().myDatabase.accountDao.openingBalanceOfCurrentMonth(currentDate.year, currentDate.month);
      openingBalance = openingBalance + _currentMonthOpeningBalance;
      final sumAmount = (groupedDataByMonth[NepaliDateFormat.yM().format(currentDate)] ?? []).fold(
        0.0,
        (previousValue, element) => (previousValue) + (element.budget * (element.isIncome ? 1 : -1)),
      );
      excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row), TextCellValue(nepaliNumberFormatter(sumAmount, showSign: true, decimalDigits: 2)),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(
          sheet,
          CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 1),
          TextCellValue(
            nepaliNumberFormatter(openingBalance, showSign: true, decimalDigits: 2),
          ),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      excel.updateCell(
          sheet,
          CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row + 2),
          TextCellValue(
            nepaliNumberFormatter(sumAmount + openingBalance, showSign: true, decimalDigits: 2),
          ),
          cellStyle: numberHeaderCellStyle.copyWith(backgroundColorHexVal: excelBackgroundColors(colorIndex)));
      openingBalance = sumAmount + openingBalance;
      updateColor();
      column++;
    }
  }
}
