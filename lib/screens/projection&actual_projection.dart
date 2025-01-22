import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/monthlyProjectionModel.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../components/extra_componenets.dart';
import '../config/configuration.dart';
import '../config/globals.dart';

class ProjectionAndActualProjectionPage extends StatefulWidget {
  const ProjectionAndActualProjectionPage({
    Key? key,
  }) : super(key: key);
  @override
  _ProjectionAndActualProjectionPageState createState() => _ProjectionAndActualProjectionPageState();
}

class _ProjectionAndActualProjectionPageState extends State<ProjectionAndActualProjectionPage> with SingleTickerProviderStateMixin {
  int _currentYear = NepaliDateTime.now().year;
  int _currentMonth = NepaliDateTime.now().month;
  Lang? language;
  late TabController _tabController;
  String? selectedSubSector;
  final int noOfmonths = 132;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _dateResolver = <NepaliDateTime>[];
  final TextStyle _style = TextStyle(fontWeight: FontWeight.w500);
  @override
  void initState() {
    super.initState();
    language = Provider.of<PreferenceProvider>(context, listen: false).language;
    initializeDateResolver();
    _tabController = TabController(length: noOfmonths, vsync: this, initialIndex: _currentMonth - 1);
  }

  initializeDateResolver() {
    // int _year = _currentYear;
    // int _firstMonth;
    // bool _incrementer;
    int initYear = _currentYear;
    int indexYear = initYear;
    for (int i = 1; i <= noOfmonths; i++) {
      _dateResolver.add(NepaliDateTime(indexYear, (i % 12 == 0) ? 12 : i % 12));
      if (i % 12 == 0) {
        indexYear++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Configuration().appColor,
      appBar: AppBar(
        title: AdaptiveText(
          TextModel('Projection vs Actual Cash Flow'),
          style: TextStyle(fontSize: 17),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (int index = 0; index < noOfmonths; index++)
              Tab(
                child: Text(
                  NepaliDateFormat(
                    "MMMM ''yy",
                  ).format(
                    NepaliDateTime(_dateResolver[index].year, _dateResolver[index].month),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (int month = 0; month < noOfmonths; month++)
            _buildBody(
              _dateResolver[month].month,
              _dateResolver[month].year,
            ),
        ],
      ),
    );
  }

  Widget _buildBody(int month, int year) {
    return Padding(
      padding: const EdgeInsets.only(top: 23.0),
      child: Container(
        decoration: pageBorderDecoration,
        padding: EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Divider(),
              Expanded(
                child: FutureBuilder<List<MonthlyProjectionModel>>(
                  future: AppDatabase().myDatabase.budgetDao.getBudgetVsActualtProjectionForMonth(NepaliDateTime(year, month)),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return centerHintText(text: 'Categories Not Found');
                      }
                      List<String> columnTitle = ["Projected Cash Flow", "Actual Cash Flow", "Projected vs Actual Cash Flow"];

                      return StickyHeadersTable(
                        legendCell: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                          child: AdaptiveText(
                            TextModel(
                              "Cash Flow Source Heading",
                            ),
                            style: _style,
                          ),
                        ),
                        columnsLength: columnTitle.length,
                        showHorizontalScrollbar: true,
                        cellDimensions: CellDimensions.variableRowHeight(
                            contentCellWidth: 100, rowHeights: List.generate((snapshot.data ?? []).length, (index) => 60), stickyLegendWidth: 150, stickyLegendHeight: 56),
                        rowsLength: (snapshot.data ?? []).length,
                        columnsTitleBuilder: (columnIndex) {
                          return Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                            child: AdaptiveText(TextModel(columnTitle[columnIndex])),
                          );
                        },
                        rowsTitleBuilder: (rowIndex) {
                          final data = snapshot.data?[rowIndex];
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                            child: AdaptiveText(TextModel(data?.categoryData.name ?? '')),
                          );
                        },
                        contentCellBuilder: (columnIndex, rowIndex) {
                          final data = snapshot.data![rowIndex];
                          switch (columnIndex) {
                            case 0:
                              return Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 3),
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                                  child: Text(nepaliNumberFormatter(data.budgetAmount, decimalDigits: 2)));
                            case 1:
                              return Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                                  child: Text(nepaliNumberFormatter(
                                    data.actualAmount,
                                    decimalDigits: 2,
                                  )));
                            case 2:
                              return Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                                  child: Text(nepaliNumberFormatter(data.budgetAmount - data.actualAmount, decimalDigits: 2, showSign: true)));
                            default:
                              return Text("");
                          }
                        },
                      );
                      // return Table(
                      //   border: TableBorder.all(),
                      //   columnWidths: {0: FlexColumnWidth(2.0), 1: FlexColumnWidth(1.0), 2: FlexColumnWidth(1.0)},
                      //   children: [
                      //     TableRow(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      //           child: AdaptiveText(TextModel("Cash Flow Source Heading")),
                      //         ),
                      //         Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4), child: AdaptiveText(TextModel("Projected Cash Flow"))),
                      //         Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4), child: AdaptiveText(TextModel("Actual Cash Flow")))
                      //       ],
                      //     ),
                      //     ...snapshot.data!.map((e) => TableRow(children: [
                      //           Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4), child: Text(language == Lang.EN ? e.categoryData.name : e.categoryData.nepaliName)),
                      //           Padding(
                      //             padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      //             child: Text(
                      //               e.budgetAmount.toString(),
                      //               textAlign: TextAlign.right,
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      //             child: Text(e.actualAmount.toString(), textAlign: TextAlign.right),
                      //           )
                      //         ]))
                      //   ],
                      // );
                    } else
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _categoryHeadingCategories(TextModel textModel, List<BudgetModel> budgetModel, int year, int month) {
  //   final calculatedData = budgetModel.reduce((value, element) => BudgetModel(
  //       budget: (value.budget ?? 0.0) + (element.budget ?? 0.0),
  //       amount: (value.amount ?? 0.0) + (element.amount ?? 0.0),
  //       categoryName: '',
  //       categoryNepaliName: '',
  //       categoryHeadingName: value.categoryHeadingName,
  //       categoryHeadingId: value.categoryHeadingId,
  //       categoryId: 0));
  //   budgetModel.sort((a, b) => a.categoryName.toLowerCase().compareTo(b.categoryName.toLowerCase()));
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Expanded(
  //             child: AdaptiveText(
  //               textModel,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 15,
  //               ),
  //             ),
  //           ),
  //           // Text(
  //           //   nepaliNumberFormatter(calculatedData.budget ?? 0.0),
  //           //   style: TextStyle(
  //           //     fontSize: 15,
  //           //     fontWeight: FontWeight.w500,
  //           //     color: getColor(isInflow, calculatedData.budget ?? 0.0,
  //           //         calculatedData.amount ?? 0.0),
  //           //   ),
  //           // ),
  //         ],
  //       ),
  //       SizedBox(
  //         height: 5,
  //       ),
  //       ListView.separated(
  //           shrinkWrap: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           itemBuilder: (context, index) {
  //             // return _buildCard(budgetModel[index], year, month);
  //           },
  //           separatorBuilder: (context, _) => SizedBox(height: 20.0),
  //           itemCount: budgetModel.length),
  //     ],
  //   );
  // }
}
