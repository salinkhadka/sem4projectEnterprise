import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/drawer.dart';
import 'package:byaparlekha/components/extra_componenets.dart';
import 'package:byaparlekha/components/screen_size_config.dart';
import 'package:byaparlekha/config/globals.dart';
import 'package:byaparlekha/config/routes/routes.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/icons/vector_icons.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/models/transactionSummary.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:byaparlekha/services/http_service.dart';
import 'package:byaparlekha/services/local_notification_service.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../config/configuration.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Lang language = Lang.EN;
  String? selectedSubSector;
  TabController? _tabController;
  int _currentYear = NepaliDateTime.now().year;
  int _currentMonth = NepaliDateTime.now().month;
  final int noOfmonths = 132;
  var _dateResolver = <NepaliDateTime>[];
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> showCashInCashOut = ValueNotifier(true);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    HttpService().init(context);
    initializeDateResolver();
    LocalNotificationService.initialize();
    _tabController = TabController(
      length: noOfmonths,
      vsync: this,
      initialIndex: _currentMonth - 1,
    );
  }

  initializeDateResolver() {
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController!.dispose();
    _dateResolver.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitApplication();
        return false;
      },
      child: Consumer<PreferenceProvider>(builder: (context, data, _) {
        language = data.language;
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Configuration().appColor,
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  kAppName,
                  style: TextStyle(
                    fontSize: 17,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // actions: [
            //   if (Platform.isAndroid)
            //     IconButton(
            //       onPressed: () {
            //         exitApplication();
            //       },
            //       icon: Icon(Icons.exit_to_app),
            //     )
            // ],
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
                        NepaliDateTime(
                          _dateResolver[index].year,
                          _dateResolver[index].month,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          drawer: MyDrawer(homePageState: this),
          body: TabBarView(
            controller: _tabController,
            children: [
              for (int index = 0; index < noOfmonths; index++)
                _buildBody(_dateResolver[index]),
            ],
          ),
        );
      }),
    );
  }

  exitApplication() {
    if (Platform.isAndroid)
      showDeleteDialog(context,
          title: 'Confirm Exit',
          deleteButtonText: 'Exit  ',
          description: 'Do you want to exit this application?',
          onDeletePress: () {
        SystemNavigator.pop(animated: true);
      });
  }

  Widget _buildBody(NepaliDateTime date) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: pageBorderDecoration,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              StreamBuilder<double>(
                  stream: AppDatabase()
                      .myDatabase
                      .accountDao
                      .watchOpeningBalanceTillNow(date.year, date.month),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SizedBox.shrink();
                    final openingBalanceTillNow = snapshot.data ?? 0.0;
                    return StreamBuilder<double>(
                      stream: AppDatabase()
                          .myDatabase
                          .transactionsDao
                          .watchCumulativeCashPosition(date.year, date.month),
                      builder: (context, snapshot) {
                        final value =
                            openingBalanceTillNow + (snapshot.data ?? 0.0);
                        return Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            AdaptiveText(
                              TextModel('Cumulative Cash Position'),
                              style: TextStyle(
                                fontSize: 17,
                                color: Configuration().secondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${(value == 0 ? '' : value.isNegative ? "-" : "+")} ${nepaliNumberFormatter(value.abs())}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: value == 0
                                      ? Configuration().secondaryColor
                                      : value.isNegative
                                          ? Configuration().expenseColor
                                          : Configuration().incomeColor),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    );
                  }),
              StreamBuilder<List<TransactionSummary>>(
                  stream: AppDatabase()
                      .myDatabase
                      .transactionsDao
                      .watchTransactionByMonth(
                          NepaliDateTime(date.year, date.month)),
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  ScreenSizeConfig.blockSizeHorizontal * 10,
                              vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              cirularWidget(snapshot.data ?? []),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, Routes.transactionPage,
                                        arguments: {'isIncome': true}),
                                    child: Column(
                                      children: <Widget>[
                                        circularComponent(true),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AdaptiveText(
                                          TextModel('Cash In'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, Routes.transactionPage,
                                        arguments: {'isIncome': false}),
                                    child: Column(
                                      children: <Widget>[
                                        circularComponent(false),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AdaptiveText(
                                          TextModel('Cash out'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          language == Lang.EN
                              ? 'Overview for the month of ${NepaliDateFormat("MMMM").format(date)}'
                              : '${NepaliDateFormat("MMMM", Language.nepali).format(date)} महिनाको विस्तृत सर्वेक्षण',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black,
                              height: 1.4285714285714286,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        Divider(
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        transactionData(snapshot, date)
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget cirularWidget(List<TransactionSummary> data) {
    double income = 0.0;
    double expense = 0.0;
    data.forEach((element) {
      if (element.isIncome) {
        income += element.transaction.amount;
      } else
        expense += element.transaction.amount;
    });
    final bool isExpenseGreater = (expense > income);
    final percentSaved =
        income == 0.0 ? 0.0 : (income - expense) / (income) * 100;
    final cashInMinusCashOut = (income - expense);
    return Center(
      child: GestureDetector(
        onTap: () {
          showCashInCashOut.value = !showCashInCashOut.value;
        },
        child: ValueListenableBuilder<bool>(
            valueListenable: showCashInCashOut,
            builder: (context, vv, aa) {
              return SleekCircularSlider(
                innerWidget: (percentage) => Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: vv
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AdaptiveText(
                                TextModel(
                                  cashInMinusCashOut.isNegative
                                      ? 'Deficit'
                                      : 'Surplus',
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              AutoSizeText(
                                nepaliNumberFormatter(cashInMinusCashOut.abs()),
                                maxFontSize: 22,
                                maxLines: 1,
                                style: TextStyle(
                                  color: cashInMinusCashOut.isNegative
                                      ? Colors.black
                                      : Configuration().incomeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          )
                        : _centerWidget(income, expense),
                  ),
                ),
                initialValue: isExpenseGreater ? 100 : (percentSaved),
                appearance: CircularSliderAppearance(
                  angleRange: 360,
                  startAngle: 270,
                  customWidths: CustomSliderWidths(
                    trackWidth: 10.0,
                    progressBarWidth: 10.0,
                  ),
                  customColors: CustomSliderColors(
                    trackColor:
                        Configuration().circularIndicatorBackgroundColor,
                    progressBarColors: (isExpenseGreater)
                        ? [
                            Configuration().expenseColor,
                            Configuration().expenseColor
                          ]
                        : [
                            Configuration().incomeColor,
                            Configuration().incomeColor
                          ],
                    hideShadow: true,
                  ),
                  infoProperties: InfoProperties(
                    topLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    bottomLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    mainLabelStyle:
                        TextStyle(fontSize: 17.0, color: Colors.black),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget transactionData(
      AsyncSnapshot<List<TransactionSummary>> snapshot, NepaliDateTime date) {
    if (snapshot.hasData) {
      if (snapshot.data!.length == 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 4,
              child: SvgPicture.string(
                noTransactionIcon,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            AdaptiveText(
              TextModel('No Transactions'),
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4285714285714286,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        );
      } else {
        return TransactionList(
            transactionData: snapshot.data!, date: date, language: language);
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _centerWidget(double income, double expense) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AdaptiveText(
          TextModel('Cash In'),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        Text(
          nepaliNumberFormatter(income),
          style: TextStyle(
              color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        AdaptiveText(
          TextModel('Cash Out'),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        AutoSizeText(
          nepaliNumberFormatter(expense),
          maxFontSize: 18.0,
          maxLines: 1,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  circularComponent(bool cashIn) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            cashIn ? Configuration().incomeColor : Configuration().expenseColor,
      ),
      height: 38,
      width: 38,
      child: Center(
        child: Icon((cashIn) ? Icons.add : Icons.remove,
            size: 30, color: Colors.white),
      ),
    );
  }
}

class TransactionList extends StatefulWidget {
  final List<TransactionSummary> transactionData;
  final NepaliDateTime? date;
  final Lang? language;

  TransactionList({this.date, this.language, required this.transactionData});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var _transactionMap = <String, List<TransactionSummary>>{};
  List<bool> _expansionRecords = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    _transactionMap = _buildTransactionMap(widget.transactionData);
    _expansionRecords = List.filled(_transactionMap.length, false);
  }

  @override
  void didUpdateWidget(TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.transactionData.length != oldWidget.transactionData.length) {
    initData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionPanelList(
            elevation: 0,
            // elevation: 0,
            expansionCallback: (index, isExpanded) {
              setState(() {
                _expansionRecords[index] = isExpanded;
              });
            },
            children: _transactionMap.keys.map((e) {
              final int index = _transactionMap.keys.toList().indexOf(e);
              final List<TransactionSummary> data = _transactionMap[e]!;
              double income = 0.0;
              double expense = 0.0;
              data.forEach((x) {
                if (x.isIncome) {
                  income += x.transaction.amount;
                } else {
                  expense += x.transaction.amount;
                }
              });
              return ExpansionPanel(
                backgroundColor: Colors.white,
                highlightColor: Colors.white,
                isExpanded: _expansionRecords[index],
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) => ListTile(
                  tileColor: Colors.white,
                  leading: Chip(
                    label: Text(
                      NepaliDateFormat('yyyy-MM-dd', Language.nepali).format(
                          data.first.transaction.transactionDate
                              .toNepaliDateTime()),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Configuration().secondaryColor,
                  ),
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _aggregate(
                          0,
                          income,
                        ),
                        _aggregate(
                          1,
                          expense,
                        ),
                      ],
                    ),
                  ),
                ),
                body: _dailyTransactionWidget(_transactionMap[e]!),
              );
            }).toList()),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _aggregate(int transactionType, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Material(
            color: (transactionType == 0)
                ? Configuration().incomeColor
                : Configuration().expenseColor,
            shape: CircleBorder(),
            child: SizedBox(
              width: 10.0,
              height: 10.0,
            ),
          ),
          SizedBox(width: 5.0),
          Text(
            nepaliNumberFormatter(amount),
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  getDateTimeFormat(String date) {
    return NepaliDateFormat(
      "dd/MM/EE",
    ).format(NepaliDateTime.parse(NepaliDateTime(
      int.parse(date.split('-').first),
      int.parse(date.split('-')[1]),
      int.parse(date.split('-').last),
    ).toString()));
  }

  Widget _dailyTransactionWidget(List<TransactionSummary> dailyTransactions) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: dailyTransactions.length,
        reverse: true,
        itemBuilder: (context, index) {
          final currentData = dailyTransactions[index];
          return ListTile(
            minLeadingWidth: 0,
            onTap: () async {
              _showTransactionDetail(currentData);
            },
            leading: SvgPicture.asset(
              'assets/images/${currentData.category.iconName}',
              color: currentData.isIncome
                  ? Configuration().incomeColor
                  : Configuration().expenseColor,
              height: 20.0,
              width: 20.0,
            ),
            title: AdaptiveText(
              TextModel(currentData.category.name,
                  nepaliName: currentData.category.nepaliName),
              // category: currentData.data,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Text(
              nepaliNumberFormatter(currentData.transaction.amount),
              style: getTextStyle(dailyTransactions[index]),
            ),
          );
        },
      ),
    );
  }

  Future _showTransactionDetail(TransactionSummary transaction) async {
    await detailDialog(context,
        title: 'Transaction Detail',
        detailWidget: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _detailsRow(
                'Date: ',
                NepaliDateFormat(
                  "MMMM dd, y (EEE)",
                ).format(
                  transaction.transaction.transactionDate.toNepaliDateTime(),
                ),
              ),
              // SizedBox(height: 5.0),
              _detailsRow(
                  'Detail: ', '${transaction.transaction.description ?? ''}'),
              // SizedBox(height: 5.0),
              _detailsRow(
                'Amount: ',
                nepaliNumberFormatter(transaction.transaction.amount),
              ),
              if (transaction.transaction.image != null)
                _detailsRow('Image: ', '',
                    widget: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (c) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: InteractiveViewer(
                              child: Image.file(
                                File(transaction.transaction.image!),
                              ),
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.file(File(transaction.transaction.image!)),
                      ),
                    )),
            ]), onDelete: () {
      Navigator.of(context, rootNavigator: true).pop();
      _deleteTransaction(transaction).then((value) {});
    }, onUpdate: () {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushNamed(context, Routes.transactionPage, arguments: {
        'isIncome': transaction.isIncome,
        'transaction': transaction.transaction
      });
    }, onDialogClosed: (value) {});
  }

  _detailsRow(String title, String value, {Widget? widget}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AdaptiveText(
          TextModel(title),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: const Color(0xff272b37),
            height: 2.1538461538461537,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        if (widget != null)
          widget
        else
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: const Color(0xff272b37),
                height: 2.1538461538461537,
              ),
            ),
          ),
      ],
    );
  }

  TextStyle getTextStyle(TransactionSummary transaction) => TextStyle(
      color: transaction.isIncome
          ? Configuration().incomeColor
          : Configuration().expenseColor,
      fontWeight: FontWeight.bold);

  Map<String, List<TransactionSummary>> _buildTransactionMap(
      List<TransactionSummary> transactions) {
    transactions.sort((a, b) =>
        a.transaction.transactionDate.isAfter(b.transaction.transactionDate)
            ? -1
            : 1);
    final Map<String, List<TransactionSummary>> map = transactions.groupBy(
        (e) =>
            e.transaction.transactionDate.toIso8601String().split('T').first);
    return map;
  }

  Future<bool> _deleteTransaction(TransactionSummary transaction) async {
    final d = await showDeleteDialog(context,
        topIcon: Icons.error_outline,
        description: 'Are you sure you want to delete this transaction?',
        title: 'Delete Transaction', onDeletePress: () async {
      try {
        await AppDatabase()
            .myDatabase
            .transactionsDao
            .deleteTransaction(transaction.transaction.id)
            .catchError((onError) {});
        Navigator.of(context, rootNavigator: true).pop(true);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }, onCancelPress: () {
      Navigator.of(context, rootNavigator: true).pop(false);
    });
    return d;
  }
}
