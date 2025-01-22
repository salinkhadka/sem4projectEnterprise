import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/extra_componenets.dart';
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:provider/provider.dart';

class AddPersonDialog extends StatefulWidget {
  final Function(int) onUserAddSuccess;

  const AddPersonDialog({super.key, required this.onUserAddSuccess});
  @override
  _AddPersonDialogState createState() => _AddPersonDialogState();
}

class _AddPersonDialogState extends State<AddPersonDialog> {
  final TextEditingController nameController = TextEditingController();
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
                  TextModel('Add New Customer'),
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff43425d),
                    height: 1.5625,
                  ),
                ),
                TextFormField(
                  validator: Validators.emptyFieldValidator,
                  controller: nameController,
                  decoration: InputDecoration(),
                ),
                SizedBox(height: 25.0),
                TextButton.icon(
                  onPressed: _addPerson,
                  icon: Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.white,
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
        final id = await AppDatabase().myDatabase.personDao.insertData(PersonCompanion(
              name: Value<String>(nameController.text),
            ));
        Navigator.of(context, rootNavigator: true).pop(true);
        widget.onUserAddSuccess(id);
      } catch (e) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
