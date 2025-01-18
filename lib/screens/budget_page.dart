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

  Widget _categoryHeadingCategories(TextModel textModel, List<BudgetModel> budgetModel, int year, int month) {
    final calculatedData = budgetModel.reduce((value, element) => BudgetModel(
        budget: (value.budget ?? 0.0) + (element.budget ?? 0.0),
        amount: (value.amount ?? 0.0) + (element.amount ?? 0.0),
        categoryName: '',
        categoryNepaliName: '',
        categoryHeadingName: value.categoryHeadingName,
        categoryHeadingId: value.categoryHeadingId,
        categoryId: 0));
    budgetModel.sort((a, b) => a.categoryName.toLowerCase().compareTo(b.categoryName.toLowerCase()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AdaptiveText(
                textModel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              nepaliNumberFormatter(calculatedData.budget ?? 0.0),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: getColor(isInflow, calculatedData.budget ?? 0.0, calculatedData.amount ?? 0.0),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildCard(budgetModel[index], year, month);
            },
            separatorBuilder: (context, _) => SizedBox(height: 20.0),
            itemCount: budgetModel.length),
      ],
    );
  }

  Widget _buildCard(BudgetModel budgetModel, int year, int month) {
    return PopupMenuButton<int>(
      color: Colors.white,
      onSelected: (value) async {
        if (value == 1) {
          _setBudgetDialog(budgetModel, year, month, action: budgetModel.id == null ? 'set' : 'update');
        } else {
          _clearBudgetDialog(budgetModel, year, month);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: AdaptiveText(
            TextModel(budgetModel.id == null ? 'Set Budget' : 'Update Budget'),
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        if (budgetModel.id != null)
          PopupMenuItem(
            value: 2,
            child: AdaptiveText(
              TextModel('Clear Budget'),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
      ],
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              30,
            ),
            border: Border.all(color: Configuration().borderColor)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (budgetModel.categoryIcon == null)
              Icon(
                VectorIcons.fromName(
                  'hornbill',
                  provider: IconProvider.FontAwesome5,
                ),
                color: Configuration().incomeColor,
                size: 20.0,
              )
            else
              SvgPicture.asset('assets/images/${budgetModel.categoryIcon}'),
            SizedBox(width: 15.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AdaptiveText(
                    TextModel(budgetModel.categoryName, nepaliName: budgetModel.categoryNepaliName),
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                  ),
                  SizedBox(height: 2.0),
                  AdaptiveText(
                    TextModel((budgetModel.id == null) ? 'Touch to set' : 'Touch to update'),
                    style: TextStyle(fontSize: 11.0, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Text(
              nepaliNumberFormatter(budgetModel.budget ?? 0.0),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: getColor(isInflow, budgetModel.budget ?? 0.0, budgetModel.amount ?? 0.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(bool isInflow, double projectedBalance, double actualBalance) {
    return Configuration().secondaryColor;
    final List<Color> colors = [Configuration().incomeColor, Configuration().expenseColor];
    if (actualBalance == projectedBalance) {
      return Configuration().secondaryColor;
    }
    if (actualBalance > projectedBalance) {
      return isInflow ? colors[0] : colors[1];
    } else {
      return isInflow ? colors[1] : colors[0];
    }
  }

  double getProgressValue(String spent, String total) {
    int _total = int.tryParse(total) ?? 0;
    int _spent = int.tryParse(spent) ?? 0;
    if (_total == 0 && _spent == 0) return 1;
    if (_spent > _total) return 2;
    if (_total != 0 && _spent != 0) {
      return _spent / _total;
    }
    return 0.0;
  }