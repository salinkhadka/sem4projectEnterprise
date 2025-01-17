import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/components/extra_componenets.dart';
import 'package:byaparlekha/config/configuration.dart';
import 'package:byaparlekha/config/routes/routes.dart';
import 'package:byaparlekha/config/utility/validator.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/services/http_service.dart';
import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:byaparlekha/services/userService.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' hide context;
import 'package:progress_dialog/progress_dialog.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController usernameTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  ValueNotifier<int?> selectedCompany = ValueNotifier(null);
  bool obscure = true;
  @override
  void initState() {
    super.initState();
    HttpService().init(context);
    usernameTextEditingController.text = SharedPreferenceService().userName;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Form(
                    key: formKey,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 250,
                          width: 250,
                        ),
                      ),
                      AdaptiveText(
                        TextModel("Email Address"),
                        style: Configuration().kInputLableTitle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: usernameTextEditingController,
                        validator: Validators.emptyFieldValidator,
                        // maxLength: 10,
                        // keyboardType: TextInputType.number,
                        // buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      formSeperator(),
                      AdaptiveText(
                        TextModel("Password"),
                        style: Configuration().kInputLableTitle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        obscureText: obscure,
                        style: TextStyle(color: Colors.black),
                        controller: passwordTextEditingController,
                        validator: Validators.emptyFieldValidator,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              icon: Icon(obscure ? Icons.visibility : Icons.visibility_off)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Configuration().buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size.fromHeight(50)),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final ProgressDialog pr = ProgressDialog(context);
                            if (formKey.currentState!.validate()) {
                              await pr.show();
                              try {
                                await loginUser();
                                pr.hide();
                                Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (route) => false);
                              } catch (e) {
                                pr.hide();
                                showErrorDialog(
                                  context,
                                  (e.toString()),
                                );
                              }
                            }
                          },
                          child: AdaptiveText(
                            TextModel(
                              "Login".toUpperCase(),
                            ),
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: AdaptiveText(
                          TextModel('Don\'t have an account?'),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Configuration().buttonColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), minimumSize: Size.fromHeight(50)),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(context).pushReplacementNamed(
                              Routes.registerUserPage,
                            );
                          },
                          child: AdaptiveText(
                            TextModel("Register".toUpperCase()),
                            style: TextStyle(color: Colors.white),
                          )),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

