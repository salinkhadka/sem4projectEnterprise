import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/drawer.dart';
import 'package:byaparlekha/config/routes/routes.dart';
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/icons/vector_icons.dart';

import 'package:byaparlekha/models/budgetModel.dart';

import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:byaparlekha/screens/category_page.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';

import '../components/extra_componenets.dart';
import '../config/configuration.dart';
import '../config/globals.dart';
import '../models/app_page_naming.dart';


class BudgetPage extends StatefulWidget {
  final bool? isInflowProjection;

  const BudgetPage({Key? key, this.isInflowProjection}) : super(key: key);
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> with SingleTickerProviderStateMixin {
  int _currentYear = NepaliDateTime.now().year;
  int _currentMonth = NepaliDateTime.now().month;
  Lang? language;
  late TabController _tabController;
  String? selectedSubSector;
  final int noOfmonths = 132;
  late bool isInflow;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _dateResolver = <NepaliDateTime>[];

  @override
  void initState() {
    super.initState();
    language = Provider.of<PreferenceProvider>(context, listen: false).language;
    isInflow = widget.isInflowProjection ?? false;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if ((await showDialog(
                context: context,
                builder: (context) => Consumer<PreferenceProvider>(
                  builder: (context, value, child) => CategoryDialog(
                    isCashIn: widget.isInflowProjection!,
                  ),
                ),
              )) ??
              false) {
            setState(() {});
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),
        backgroundColor: Configuration().secondaryColor,
      ),
      appBar: AppBar(
        title: AdaptiveText(
          TextModel('Cash ' + (isInflow ? 'Inflow' : 'Outflow') + ' Projection'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              StreamBuilder<double>(
                  stream: AppDatabase().myDatabase.budgetDao.getCumulativeBudgetProjectionUptoDateTime(NepaliDateTime(year, month)),
                  builder: (context, snapshot) {
                    print(snapshot.error.toString());
                    final value = snapshot.data ?? 0.0;
                    return Column(
                      children: [
                        AdaptiveText(
                          TextModel('Cumulative Cash Projection'),
                          style: TextStyle(
                            fontSize: 17,
                            color: Configuration().secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          (value == 0
                                  ? ''
                                  : value.isNegative
                                      ? '-'
                                      : '+') +
                              ' ' +
                              nepaliNumberFormatter(value.abs()),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: value == 0
                                ? Configuration().secondaryColor
                                : value.isNegative
                                    ? Configuration().expenseColor
                                    : Configuration().incomeColor,
                          ),
                        ),
                      ],
                    );
                  }),
              Divider(),
              Expanded(
                child: StreamBuilder<List<BudgetModel>>(
                  stream: AppDatabase().myDatabase.budgetDao.getBudgetProjectionByMonth(widget.isInflowProjection ?? false, NepaliDateTime(year, month)),
                  builder: ((context, snapshot) {
                    print(snapshot.error.toString());

                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return centerHintText(text: 'Categories Not Found');
                      }
                      final groupedBudgetData = snapshot.data!.groupBy((p0) => p0.categoryHeadingId);
                      final keys = groupedBudgetData.keys.toList();
                      return ListView.separated(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 20),
                          itemBuilder: (context, index) {
                            final currentData = groupedBudgetData[keys[index]]!;

                            return _categoryHeadingCategories(TextModel(currentData.first.categoryHeadingName, nepaliName: currentData.first.categoryHeadingNepaliName), currentData, year, month);
                          },
                          separatorBuilder: (context, _) => SizedBox(height: 20.0),
                          itemCount: keys.length);
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