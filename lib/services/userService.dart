import 'dart:convert';
import 'dart:io' as io;

// import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:byaparlekha/config/configuration.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/services/google_http_client.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart';

final backupFileName = 'byaparlekha.zip';

class UserService {
  Future<Map<String, dynamic>> getDefaultsData() async {
    final defaultData = await rootBundle.loadString('assets/defaults/defaults.json');
    return jsonDecode(defaultData);
  }

  Future<void> backupData(io.File file) async {
    final googleSignIn = GoogleSignIn.standard(scopes: [drive.DriveApi.driveAppdataScope]);
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) throw ('Error Signing In');
    var client = GoogleHttpClient(await account.authHeaders);
    var drive1 = drive.DriveApi(client);
    drive.File fileToUpload = drive.File();
    fileToUpload.parents = ["appDataFolder"];
    fileToUpload.name = basename(file.absolute.path);
    await drive1.files.create(
      fileToUpload,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    );
  }

  Future<drive.File?> _getIdOfLastBackupFile(GoogleHttpClient client) async {
    var drive1 = drive.DriveApi(client);
    final value = await drive1.files.list(spaces: 'appDataFolder');
    drive.File? file = value.files!.firstWhereOrNull(
      (element) => ((element.name!.compareTo(backupFileName)) == 0),
    );
    return file;
  }

  Future<dynamic> loginUser({required String username, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      return {"accessToken": credential.credential?.accessToken ?? ""};
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "";
    } catch (e) {
      rethrow;
    }
  }

  Future<drive.File> checkIfBackupExists(GoogleHttpClient client) async {
    try {
      drive.File? responseFile = await _getIdOfLastBackupFile(client);
      if (responseFile == null) throw ('No Backup found');
      return responseFile;
    } catch (e) {
      rethrow;
    }
  }

  Future<drive.Media> getBackupMediaFileFromDrive() async {
    try {
      final googleSignIn = GoogleSignIn.standard(scopes: [drive.DriveApi.driveAppdataScope]);
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) throw ('Error Signing In');
      var client = GoogleHttpClient(await account.authHeaders);
      var drive1 = drive.DriveApi(client);
      drive.File responseFile = await checkIfBackupExists(client);
      final downloadedFile = await (drive1.files.get(responseFile.id!, downloadOptions: drive.DownloadOptions.fullMedia));
      return (downloadedFile as drive.Media);
    } on PlatformException catch (e) {
      throw (e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> restoreBackup(List<int> backupZipFile) async {
    try {
      // final io.Directory imageDir = await Configuration().getImageStorageDirectory();
      Archive archive = ZipDecoder().decodeBytes(backupZipFile);
      ArchiveFile? databaseFile = archive.files.singleWhereOrNull(
        (element) => element.name == databaseName,
      );
      if (databaseFile == null) throw ('Backup File is not found, Please try again');
      databaseFile.decompress();
      final dbDataByte = databaseFile.content;

      await MyDatabase().deleteAndUpdateDatabase(dbDataByte);
      List<ArchiveFile> inAppImageDir = archive.files
          .where(
            (element) => element.name.contains('app_files'),
          )
          .toList();
      if (inAppImageDir.isEmpty) return;
      final imgDir = await Configuration().getImageStorageDirectory();
      if (await imgDir.exists())
        try {
          await io.Directory(imgDir.path).delete(recursive: true);
        } catch (e) {}

      inAppImageDir.forEach((element) {
        element.decompress();
        final path = imgDir.path.replaceAll("/app_files", "") + '/' + element.name;
        if (element.isFile)
          io.File(path)
            ..createSync(recursive: true)
            ..writeAsBytesSync(element.content);
        else
          io.Directory(path).createSync(recursive: true);
      });
    } on PlatformException catch (e) {
      throw (e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      // showSuccessToast("Password has been changed successfully");
    } catch (e) {
      // showErrorToast(e.toString());
    }
  }

  Future<dynamic> registerUser({required String username, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      return {"accessToken": credential.credential?.accessToken ?? ""};
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "";
    } catch (e) {
      rethrow;
    }
  }
}
