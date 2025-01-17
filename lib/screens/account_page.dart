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

  void _deleteDialog(AccountDataModel account) {
    showDeleteDialog(context, title: 'Delete Account', deleteButtonText: 'Delete', onDeletePress: () async {
      try {
        await AppDatabase().myDatabase.accountDao.deleteAccount(account.id);
        Navigator.of(context, rootNavigator: true).pop(true);
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop(true);
        showSnackBar(context, e.toString());
      }
    }, description: 'Are you sure you want to delete this account?');
  }
}

Widget getBankAccountTypeIcon(int? accountTypeId, {bool isForm = false}) {
  switch (accountTypeId) {
    case 3:
      return Icon(
        VectorIcons.fromName('user-tie', provider: IconProvider.FontAwesome5),
        color: Configuration().accountIconColor,
        size: isForm ? 18 : 25,
      );
    case 1:
      return Icon(
        VectorIcons.fromName('university', provider: IconProvider.FontAwesome5),
        color: Configuration().accountIconColor,
        size: isForm ? 18 : 25,
      );
    case 2:
      return SvgPicture.string(
        cashIcon,
        fit: BoxFit.fill,
        height: isForm ? 14 : null,
        allowDrawingOutsideViewBox: false,
      );
    default:
      return Icon(
        VectorIcons.fromName('wallet', provider: IconProvider.FontAwesome5),
        color: Configuration().accountIconColor,
        size: isForm ? 18 : 25,
      );
  }
}

