import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/customDropDown.dart';
import 'package:byaparlekha/components/extra_componenets.dart';
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