import 'package:flutter/material.dart';
import 'package:iiportfo/screen/home/home.dart';

void main() {
  runApp(MyApp());
}

final primaryColor = Colors.amber;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iiPortfo',
      theme: ThemeData(
          primarySwatch: primaryColor,
          accentColor: primaryColor,
          splashColor: Colors.deepOrange,
          canvasColor: Colors.black,
          buttonTheme: _getButtonTheme(context),
          appBarTheme: _getAppBarTheme(context),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      home: MyHomePage(title: 'iiPortfo'),
    );
  }

  ButtonThemeData _getButtonTheme(context) {
    return Theme.of(context).buttonTheme.copyWith(buttonColor: primaryColor);
  }

  AppBarTheme _getAppBarTheme(context) {
    return Theme.of(context).appBarTheme.copyWith(color: Colors.black);
  }
}