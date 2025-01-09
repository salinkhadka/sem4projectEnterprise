import 'dart:io';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // SharedPreferenceService();
  // HttpOverrides.global = MyHttpOverrides();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider<PreferenceProvider>(
    //       create: ((context) => PreferenceProvider()),
    //     ),
    //   ],
    //   child: ToastificationWrapper(
    //     child: MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'Byapar Lekha',
    //       theme: themeData,
    //       onGenerateRoute: onGenerateRoute,
    //     ),
    //   ),
    // );
  }
}

// final ThemeData themeData = ThemeData(
//   fontFamily: 'Poppins',
//   appBarTheme: AppBarTheme(
//     color: Configuration().appColor,
//     actionsIconTheme: IconThemeData(color: Colors.white),
//     iconTheme: IconThemeData(color: Colors.white),
//     titleTextStyle: TextStyle(fontSize: 17, color: Colors.white),
//     elevation: 0,
//   ),
//   checkboxTheme: CheckboxThemeData(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(4),
//       side: BorderSide(color: Configuration().appColor),
//     ),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//     suffixIconColor: Configuration().borderColor,
//     border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(Configuration().inputFieldBorderRadius),
//         borderSide: BorderSide(
//           color: Configuration().borderColor,
//         )),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(Configuration().inputFieldBorderRadius),
//       borderSide: BorderSide(color: Configuration().borderColor),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(Configuration().inputFieldBorderRadius),
//       borderSide: BorderSide(color: Configuration().redColor),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Configuration().borderColor),
//       borderRadius: BorderRadius.circular(Configuration().inputFieldBorderRadius),
//     ),
//     disabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Configuration().borderColor),
//       borderRadius: BorderRadius.circular(Configuration().inputFieldBorderRadius),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Configuration().redColor),
//       borderRadius: BorderRadius.circular(Configuration().inputFieldBorderRadius),
//     ),
//     errorStyle: TextStyle(fontSize: 12.0, color: Colors.red),
//     hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
//   ),
//   scaffoldBackgroundColor: Colors.white,
//   canvasColor: Colors.white,
//   iconTheme: IconThemeData(color: Configuration().appColor),
//   textButtonTheme: TextButtonThemeData(
//     style: ButtonStyle(
//       minimumSize: WidgetStateProperty.resolveWith((states) => Size(double.maxFinite, 46)),
//       shape: WidgetStateProperty.resolveWith(
//         (states) => RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//       textStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: Colors.white)),
//       backgroundColor: WidgetStateProperty.resolveWith((states) => Configuration().buttonColor),
//     ),
//   ),
//   outlinedButtonTheme: OutlinedButtonThemeData(
//     style: ButtonStyle(
//       minimumSize: WidgetStateProperty.resolveWith((states) => Size(double.maxFinite, 46)),
//       shape: WidgetStateProperty.resolveWith(
//         (states) => RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//       textStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: Colors.white)),
//       // backgroundColor: WidgetStateProperty.resolveWith((states) => Configuration().buttonColor),
//     ),
//   ),
//   tabBarTheme: TabBarTheme(
//     dividerHeight: 0,
//     labelPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
//     indicatorSize: TabBarIndicatorSize.tab,
//     labelStyle: TextStyle(color: Colors.white),
//     unselectedLabelStyle: TextStyle(color: Colors.white),
//     indicator: BoxDecoration(
//       borderRadius: BorderRadius.circular(100),
//       color: Configuration().buttonColor,
//     ),
//   ),
//   buttonTheme: ButtonThemeData(
//       minWidth: double.maxFinite,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       buttonColor: Configuration().buttonColor,
//       height: 46,
//       textTheme: ButtonTextTheme.normal),
// );
