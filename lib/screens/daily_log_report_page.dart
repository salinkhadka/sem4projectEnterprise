import 'dart:io';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/date_selector.dart';
import 'package:byaparlekha/config/configuration.dart';
import 'package:byaparlekha/config/globals.dart' as globals;
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:collection/collection.dart';
import 'package:byaparlekha/models/exportmodel.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/models/transactionItemSummary.dart';
import 'package:byaparlekha/providers/preference_provider.dart';

import 'package:excel/excel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../components/extra_componenets.dart';
import '../config/globals.dart';

class DailyLogReportPage extends StatefulWidget {
  const DailyLogReportPage({
    Key? key,
  }) : super(key: key);
  @override
  _DailyLogReportPageState createState() => _DailyLogReportPageState();
}

class _DailyLogReportPageState extends State<DailyLogReportPage>
    with WidgetsBindingObserver {
  // List<ExportDataModel> budgetExportDataModel = [];
  // List<ExportDataModel> transcationExportDataModel = [];
  Map<DateTime, List<TransactionItemSummary>>? dailyLogSumamry = {};
  List<TransactionItemSummary> dailyLogRealData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  NepaliDateTime fromDate =
      NepaliDateTime(NepaliDateTime.now().year, NepaliDateTime.now().month);
  NepaliDateTime toDate =
      NepaliDateTime(NepaliDateTime.now().year, NepaliDateTime.now().month + 1);
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
                  // style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => Configuration().incomeColor)),
                  onPressed: () {
                    if (toDate.difference(fromDate).isNegative) {
                      showSnackBar(
                          context, 'End date cannot be behind than From date');
                      return;
                    }
                    getReportData(fromDate, toDate);
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
    dailyLogSumamry?.clear();
    dailyLogRealData.clear();
  }

  getReportData(NepaliDateTime fromNepaliDateTime,
      NepaliDateTime toNepaliDateTime) async {
    clearVariable();
    setState(() {});
    final data = await AppDatabase()
        .myDatabase
        .transactionItemDao
        .getTransactionItem(fromNepaliDateTime, toNepaliDateTime);
    dailyLogRealData = data;
    dailyLogRealData.sort((x, y) =>
        x.item.name.toLowerCase().compareTo(y.item.name.toLowerCase()));
    dailyLogSumamry = data.groupBy<DateTime>((p0) => p0.transactionCreatedDate);
    setState(() {});
  }

  Map<String, List<ExportDataModel>>? budgetGroupedData;
  Map<String, List<ExportDataModel>>? transactionGroupData;
  List<int?> incomeCat = [];
  List<int?> exCat = [];
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
        floatingActionButton: (dailyLogSumamry ?? {}).isEmpty
            ? null
            : Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
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
                          child: Icon(
                            Icons.import_export,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        AdaptiveText(
                          TextModel('Export Report'),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
        body: Container(
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
                if (dailyLogSumamry == null)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currentDate =
                            dailyLogSumamry!.keys.toList()[index];
                        final currentData = dailyLogSumamry![currentDate]!;
                        return ExpansionTile(
                            textColor: Colors.black,
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Chip(
                                backgroundColor: Colors.green,
                                label: Text(
                                  NepaliDateFormat(
                                    "yyyy MMMM dd",
                                  ).format(currentDate.toNepaliDateTime()),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (currentData.first.billNumber != null)
                                  AdaptiveText(
                                    TextModel(
                                        ('Invoice Number: ' +
                                            (currentData.first.billNumber ??
                                                '')),
                                        nepaliName: ('बिल नम्बर: ' +
                                            (currentData.first.billNumber ??
                                                ''))),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                SizedBox(
                                  height: 1,
                                ),
                                AdaptiveText(
                                  TextModel(
                                      ('Sold To: ' +
                                          (currentData.first.person.name)),
                                      nepaliName: ('बेचेको: ' +
                                          (currentData.first.person.name))),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            children: currentData.map((currentTransactionData) {
                              return ListTile(
                                minLeadingWidth: 0,
                                // subtitle: AdaptiveText(TextModel(currentTransactionData.person.name)),
                                title: AdaptiveText(
                                  TextModel(
                                    currentTransactionData.item.name +
                                        ' (${nepaliNumberFormatter(currentTransactionData.transactionItem.quantity)})',
                                  ),
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: Text(
                                  nepaliNumberFormatter(
                                      currentTransactionData
                                          .transactionItem.amount,
                                      decimalDigits: 2),
                                  style: getTextStyle(
                                      currentTransactionData.isIncome),
                                ),
                              );
                            }).toList());
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: dailyLogSumamry!.length),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ));
  }

  TextStyle getTextStyle(bool isIncome) => TextStyle(
      color:
          isIncome ? Configuration().incomeColor : Configuration().expenseColor,
      fontWeight: FontWeight.bold);

  getRowValue({
    String? svgImageName,
    // Color iconColor,
    required String value,
    // double angle,
    // Widget iconWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // if (svgImageName != null)
          SvgPicture.asset('assets/images/$svgImageName.svg',
              width: 18, color: Colors.black),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: AdaptiveText(
              TextModel(value),
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  _exportDataToExcel() async {
    final ProgressDialog pr = ProgressDialog(context);
    final isEnglish =
        Provider.of<PreferenceProvider>(context, listen: false).isEnglish;
    await pr.show();
    try {
      var excel = Excel.createExcel();
      var sheet = excel.getDefaultSheet()!;
      //Contains log data grouped by income/expense
      final groupedDataByIncomeExpense = dailyLogRealData.groupBy((p0) =>
          p0.categoryHeadingData.isIncome ? 'Cash Inflow' : 'Cash Outflow');
      //Loop the log data by income OR Expense
      String companyName = SharedPreferenceService().userName;

      for (int categoryHeadingLevelIndex = 0;
          categoryHeadingLevelIndex < groupedDataByIncomeExpense.keys.length;
          categoryHeadingLevelIndex++) {
        final excelSheetTitle =
            categoryHeadingLevelIndex == 0 ? 'Sales' : 'Purchase';
        final newSheetName = "Cash $excelSheetTitle Report";
        if (categoryHeadingLevelIndex == 0) {
          excel.rename(sheet, newSheetName);
          excel.setDefaultSheet(newSheetName);
        }
        sheet = newSheetName;
        int row = 0, column = 1;
        colorIndex = 0;
        /*-Title-*/
        excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(
                'Cash $excelSheetTitle Report of $companyName as of ${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}'),
            cellStyle: headerCellStyle);
        row++;
        excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(
                'Statement from "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(fromDate)}" to "${NepaliDateFormat("yyyy-MM-dd", Language.english).format(toDate)}"'),
            cellStyle: headerCellStyle);
        row++;
        final user = await AppDatabase().myDatabase.userDao.getUserData();
        excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue('Generated By: ${user.name}'),
            cellStyle: headerCellStyle);
        row += 2;
        //get list of date to be shown in excel
        List<NepaliDateTime> dataToBeFetchDates = initializeDateResolver(
            fromDate.year, fromDate.month, toDate.year, toDate.month);
        List<String> headers = [
          'S.N',
          'Cashflow Source Heading',
          'Total Quantity',
          'Total $excelSheetTitle Amount',
        ];
        //Adding headers for date
        dataToBeFetchDates.forEach((element) {
          headers.add('Quantity');
          headers.add(NepaliDateFormat('yyyy MMMM').format(element));
        });
        //Printing Headers in excel
        headers.forEach((element) {
          excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(element),
              cellStyle: headerCellStyle);
          column++;
        });
        row++;
        column = 1;
        //Current key
        final currentCategoryHeadingKey = groupedDataByIncomeExpense.keys
            .elementAt(categoryHeadingLevelIndex);

        ///List of daily sales of [currentCategoryHeadingKey]
        final List<TransactionItemSummary> rawTransactionItemSummary =
            groupedDataByIncomeExpense[currentCategoryHeadingKey] ?? [];
        //Grouping the log data by date
        final categoryHeadingDataGroupedByMonth =
            rawTransactionItemSummary.groupBy(
          (p0) => NepaliDateFormat.yM()
              .format(p0.transactionCreatedDate.toNepaliDateTime()),
        );
        excel.updateCell(
          sheet,
          CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
          TextCellValue((categoryHeadingLevelIndex + 1).toString()),
          cellStyle: numberHeaderCellStyle,
        );
        column++;
        excel.updateCell(
          sheet,
          CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
          TextCellValue(currentCategoryHeadingKey),
          cellStyle: headerCellStyle,
        );
        column++;
        final fullData = rawTransactionItemSummary.fold(
          {"quantity": 0.0, "amount": 0.0},
          (previousValue, element) => {
            "quantity": (previousValue['quantity'] ?? 0.0) +
                element.transactionItem.quantity,
            "amount": (previousValue['amount'] ?? 0.0) +
                element.transactionItem.amount,
          },
        );
        excel.updateCell(
          sheet,
          CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
          TextCellValue(nepaliNumberFormatter(fullData['quantity'] ?? 0.0,
              decimalDigits: 2, language: Language.english)),
          cellStyle: numberHeaderCellStyle.copyWith(
              backgroundColorHexVal:
                  ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
        );
        column++;
        excel.updateCell(
          sheet,
          CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
          TextCellValue(nepaliNumberFormatter(fullData['amount'] ?? 0.0,
              decimalDigits: 2, language: Language.english)),
          cellStyle: numberHeaderCellStyle.copyWith(
              backgroundColorHexVal:
                  ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
        );
        column++;
        updateColor();
        {
          for (int dateIndex = 0;
              dateIndex < dataToBeFetchDates.length;
              dateIndex++) {
            final currentDate = dataToBeFetchDates[dateIndex];
            final data = (categoryHeadingDataGroupedByMonth[
                        NepaliDateFormat.yM().format(currentDate)] ??
                    [])
                .fold(
              {"quantity": 0.0, "amount": 0.0},
              (previousValue, element) => {
                "quantity": (previousValue['quantity'] ?? 0.0) +
                    element.transactionItem.quantity,
                "amount": (previousValue['amount'] ?? 0.0) +
                    element.transactionItem.amount,
              },
            );
            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter(data['quantity'] ?? 0.0,
                  decimalDigits: 2, language: Language.english)),
              cellStyle: numberHeaderCellStyle.copyWith(
                  backgroundColorHexVal:
                      ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
            );
            column++;
            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter(data['amount'] ?? 0.0,
                  decimalDigits: 2, language: Language.english)),
              cellStyle: numberHeaderCellStyle.copyWith(
                  backgroundColorHexVal:
                      ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
            );
            column++;
            updateColor();
          }
        }
        colorIndex = 0;
        row++;
        column = 1;
        //Grouping the current Month data by items
        final Map<int, List<TransactionItemSummary>> groupedDataByItem =
            rawTransactionItemSummary.groupBy((p0) => p0.item.id);
        for (int currentItemGroupedIndex = 0;
            currentItemGroupedIndex < groupedDataByItem.keys.length;
            currentItemGroupedIndex++) {
          final currentItemTransactionSummaryKey =
              groupedDataByItem.keys.elementAt(currentItemGroupedIndex);
          final currentItemTransactionSummary =
              groupedDataByItem[currentItemTransactionSummaryKey] ?? [];
          final groupedItemDataByDate = currentItemTransactionSummary.groupBy(
            (p0) => NepaliDateFormat.yM()
                .format(p0.transactionCreatedDate.toNepaliDateTime()),
          );
          //
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue((categoryHeadingLevelIndex + 1).toString() +
                '.' +
                (currentItemGroupedIndex + 1).toString()),
            cellStyle: numberCellStyle,
          );
          column++;
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(currentItemTransactionSummary.first.item.name),
            cellStyle: cellStyle,
          );
          column++;
          final transactionSummary = currentItemTransactionSummary.fold(
            {"quantity": 0.0, "amount": 0.0},
            (previousValue, element) => {
              "quantity": (previousValue['quantity'] ?? 0.0) +
                  element.transactionItem.quantity,
              "amount": (previousValue['amount'] ?? 0.0) +
                  element.transactionItem.amount,
            },
          );
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(nepaliNumberFormatter(
                transactionSummary['quantity'] ?? 0.0,
                decimalDigits: 2,
                language: Language.english)),
            cellStyle: numberCellStyle.copyWith(
                backgroundColorHexVal:
                    ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
          );
          column++;
          excel.updateCell(
            sheet,
            CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
            TextCellValue(nepaliNumberFormatter(
                transactionSummary['amount'] ?? 0.0,
                decimalDigits: 2,
                language: Language.english)),
            cellStyle: numberCellStyle.copyWith(
                backgroundColorHexVal:
                    ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
          );
          column++;
          updateColor();
          for (int dateIndex = 0;
              dateIndex < dataToBeFetchDates.length;
              dateIndex++) {
            final currentDate = dataToBeFetchDates[dateIndex];
            final data = (groupedItemDataByDate[
                        NepaliDateFormat.yM().format(currentDate)] ??
                    [])
                .fold(
              {"quantity": 0.0, "amount": 0.0},
              (previousValue, element) => {
                "quantity": (previousValue['quantity'] ?? 0.0) +
                    element.transactionItem.quantity,
                "amount": (previousValue['amount'] ?? 0.0) +
                    element.transactionItem.amount,
              },
            );
            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter(data['quantity'] ?? 0.0,
                  decimalDigits: 2, language: Language.english)),
              cellStyle: numberCellStyle.copyWith(
                  backgroundColorHexVal:
                      ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
            );
            column++;
            excel.updateCell(
              sheet,
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row),
              TextCellValue(nepaliNumberFormatter(data['amount'] ?? 0.0,
                  decimalDigits: 2, language: Language.english)),
              cellStyle: numberCellStyle.copyWith(
                  backgroundColorHexVal:
                      ExcelColor.fromInt(excelBackgroundColors(colorIndex))),
            );
            column++;
            updateColor();
          }
          row++;
          colorIndex = 0;
          column = 1;
        }
      }
      final value = excel.encode();
      if (value == null) {
        throw ('Error Generating Excel, Please try again');
      }
      Directory directory = (await (getExternalStorageDirectories(
              type: StorageDirectory.downloads)))!
          .first;
      String finalPath = directory.path +
          "/DailyReport/" +
          "DailyLogReport-${DateTime.now().toIso8601String()}.xlsx";
      await (File(finalPath)..createSync(recursive: true)).writeAsBytes(value);
      await pr.hide();
      showSuccessToast(isEnglish
          ? 'Report had been generated and saved in download folder of app'
          : 'रिपोर्ट एपको डाउनलोड फोल्डरमा राखिएको छ');
      await OpenFilex.open(finalPath);
    } catch (e) {
      await pr.hide();
      showSnackBar(context, e.toString());
    }
  }

  int colorIndex = 0;
  updateColor() {
    colorIndex = colorIndex == 0 ? 1 : 0;
  }

  List<NepaliDateTime> initializeDateResolver(
      int fromyear, int frommonth, int toyear, int tomonth) {
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

  int excelBackgroundColors(int index) =>
      [Color(0xff9fc4e9), Color(0xffcfe2f3)][index % 2].value;
}
