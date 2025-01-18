import 'package:byaparlekha/components/adaptive_text.dart';
import 'package:byaparlekha/config/configuration.dart';
import 'package:byaparlekha/config/globals.dart';
import 'package:byaparlekha/config/routes/routes.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/models/textModel.dart';
import 'package:byaparlekha/providers/preference_provider.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:permission_handler/permission_handler.dart' as p;

import 'package:byaparlekha/services/http_service.dart';
import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:byaparlekha/services/userService.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import '../components/extra_componenets.dart';

class BackUpPage extends StatefulWidget {
  @override
  _BackUpPageState createState() => _BackUpPageState();
}

class _BackUpPageState extends State<BackUpPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // bool isCreating = false;
  late final Lang language;
  @override
  void initState() {
    super.initState();
    language = Provider.of<PreferenceProvider>(context, listen: false).language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Configuration().appColor,
      appBar: AppBar(
        title: AdaptiveText(TextModel('Backup')),
      ),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Colors.white,
      //     child: Icon(
      //       MdiIcons.cloudUploadOutline,
      //       size: 28,
      //       color: Configuration().appColor,
      //     ),
      //     onPressed: () async {

      //     }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (SharedPreferenceService().lastBackupDate != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdaptiveText(
                    TextModel('Last Backup on'),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    NepaliDateFormat(
                      "MMMM dd, y (EEE)",
                    ).format(
                      DateTime.parse(SharedPreferenceService().lastBackupDate!).toNepaliDateTime(),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            else
              AdaptiveText(
                TextModel('No Backup Found'),
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      File? backupFile;

                      ProgressDialog pr = ProgressDialog(context, isDismissible: false);
                      pr.style(message: language == Lang.EN ? 'Synchronizing Data' : 'समिकरण भइरहेको छ');
                      await pr.show();
                      try {
                        backupFile = await createBackup(language);
                        pr.hide();
                        showErrorDialog(
                          'Data has been backup successfully',
                          'Success',
                        ).then((value) {
                          Navigator.of(context).pushNamedAndRemoveUntil(Routes.splashPage, (route) => false);
                        });
                      } catch (e) {
                        pr.hide();
                        showErrorDialog('Error Performing Backup, ' + e.toString(), null);
                      }
                      if (backupFile != null) backupFile.delete(recursive: false).catchError((onError) {});
                    },
                    child: Text(
                      "Backup",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      restoreBackUpDataFromGoogle();
                    },
                    child: Text(
                      "Restore",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  showAlertDialog() {
    showDeleteDialog(context, hideCancel: true, deleteButtonText: 'Go To Profile', description: 'You have to create account to create backup, Please create account and try again.', onDeletePress: () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  Future<void> showErrorDialog(String descritpion, String? title) async {
    await showDeleteDialog(context, title: title, hideCancel: true, deleteButtonText: 'Okay    ', description: descritpion, onDeletePress: () {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  Future<File> createBackup(Lang language) async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      var encoder = ZipFileEncoder();
      String zipPath = dir.path + '/temporary/$backupFileName';
      encoder.create(zipPath);
      await AppDatabase().myDatabase.closeDatabase();
      final databaseFile = File(await getDatabaseFilePath);
      encoder.addFile(databaseFile);
      final Directory imageDir = await Configuration().getImageStorageDirectory();
      encoder.addDirectory(imageDir);

      encoder.close();
      dir = (await getExternalStorageDirectory())!;
      final zipDirectory = await Directory(dir.path + '/temporary').create(recursive: true);
      String newzipPath = zipDirectory.path + '/$backupFileName';
      final value = await File(zipPath).copy(newzipPath);
      File(zipPath).deleteSync(recursive: true);

      await UserService().backupData(value);
      SharedPreferenceService().lastBackupDate = DateTime.now().toIso8601String();
      setState(() {});
      return File(newzipPath);
    } catch (e) {
      rethrow;
    }
  }