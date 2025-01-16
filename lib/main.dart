import 'package:byaparlekha/config/routes/routegenerator.dart';
import 'package:byaparlekha/config/utility/themes.dart';
import 'package:byaparlekha/providers/preference_provider.dart';
import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferenceService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PreferenceProvider>(
          create: ((context) => PreferenceProvider()),
        ),
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Byapar Lekha',
          theme: themeData,
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );
  }
}
