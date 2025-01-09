import 'package:byaparlekha/config/routes/routes.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {
    default:
      {
        builder = (BuildContext _) => SizedBox();
        break;
      }
  }
  return MaterialPageRoute(builder: builder, settings: settings);
}