class AccountDialog extends StatefulWidget {
  final AccountDataModel? accountDataModel;
  const AccountDialog({
    Key? key,
    this.accountDataModel,
  }) : super(key: key);

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  late final AccountDataModel? accountDataModel;
  int? _accountType = 1;
  var _accountNameController = TextEditingController();
  var _openingBalanceController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  List<AccountTypeData> accounts = [];
  Lang? language;
  int popId = 0;
  DateTime? openingBalanceDate;
  @override
  void initState() {
    accountDataModel = widget.accountDataModel;
    if (accountDataModel != null) {
      _accountType = accountDataModel!.accountTypeId;

      _accountNameController.text = accountDataModel!.name;
      _openingBalanceController.text = accountDataModel!.balance.toString();
      openingBalanceDate = accountDataModel!.openingBalanceDate;
    }
    AppDatabase().myDatabase.accountTypeDao.getAll().then((value) {
      accounts = value;
      accounts.removeWhere((e) => e.id == 2);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    language = Provider.of<PreferenceProvider>(context).language;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 23),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (accountDataModel?.isSystem == false || accountDataModel == null) ...[
                          Row(
                            children: <Widget>[
                              SvgPicture.string(
                                userLogo,
                                allowDrawingOutsideViewBox: true,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              AdaptiveText(
                                TextModel('Account Type'),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xff43425d),
                                  height: 1.5625,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomDropDown(
                              selectedValue: _accountType,
                              onValueSelected: (value) {
                                setState(() {
                                  _accountType = value;
                                });
                              },
                              values: accounts
                                  .map(
                                    (e) => ValueModel(
                                      id: e.id,
                                      name: e.name,
                                      nepaliName: e.nepaliName,
                                      iconData: Icon(VectorIcons.fromName(e.iconName ?? 'hornbill', provider: IconProvider.FontAwesome5)),
                                    ),
                                  )
                                  .toList()),
                        ],
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.string(
                              userLogo,
                              allowDrawingOutsideViewBox: true,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AdaptiveText(
                              TextModel('Enter Account Name'),
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff43425d),
                                height: 1.5625,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: Validators.emptyFieldValidator,
                          controller: _accountNameController,
                          style: TextStyle(color: Colors.grey[800], fontSize: 20.0),
                          decoration: InputDecoration(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            SvgPicture.string(
                              loadingIcon,
                              allowDrawingOutsideViewBox: true,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AdaptiveText(
                              TextModel('Opening Balance Date'),
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff43425d),
                                height: 1.5625,
                              ),
                            ),
                          ],
                        ),
                        dateField(dateTime: openingBalanceDate),
                        formSeperator(),
                        Row(
                          children: <Widget>[
                            SvgPicture.string(
                              loadingIcon,
                              allowDrawingOutsideViewBox: true,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AdaptiveText(
                              TextModel('Enter Opening Balance'),
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff43425d),
                                height: 1.5625,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      validator: Validators.doubleValidator,
                      // (value) => value!.isEmpty
                      //     ? language == Lang.EN
                      //         ? 'Balance Cannot be Empty'
                      //         : 'ब्यालेन्स खाली हुन सक्दैन'
                      //     : null,
                      decoration: InputDecoration(),
                      controller: _openingBalanceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(color: Colors.grey[800], fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              TextButton.icon(
                icon: Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Configuration().incomeColor),
                ),
                onPressed: accountDataModel == null ? _addAccount : _updateAccount,
                label: AdaptiveText(
                  TextModel(accountDataModel == null ? 'Add Account' : "Update Account"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  void _addAccount() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState!.validate()) {
      try {
        final int id = await AppDatabase().myDatabase.accountDao.insertData(
              AccountCompanion(
                accountTypeId: Value<int>(_accountType!),
                balance: Value<double>(double.parse(_openingBalanceController.text)),
                name: Value<String>(_accountNameController.text),
                nepaliName: Value<String>(_accountNameController.text),
                openingBalanceDate: Value<DateTime?>(this.openingBalanceDate),
              ),
            );
        Navigator.pop(context, id);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }

  void _updateAccount() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState!.validate()) {
      try {
        await AppDatabase().myDatabase.accountDao.updateData(
              AccountCompanion(
                accountTypeId: Value<int>(_accountType!),
                balance: Value<double>(double.parse(_openingBalanceController.text)),
                name: Value<String>(_accountNameController.text),
                nepaliName: Value<String>(_accountNameController.text),
                id: Value<int>(accountDataModel!.id),
                openingBalanceDate: Value<DateTime?>(this.openingBalanceDate),
                isSystem: Value<bool>(accountDataModel!.isSystem),
              ),
            );
        Navigator.pop(context);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }

  dateField({
    bool isBsDate = false,
    String title = "",
    required DateTime? dateTime,
  }) {
    return PopupMenuButton(
        color: Colors.white,
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: ListTile(
                  title: AdaptiveText(
                    TextModel('B.S Date Picker'),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  title: AdaptiveText(
                    TextModel('A.D Date Picker'),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
        onCanceled: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        onSelected: (dynamic id) async {
          FocusScope.of(context).requestFocus(new FocusNode());
          DateTime date = DateTime(1910);
          popId = id;
          if (id == 0) {
            NepaliDateTime? date1 = await showMaterialDatePicker(
              context: context,
              currentDate: dateTime?.toNepaliDateTime(),
              builder: (context, child) {
                return Theme(data: ThemeData(primaryColor: Colors.orange, primarySwatch: Colors.orange), child: child!);
              },
              initialDate: NepaliDateTime.now(),
              firstDate: date.toNepaliDateTime(),
              lastDate: NepaliDateTime.now(),
            );
            if (date1 != null) {
              this.openingBalanceDate = date1.toDateTime();
            }
          } else {
            final date1 = await showDatePicker(
                context: context,
                currentDate: dateTime,
                builder: (context, child) {
                  return Theme(data: ThemeData(primaryColor: Colors.orange, primarySwatch: Colors.orange), child: child!);
                },
                initialDate: DateTime.now(),
                firstDate: date,
                lastDate: DateTime.now());
            if (date1 != null) {
              this.openingBalanceDate = date1;
            }
          }
          setState(() {});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText(TextModel("$title")),
            InputDecorator(
                decoration: InputDecoration(
                    suffixIcon: Icon(
                  Icons.calendar_month,
                  color: Configuration().secondaryColor,
                )
                    // hintText: 'Date of Birth',
                    ),
                isEmpty: dateTime == null,
                child: dateTime == null
                    ? null
                    : Text(
                        (popId == 0)
                            ? NepaliDateFormat(
                                "MMMM dd, y (EEE)",
                              ).format(dateTime.toNepaliDateTime())
                            : DateFormat("MMMM dd, y (EEEE)").format(dateTime),
                      )),
          ],
        ));
  }
}
