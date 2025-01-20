import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/customDropDown.dart';
import 'package:byaparlekha/components/extra_componenets.dart';
import 'package:byaparlekha/components/screen_size_config.dart';
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/icons/vector_icons.dart';

import 'package:byaparlekha/models/accountDataModel.dart';

import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/models/valueModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:byaparlekha/screens/account_page.dart';
import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:byaparlekha/widget/addPersonDialog.dart';
import 'package:byaparlekha/widget/addTransactionItemDialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import 'package:provider/provider.dart';

import '../config/configuration.dart';
import '../config/globals.dart';

import '../screens/category_page.dart';

class TransactionPage extends StatefulWidget {
  final bool isIncome;
  final Transaction? transaction;

  TransactionPage({
    required this.isIncome,
    this.transaction,
  });

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Lang language;
  double fontsize = 15.0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  int? _selectedCategoryId;
  File? descriptonImage;
  int? _selectedAccountId;
  bool get isEnglish => language == Lang.EN;

  NepaliDateTime _selectedDateTime = NepaliDateTime.now();
  bool isDailySales = false;
  int? itemSoldToId;
  List<TransactionItemData> transactionItemList = [];
  String? deletedImage;
  List<int> deletedItemListId = [];
  @override
  void initState() {
    language = Provider.of<PreferenceProvider>(context, listen: false).language;
    if (widget.transaction != null) {
      initializeData();
    }
    getCategoryList().then((e) {
      setState(() {});
    });
    super.initState();
  }

  initializeData() async {
    _selectedAccountId = widget.transaction!.accountId;
    _selectedCategoryId = widget.transaction!.categoryId;
    _selectedDateTime = widget.transaction!.transactionDate.toNepaliDateTime();
    _amountController.text = widget.transaction!.amount.toString();
    _descriptionController.text = widget.transaction!.description.toString();
    if (widget.transaction!.image != null && await File(widget.transaction!.image!).exists()) {
      descriptonImage = File(widget.transaction!.image!);
    }
    isDailySales = widget.transaction!.isDailySales;
    if (isDailySales) {
      billNumberController.text = widget.transaction!.billNumber ?? '';
      final data = await AppDatabase().myDatabase.transactionItemDao.getAllByTransactionId(widget.transaction!.id);
      transactionItemList = data;
      if (transactionItemList.isNotEmpty) itemSoldToId = transactionItemList.first.personId;
    }

    setState(() {});
  }

  List<CategoryData> categoryData = [];
  getCategoryList() async {
    await AppDatabase().myDatabase.categoryDao.getCategoryByIncomeExpense(widget.isIncome).then((value) {
      categoryData = value;
      try {
        if (widget.transaction != null) {
          _selectedCategoryHeadingId = (categoryData.firstWhere((element) => element.id == _selectedCategoryId)).categoryHeadingId;
        }
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: Configuration().appColor,
        title: widget.transaction != null
            ? AdaptiveText(
                TextModel('Update ${widget.isIncome ? 'Cash Inflow' : 'Cash Outflow'}'),
                style: TextStyle(fontSize: 17),
              )
            : AdaptiveText(
                TextModel('Add ${widget.isIncome ? 'Cash Inflow' : 'Cash Outflow'}'),
                style: TextStyle(fontSize: 17),
              ),
      ),
      body: Stack(
        children: [
          Container(
            height: ScreenSizeConfig.blockSizeHorizontal * 50,
            color: Configuration().appColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                padding: const EdgeInsets.only(top: 30),
                child: _buildBody()),
          ),
        ],
      ),
    );
  }

