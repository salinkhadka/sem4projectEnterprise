import 'package:byaparlekha/config/routes/routes.dart';
import 'package:byaparlekha/database/myDatabase/database.dart';
import 'package:byaparlekha/screens/account_page.dart';
import 'package:byaparlekha/screens/authPage.dart';
import 'package:byaparlekha/screens/budget_page.dart';
import 'package:byaparlekha/screens/category_page.dart';
import 'package:byaparlekha/screens/change_password.dart';
import 'package:byaparlekha/screens/daily_log_report_page.dart';
import 'package:byaparlekha/screens/homepage.dart';
import 'package:byaparlekha/screens/projection&actual_projection.dart';
import 'package:byaparlekha/screens/registrationPage.dart';
import 'package:byaparlekha/screens/report_page.dart';
import 'package:byaparlekha/screens/splashscreen.dart';
import 'package:byaparlekha/screens/transaction_page.dart';
import 'package:flutter/material.dart';

import '../../screens/backup_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {
    case Routes.splashPage:
      {
        builder = (BuildContext _) => SplashScreen();
        break;
      }
    case Routes.home:
      {
        builder = (BuildContext _) => HomePage();
        break;
      }
    case Routes.category:
      {
        builder = (BuildContext _) => CategoryPage();
        break;
      }
    case Routes.backup:
      {
        builder = (BuildContext _) => BackUpPage();
        break;
      }
    case Routes.budget:
      {
        builder = (BuildContext _) => BudgetPage(
              isInflowProjection: settings.arguments as bool?,
            );
        break;
      }
    case Routes.account:
      {
        builder = (BuildContext _) => AccountPage();
        break;
      }
    case Routes.report:
      {
        builder = (BuildContext _) => ReportPage();
        break;
      }

    // case Routes.languagePage:
    //   {
    //     builder = (BuildContext _) => LanguagePreferencePage();
    //     break;
    //   }
    case Routes.authenticationPage:
      {
        builder = (BuildContext _) => AuthenticationPage();
        break;
      }
    case Routes.registerUserPage:
      {
        builder = (BuildContext _) => RegistrationPage();
        break;
      }
    case Routes.transactionPage:
      {
        final args = (settings.arguments ?? {}) as Map<String, dynamic>;
        builder = (BuildContext _) => TransactionPage(
              isIncome: (args['isIncome'] as bool?) ?? false,
              transaction: (args['transaction'] as Transaction?),
            );
        break;
      }

    case Routes.dailyLogReport:
      {
        builder = (BuildContext _) => DailyLogReportPage();
        break;
      }

    case Routes.changePasswordPage:
      {
        builder = (BuildContext _) => ChangePasswordScreen();
        break;
      }
    case Routes.projectAndActual:
      {
        builder = (context) => ProjectionAndActualProjectionPage();
        break;
      }
    default:
      {
        builder = (BuildContext _) => SplashScreen();
        break;
      }
  }
  return MaterialPageRoute(builder: builder, settings: settings);
}
