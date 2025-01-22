import 'package:flutter/material.dart';

import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/extra_componenets.dart';
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/services/userService.dart';
import 'package:byaparlekha/widget/formWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool oldPasswordShow = true;
  bool newPasswordShow = true;
  bool confirmPasswordShow = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AdaptiveText(TextModel("Change Password"))),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FormWidget(
                    title: "Old Password",
                    child: TextFormField(
                      obscureText: oldPasswordShow,
                      controller: oldPasswordController,
                      validator: Validators.emptyFieldValidator,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                oldPasswordShow = !oldPasswordShow;
                                setState(() {});
                              },
                              icon: Icon(oldPasswordShow ? Icons.visibility_off : Icons.visibility))),
                    ),
                  ),
                  formSeperator(),
                  FormWidget(
                    title: "New Password",
                    child: TextFormField(
                      obscureText: newPasswordShow,
                      controller: newPasswordController,
                      validator: Validators.emptyFieldValidator,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                newPasswordShow = !newPasswordShow;
                                setState(() {});
                              },
                              icon: Icon(newPasswordShow ? Icons.visibility_off : Icons.visibility))),
                    ),
                  ),
                  formSeperator(),
                  FormWidget(
                    title: "Confirm Password",
                    child: TextFormField(
                      obscureText: confirmPasswordShow,
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return Validators.emptyFieldValidator(value);
                        } else if (value != newPasswordController.text) {
                          return "Password Doesn't Match";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                confirmPasswordShow = !confirmPasswordShow;
                                setState(() {});
                              },
                              icon: Icon(confirmPasswordShow ? Icons.visibility_off : Icons.visibility))),
                    ),
                  ),
                  formSeperator(),
                  TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final ProgressDialog pr = ProgressDialog(context);
                          await pr.show();
                          await UserService().changePassword(oldPasswordController.text, newPasswordController.text);
                          await pr.hide();
                          Navigator.of(context).pop();
                        }
                      },
                      child: AdaptiveText(
                        TextModel("Submit"),
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
