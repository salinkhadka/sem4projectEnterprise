import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/config/globals.dart';
import 'package:flutter/material.dart';
import 'package:byaparlekha/icons/vector_icons.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:toastification/toastification.dart';

import '../config/configuration.dart';

Future<dynamic> showDeleteDialog(BuildContext context,
    {String? title, String? description, String? deleteButtonText, IconData? topIcon, Function? onDeletePress, Function? onCancelPress, bool hideCancel = false}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 15.0, right: 15.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      AdaptiveText(
                        TextModel(title ?? 'Attention'),
                        style: TextStyle(
                          fontSize: 20,
                          color: const Color(0xfffc717f),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      AdaptiveText(
                        TextModel(description ?? ''),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5625,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.0),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (onDeletePress != null)
                          onDeletePress();
                        else
                          Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: chipDecoratedContainer(deleteButtonText ?? 'Delete', chipColor: Configuration().deleteColor),
                    ),
                    if (!(hideCancel))
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (onCancelPress != null)
                            onCancelPress();
                          else
                            Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: chipDecoratedContainer('Cancel', chipColor: Configuration().cancelColor),
                      ),
                  ],
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    return value;
  });
}

Widget chipDecoratedContainer(String text, {Color? chipColor}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: chipColor ?? Configuration().deleteColor),
    child: AdaptiveText(
      TextModel(text),
      style: TextStyle(color: Colors.white, fontSize: 15),
      textAlign: TextAlign.center,
    ),
  );
}

Future<dynamic> detailDialog(BuildContext context, {Function(dynamic)? onDialogClosed, Function? onDelete, Function? onUpdate, String? title, bool? showButton, Widget? detailWidget}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
        title: AdaptiveText(
          TextModel(title ?? 'Detail'),
          style: TextStyle(
            fontSize: 20,
            color: Configuration().deleteColor,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 15.0, bottom: 10.0),
              child: detailWidget ??
                  SizedBox(
                    height: 1,
                  ),
            ),
            SizedBox(height: 20.0),
            if (showButton ?? true)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (onDelete != null) onDelete();
                    },
                    child: chipDecoratedContainer('Delete'),
                  ),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (onUpdate != null) {
                        onUpdate();
                      }
                    },
                    child: chipDecoratedContainer('Update', chipColor: Color(0xffb380f6)),
                  ),
                ],
              ),
            SizedBox(height: 8.0),
          ],
        ),
      );
    },
  ).then((value) {
    if (onDialogClosed != null) onDialogClosed(value);
  });
}

Future<dynamic> showFormDialog(BuildContext context,
    {Widget? titleWidget, Widget? bodyWidget, bool? showTitleWidget, String? title, IconData? titleIcon, String? buttonText, Function? onButtonPressed, Function? onButton2Pressed}) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(18.0))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 23),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if ((showTitleWidget ?? false) && titleWidget != null)
                    titleWidget
                  else
                    Center(
                      child: AdaptiveText(
                        TextModel(title ?? ''),
                        style: TextStyle(color: Configuration().deleteColor, fontSize: 19.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  SizedBox(
                    height: 25,
                  ),
                  if (bodyWidget != null) bodyWidget,
                  SizedBox(height: 50.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(color: Colors.white))),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            if (onButtonPressed != null) onButtonPressed();
                          },
                          child: AdaptiveText(
                            TextModel(buttonText ?? 'Add'),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17.0, color: Colors.white),
                          ),
                        ),
                      ),
                      if (onButton2Pressed != null) SizedBox(width: 30),
                      if (onButton2Pressed != null)
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith((states) => Configuration().cancelColor),
                                textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(color: Colors.white))),
                            onPressed: () async {
                              onButton2Pressed();
                            },
                            child: AdaptiveText(
                              TextModel('Cancel'),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 17.0, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<dynamic> showErrorDialog(BuildContext context, String errorMessage, {bool isSuccess = false, bool awaitForDialog = false}) async {
  final Widget dialog = Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(18.0))),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 23),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: AdaptiveText(
                  TextModel(isSuccess ? 'Success' : 'Error'),
                  style: TextStyle(color: Configuration().deleteColor, fontSize: 19.0, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AdaptiveText(
                TextModel(errorMessage),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.0),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Configuration().secondaryColor),
                    textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(color: Colors.white))),
                onPressed: () async {
                  // FocusScope.of(context).requestFocus(new FocusNode());
                  Navigator.of(context).pop();
                },
                child: AdaptiveText(
                  TextModel('Dismiss'),
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
  if (awaitForDialog)
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return dialog;
      },
    );
  else
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return dialog;
      },
    );
}