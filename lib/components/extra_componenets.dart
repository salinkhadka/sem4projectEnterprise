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