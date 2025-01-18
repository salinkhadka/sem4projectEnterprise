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