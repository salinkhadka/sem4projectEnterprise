import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';

import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/customDropDown.dart';
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/accountDataModel.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/models/valueModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';

import '../components/extra_componenets.dart';
import '../config/configuration.dart';
import '../config/globals.dart';
import '../icons/vector_icons.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Lang? language;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, preferenceProvider, _) {
        language = preferenceProvider.language;
        return Scaffold(
          backgroundColor: Configuration().appColor,
          key: _scaffoldKey,
          appBar: AppBar(
            title: AdaptiveText(
              TextModel('Accounts'),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            splashColor: const Color(0xff7635c7),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => ChangeNotifierProvider<PreferenceProvider>(
                  create: ((context) => PreferenceProvider()),
                  child: AccountDialog(),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 33,
              color: Configuration().appColor,
            ),
            backgroundColor: Colors.white,
          ),
          body: _buildBody(),
        );
      },
    );
  }