  int? _selectedCategoryHeadingId = null;
  incomeExpenseCategoryWidget() {
    return CustomDropDown(
      selectedValue: _selectedCategoryId,
      validator: Validators.dropDownFieldValidator,
      hintText: 'Select Category',
      allowValueAddition: true,
      onValueSelected: (value) {
        if (value == -1) {
          _showAddCategoryBottomSheet();
          return;
        }
        try {
          _selectedCategoryHeadingId = (categoryData.firstWhere((element) => element.id == value)).categoryHeadingId;
        } catch (e) {}
        isDailySales = false;
        itemSoldToId = null;
        billNumberController.clear();
        transactionItemList = [];
        setState(() {
          _selectedCategoryId = value;
        });
      },
      values: categoryData
          .map(
            (e) => ValueModel(id: e.id, name: e.name, nepaliName: e.nepaliName, iconData: e.iconName == null ? Icon(kDefaultIconData) : SvgPicture.asset('assets/images/${e.iconName}')),
          )
          .toList(),
    );
    return FutureBuilder<List<CategoryData>>(
      future: AppDatabase().myDatabase.categoryDao.getCategoryByIncomeExpense(widget.isIncome),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (widget.transaction != null) {
            _selectedCategoryHeadingId = ((snapshot.data ?? []).firstWhere((element) => element.id == widget.transaction!.id)).categoryHeadingId;
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  bool get showDailySales => [1, 4].contains(_selectedCategoryHeadingId);
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AdaptiveText(TextModel((!widget.isIncome) ? 'Cash Outflow Amount' : 'Business Cash Inflow'), style: TextStyle(fontSize: fontsize, color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: Validators.emptyFieldValidator,
                autofocus: false,
                enabled: !isDailySales,
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(color: Colors.grey[800], fontSize: fontsize),
                decoration: InputDecoration(
                  hintText: language == Lang.EN ? 'Enter amount' : 'रकम लेख्नुहोस',
                ),
              ),
              seperator(),
              AdaptiveText(TextModel((!widget.isIncome) ? 'Cash Outflow Category' : 'Source of Cash Inflow'), style: TextStyle(fontSize: fontsize, color: Colors.black)),
              SizedBox(
                height: 5,
              ),
              incomeExpenseCategoryWidget(),
              if (showDailySales) seperator(height: 15),
              if (showDailySales) dailySalesWidget(),
              seperator(height: 15),
              IgnorePointer(
                ignoring: widget.transaction != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (language == Lang.EN)
                      Text(
                        widget.isIncome ? 'Deposit to:  ' : 'Paid from:  ',
                        style: TextStyle(fontSize: fontsize, color: Colors.black),
                      ),
                    if (language == Lang.EN)
                      SizedBox(
                        height: 5,
                      ),
                    FutureBuilder<List<AccountDataModel>>(
                      future: AppDatabase().myDatabase.accountDao.getAccountWithIcon(),
                      builder: (context, snapshot) {
                        return CustomDropDown(
                            allowValueAddition: true,
                            hintText: 'Select Account',
                            validator: Validators.dropDownFieldValidator,
                            selectedValue: _selectedAccountId,
                            onValueSelected: (value) async {
                              if (value == -1) {
                                value = await _showAddAccountBottomSheet();
                                await getCategoryList();
                              }
                              setState(() {
                                _selectedAccountId = value;
                              });
                            },
                            values: (snapshot.data ?? [])
                                .map((e) => ValueModel(
                                      id: e.id,
                                      name: e.name,
                                      nepaliName: e.nepaliName,
                                      iconData: Icon(
                                        VectorIcons.fromName(e.iconName ?? 'hornbill', provider: IconProvider.FontAwesome5),
                                        color: Configuration().appColor,
                                        size: 25,
                                      ),
                                    ))
                                .toList());
                      },
                    ),
                    if (language == Lang.NP)
                      SizedBox(
                        height: 5,
                      ),
                    if (language == Lang.NP)
                      Text(
                        widget.isIncome ? 'मा जम्मा गरियो ' : 'बाट तिरिएको',
                        style: TextStyle(fontSize: fontsize, color: Colors.black),
                      ),
                  ],
                ),
              ),
              seperator(),
              AdaptiveText(TextModel((!widget.isIncome) ? 'Date of Outflow' : 'Date of Inflow'), style: TextStyle(fontSize: fontsize, color: Colors.black)),
              SizedBox(height: 5.0),
              Material(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    final value = await showMaterialDatePicker(
                        context: context,
                        initialDate: _selectedDateTime,
                        firstDate: NepaliDateTime(2073),
                        lastDate: NepaliDateTime(2090),
                        builder: (context, child) {
                          return Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.light(primary: Color(0xffe13d00)),
                              ),
                              child: child!);
                        });
                    if (value != null) {
                      setState(() {
                        _selectedDateTime = value;
                      });
                    }
                  },
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    child: Row(
                      children: <Widget>[
                        Text(
                          NepaliDateFormat(
                            "MMMM dd, y (EE)",
                          ).format(_selectedDateTime),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: fontsize,
                          ),
                        ),
                        Expanded(child: Container()),
                        SvgPicture.string(
                          calendarIcon,
                          allowDrawingOutsideViewBox: true,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              seperator(),
              AdaptiveText(TextModel('Description (Optional)'), style: TextStyle(fontSize: fontsize, color: Colors.black)),
              SizedBox(height: 5.0),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.grey[800], fontSize: fontsize),
                decoration: InputDecoration(
                  // suffixIconConstraints:
                  //     BoxConstraints(maxWidth: 40, maxHeight: 40),
                  suffixIcon: imageBuilder(descriptonImage, (file) {
                    setState(() {
                      descriptonImage = file;
                    });
                  }, () {
                    if (widget.transaction?.image != null) {
                      deletedImage = widget.transaction!.image;
                    }
                    setState(() {
                      descriptonImage = null;
                    });
                  }),
                  border: InputBorder.none,
                  hintText: (!widget.isIncome)
                      ? language == Lang.EN
                          ? 'Enter description (Optional)'
                          : 'खर्च सम्बन्धि थप विवरण भए लेखुहोस्'
                      : language == Lang.EN
                          ? 'Enter description (Optional)'
                          : 'खर्च सम्बन्धि थप विवरण भए लेखुहोस्',
                  counterStyle: TextStyle(color: Colors.grey),
                ),
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => Container(
                  height: 1,
                  width: 1,
                ),
                maxLines: 4,
                maxLength: 80,
              ),
              SizedBox(height: 25.0),
              Center(
                child: TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    if (_formKey.currentState!.validate()) {
                      if (isDailySales) {
                        if (transactionItemList.isEmpty) {
                          showSnackBar(context, 'Atleast one item is required');
                          return;
                        }
                      }
                      TransactionsCompanion transaction = TransactionsCompanion(
                        id: widget.transaction == null ? Value.absent() : Value<int>(widget.transaction!.id),
                        accountId: Value<int>(_selectedAccountId!),
                        categoryId: Value<int>(_selectedCategoryId!),
                        isDailySales: Value<bool>(isDailySales),
                        billNumber: Value<String?>(billNumberController.text),
                        transactionDate: Value<DateTime>(_selectedDateTime.toDateTime()),
                        amount: Value<double>(double.parse(_amountController.text)),
                        createdDate: widget.transaction?.createdDate == null ? Value.absent() : Value<DateTime>(widget.transaction!.createdDate),
                        modifiedDate: widget.transaction?.modifiedDate == null ? Value.absent() : Value<DateTime>(DateTime.now()),
                        description: Value<String?>(_descriptionController.text),
                      );
                      widget.transaction == null ? _addTransaction(transaction) : _updateTransaction(transaction);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                        widget.transaction == null
                            ? (language == Lang.EN)
                                ? 'SUBMIT'
                                : 'बुझाउनुहोस्'
                            : (language == Lang.EN)
                                ? 'UPDATE'
                                : 'अद्यावधिक गर्नुहोस्',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0, color: Colors.white)),
                  ),
                ),
              ),
              seperator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget seperator({double? height}) {
    return SizedBox(
      height: height ?? 20,
    );
  }

  removeTransactionItem(TransactionItemData data) {
    if (data.id > 0) deletedItemListId.add(data.id);
    _amountController.text = ((double.tryParse(_amountController.text) ?? 0.0) - data.amount).toString();
    transactionItemList.remove(data);
  }

  addTransactionItem(TransactionItemData data) {
    transactionItemList.add(data);
    _amountController.text = ((double.tryParse(_amountController.text) ?? 0.0) + data.amount).toString();
  }

  Widget dailySalesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isDailySales = !isDailySales;
              _amountController.clear();
              if (!isDailySales) {
                itemSoldToId = null;
                billNumberController.clear();
                transactionItemList = [];
                if (widget.transaction != null) {
                  for (TransactionItemData data in transactionItemList) {
                    removeTransactionItem(data);
                  }
                }
              }
            });
          },
          child: Row(
            children: [
              AbsorbPointer(
                absorbing: true,
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Checkbox(
                    value: isDailySales,
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              AdaptiveText(
                TextModel(widget.isIncome ? 'Is Daily Sales' : 'Is Daily Purchase'),
              ),
            ],
          ),
        ),
        if (isDailySales)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              seperator(),
              AdaptiveText(TextModel(widget.isIncome ? 'Item Sold to' : 'Item Bought From'), style: TextStyle(fontSize: fontsize, color: Colors.black)),
              seperator(height: 5),
              FutureBuilder<List<PersonData>>(
                future: AppDatabase().myDatabase.personDao.getAll(),
                builder: (context, snapshot) {
                  return CustomDropDown(
                    hintText: widget.isIncome ? 'Select Customer' : 'Select Seller',
                    selectedValue: itemSoldToId,
                    validator: Validators.dropDownFieldValidator,
                    onValueSelected: (value) {
                      if (value == -1) {
                        itemSoldToId = null;
                        setState(() {});
                        showDialog(
                            context: context,
                            builder: (cot) => AddPersonDialog(onUserAddSuccess: (value) {
                                  setState(() {
                                    itemSoldToId = value;
                                  });
                                }));
                        return;
                      }
                      itemSoldToId = value;
                      setState(() {});
                    },
                    values: (snapshot.data ?? []).map((e) => ValueModel(id: e.id, name: e.name, nepaliName: e.name)).toList(),
                    allowValueAddition: true,
                  );
                },
              ),
              ListTile(
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          AdaptiveText(
                            TextModel('Number of items'),
                          ),
                          AdaptiveText(
                            TextModel(' (${nepaliNumberFormatter(transactionItemList.length)})'),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showDialog(
                            context: context,
                            builder: (context) => AddTransactionItemDialog(onItemAdd: (item) {
                                  addTransactionItem(item);
                                  setState(() {});
                                }));
                      },
                      child: CircleAvatar(
                        backgroundColor: Configuration().appColor,
                        radius: 13,
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ...transactionItemList.map(
                (e) => Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Configuration().buttonColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<ItemData>(
                                future: AppDatabase().myDatabase.itemDao.getById(e.itemId),
                                builder: ((context, snapshot) => Text(
                                      '${snapshot.data?.name} (${nepaliNumberFormatter(e.quantity)})',
                                    ))),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(text: (language == Lang.NP) ? 'Amount' : 'रकम'),
                                  TextSpan(
                                    text: ': ' + nepaliNumberFormatter(e.amount),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      IconButton(
                        onPressed: () {
                          removeTransactionItem(e);
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              seperator(),
              AdaptiveText(TextModel('Invoice Number'), style: TextStyle(fontSize: fontsize, color: Colors.black)),
              seperator(height: 5),
              TextFormField(
                controller: billNumberController,
                validator: widget.isIncome ? Validators.emptyFieldValidator : null,
              )
            ],
          )
      ],
    );
  }

  Widget imageBuilder(File? file, onSelect(File file), Function() onRemove) {
    return Container(
      height: 60,
      width: 60,
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<int>(
          tooltip: isEnglish ? 'Attach Image' : 'छवि संलग्न गर्नुहोस्',
          itemBuilder: (context) => [
            PopupMenuItem(
              child: AdaptiveText(TextModel('Open Camera')),
              value: 1,
            ),
            PopupMenuItem(
              child: AdaptiveText(TextModel('Choose Gallery image')),
              value: 2,
            ),
            if (file != null)
              PopupMenuItem(
                child: AdaptiveText(TextModel('Remove Photo')),
                value: 3,
              ),
          ],
          onSelected: (value) async {
            switch (value) {
              case 1:
              case 2:
                final img = await ImagePicker().pickImage(
                  source: value == 2 ? ImageSource.gallery : ImageSource.camera,
                  imageQuality: 30,
                );
                if (img != null) {
                  onSelect(File(img.path));
                }
                break;
              default:
                {
                  onRemove();
                }
            }
          },
          child: file == null ? Icon(Icons.attach_file) : Image.file(file),
        ),
      ),
    );
  }

  Future<void> _addTransaction(TransactionsCompanion transactionsCompanion) async {
    String? imageDir;

    if (descriptonImage != null) {
      try {
        imageDir = (await Configuration().saveImage(descriptonImage!, 'transaction')).path;
      } catch (e) {
        ScaffoldMessenger.of(_scaffoldKey.currentState!.context).removeCurrentSnackBar();
        showSnackBar(
          context,
          'Error, Image cannot be uploaded',
        );
        return;
      }
    }
    final transaction = transactionsCompanion.copyWith(image: Value<String?>(imageDir));
    try {
      if (isDailySales) {
        await AppDatabase().myDatabase.transactionsDao.insertDataWithDailySales(transaction, transactionItemList, itemSoldToId!);
      } else {
        await AppDatabase().myDatabase.transactionsDao.insertData(transaction);
      }
      Navigator.pop(context, true);
    } catch (e) {
      if (imageDir != null) {
        File(imageDir).delete().catchError((onError) {});
      }
      showSnackBar(context, e.toString());
    }
  }

  Future _updateTransaction(TransactionsCompanion transactionsCompanion) async {
    try {
      String? imageDir = widget.transaction?.image;
      if (widget.transaction?.image != descriptonImage?.path) {
        imageDir = null;
        if (descriptonImage != null) {
          try {
            imageDir = (await Configuration().saveImage(descriptonImage!, 'transaction')).path;
          } catch (e) {
            ScaffoldMessenger.of(_scaffoldKey.currentState!.context).removeCurrentSnackBar();
            showSnackBar(
              context,
              'Error, Image cannot be uploaded',
            );
            return;
          }
        }
      }
      final transaction = transactionsCompanion.copyWith(image: Value<String?>(imageDir));
      if (isDailySales) {
        await AppDatabase().myDatabase.transactionsDao.updateDataWithDailySales(transaction, transactionItemList, deletedItemListId, itemSoldToId!);
      } else {
        await AppDatabase().myDatabase.transactionsDao.updateData(transaction);
      }
      Navigator.pop(context, true);
      if (deletedImage != null && await File(deletedImage!).exists()) {
        await File(deletedImage!).delete().catchError((onError) {});
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future _showAddCategoryBottomSheet() async {
    if ((await showDialog(
          context: context,
          builder: (context) => Consumer<PreferenceProvider>(
            builder: (context, a, b) => CategoryDialog(
              isCashIn: widget.isIncome,
            ),
          ),
        )) ??
        false) {
      setState(() {});
    }
  }

  Future<int?> _showAddAccountBottomSheet() async {
    return await showDialog(
      context: context,
      builder: (context) => Consumer<PreferenceProvider>(
        builder: (context, a, b) => AccountDialog(),
      ),
    );
  }
}
