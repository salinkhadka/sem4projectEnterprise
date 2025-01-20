import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/customDropDown.dart';
import 'package:byaparlekha/components/extra_componenets.dart';
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/models/valueModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:byaparlekha/widget/addItemDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionItemDialog extends StatefulWidget {
  final Function(TransactionItemData) onItemAdd;
  const AddTransactionItemDialog({super.key, required this.onItemAdd});
  @override
  _AddTransactionItemDialogState createState() => _AddTransactionItemDialogState();
}

class _AddTransactionItemDialogState extends State<AddTransactionItemDialog> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  int? itemId;
  var _formKey = GlobalKey<FormState>();
  late final Lang language;
  @override
  void initState() {
    language = Provider.of<PreferenceProvider>(context, listen: false).language;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 23),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AdaptiveText(
                  TextModel('Item'),
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff43425d),
                    height: 1.5625,
                  ),
                ),
                FutureBuilder<List<ItemData>>(
                  future: AppDatabase().myDatabase.itemDao.getAll(),
                  builder: (context, snapshot) {
                    return CustomDropDown(
                        hintText: language == Lang.EN ? 'Select Item' : 'समान चयन गर्नुहोस्',
                        validator: Validators.dropDownFieldValidator,
                        selectedValue: itemId,
                        allowValueAddition: true,
                        onValueSelected: (value) async {
                          if (value == -1) {
                            itemId = null;
                            setState(() {});
                            showDialog(
                                context: context,
                                builder: (cot) => AddItemDialog(onUserAddSuccess: (value) {
                                      setState(() {
                                        itemId = value;
                                      });
                                    }));
                            return;
                          }
                          setState(() {
                            itemId = value;
                          });
                        },
                        values: (snapshot.data ?? [])
                            .map((e) => ValueModel(
                                  id: e.id,
                                  name: e.name,
                                  nepaliName: e.name,
                                ))
                            .toList());
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                AdaptiveText(
                  TextModel('Quantity'),
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff43425d),
                    height: 1.5625,
                  ),
                ),
                TextFormField(
                  validator: Validators.doubleValidator,
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                AdaptiveText(
                  TextModel('Amount'),
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff43425d),
                    height: 1.5625,
                  ),
                ),
                TextFormField(
                  validator: Validators.doubleValidator,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: 25.0),
                TextButton.icon(
                  onPressed: _addPerson,
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: AdaptiveText(
                    TextModel('Submit'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addPerson() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState!.validate()) {
      try {
        widget.onItemAdd(
          TransactionItemData(
            personId: -1,
            id: -1,
            transactionId: -1,
            itemId: itemId!,
            quantity: double.parse(quantityController.text),
            amount: double.parse(amountController.text),
            createdDate: DateTime.now(),
          ),
        );
        Navigator.of(context, rootNavigator: true).pop(true);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
