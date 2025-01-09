import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

CellStyle numberCellStyle = CellStyle(horizontalAlign: HorizontalAlign.Right, textWrapping: TextWrapping.WrapText);
CellStyle cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Left, textWrapping: TextWrapping.WrapText);
CellStyle get boldCellStyle => CellStyle(
      bold: true,
      textWrapping: TextWrapping.Clip,
    );
CellStyle get headerCellStyle => boldCellStyle.copyWith(boldVal: true, horizontalAlignVal: cellStyle.horizontalAlignment, textWrappingVal: TextWrapping.WrapText);
CellStyle get numberHeaderCellStyle => boldCellStyle.copyWith(horizontalAlignVal: numberCellStyle.horizontalAlignment, textWrappingVal: TextWrapping.WrapText);

class Configuration {
  TextStyle get whiteText => TextStyle(
        color: Colors.white,
      );

  TextStyle kInputLableTitle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  final TextStyle kInputFieldTitle = TextStyle(
    color: Colors.black,
  );
  final double inputborderWidth = 3.0;
  final double inputFieldBorderRadius = 10.0;

  Color get appColor => Color(0xff6230d1);
  Color get redColor => Color(0xff263547);
  Color get expenseColor => Colors.red[600]!;
  Color get incomeColor => Colors.green;
  Color get secondaryColor => Color(0xffaf1af3);
  Color get deleteColor => Color(0xfffc717f);
  Color get cancelColor => Color(0xffb9bbc5);
  Color get borderColor => Color(0xffdadada);
  Color get buttonColor => secondaryColor;
  Color get highlightColor => Color(0xff00B1FA);
  Color get accountIconColor => Color(0xff005CF3);
  Color get circularIndicatorBackgroundColor => Color(0xffDEE4F6);

  Color get iconColor => appColor;

  Widget get drawerItemDivider => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Divider(
          color: Colors.grey,
        ),
      );

  BoxDecoration get gradientDecoration => BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: FractionalOffset.bottomRight,
          end: FractionalOffset.topLeft,
        ),
      );

  List<Color> get gradientColors => [
        appColor,
        redColor,
      ];

  NepaliDateTime toNepaliDateTime(DateTime dateTime) {
    return NepaliDateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<Directory> getImageStorageDirectory() async {
    Directory _dir = await getRootImageStorageDirectory();
    final dir = Directory(_dir.path + '/app_files');
    await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> getRootImageStorageDirectory() async {
    Directory _dir = await getApplicationSupportDirectory();
    return _dir;
  }

  Future<File> saveImage(File file, String directoryFolderName) async {
    String fileName = DateTime.now().toIso8601String().replaceAll(':', '').replaceAll('.', '').replaceAll('-', '');
    String ext = file.path.split('/').last.split('.').last;
    Directory directory = await Directory((await getImageStorageDirectory()).path + '/$directoryFolderName').create(recursive: true);
    String filePath = join(directory.path, fileName + ('.' + ext));
    await file.copy(filePath);
    return File(filePath);
  }
}
