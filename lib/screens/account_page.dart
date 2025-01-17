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

  Widget _buildBody() {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: StreamBuilder<List<AccountDataModel>>(
              stream: AppDatabase().myDatabase.accountDao.watchAccountInformation(),
              builder: (context, snapshot) {
                final List<AccountDataModel> _accounts = snapshot.data ?? [];
                final double totalBalance = _accounts.fold<double>(0.0, (value, data) {
                  return value = value + data.incomeExpenseAmount + data.balance;
                });
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                        ),
                        color: const Color(0xff7635c7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AdaptiveText(
                              TextModel('Current Balance'),
                              style: TextStyle(
                                fontSize: 20,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  _formatBalanceWithComma(totalBalance),
                                  style: TextStyle(
                                    fontSize: 31,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: AdaptiveText(
                                    TextModel('NPR'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xffb182ec),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (snapshot.hasData)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _accounts.length,
                        itemBuilder: (context, _index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                ),
                                color: const Color(0xffffffff),
                              ),
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    VectorIcons.fromName(_accounts[_index].iconName ?? 'hornbill', provider: IconProvider.FontAwesome5),
                                    color: Configuration().accountIconColor,
                                    size: 25,
                                  ),
                                  // child:
                                ),
                                title: AdaptiveText(
                                  TextModel(_accounts[_index].name, nepaliName: _accounts[_index].nepaliName),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff272b37),
                                    height: 1.4285714285714286,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                subtitle: FutureBuilder(
                                    future: AppDatabase().myDatabase.accountTypeDao.getById(_accounts[_index].accountTypeId),
                                    builder: ((context, snapshot) => snapshot.hasData
                                        ? AdaptiveText(
                                            TextModel(snapshot.data!.name, nepaliName: snapshot.data!.nepaliName),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.left,
                                          )
                                        : SizedBox.shrink())),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      _formatBalanceWithComma(_accounts[_index].balance + _accounts[_index].incomeExpenseAmount),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: const Color(0xff1e1e1e),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    PopupMenuButton<int>(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.grey,
                                      ),
                                      onSelected: (value) async {
                                        if (value == 1) {
                                          _deleteDialog(_accounts[_index]);
                                        } else {
                                          await showDialog(
                                            context: context,
                                            builder: (context) => ChangeNotifierProvider<PreferenceProvider>(
                                              create: ((context) => PreferenceProvider()),
                                              child: AccountDialog(accountDataModel: _accounts[_index]),
                                            ),
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(value: 2, child: AdaptiveText(TextModel("Edit"))),
                                        if (!_accounts[_index].isSystem)
                                          PopupMenuItem(
                                            value: 1,
                                            child: AdaptiveText(
                                              TextModel('Delete'),
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Center(
                        child: CircularProgressIndicator(),
                      )
                  ],
                );
              }),
        ),
      );
    }

    String _formatBalanceWithComma(double balance) {
        if (balance.isNegative) {
          return '-' +
              nepaliNumberFormatter(
                balance.abs(),
              );
        } else
          return nepaliNumberFormatter(balance, decimalDigits: 2);
      }