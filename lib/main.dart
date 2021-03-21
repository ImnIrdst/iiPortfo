import 'package:flutter/material.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times to iiPortfo:'),
            Text('$_counter', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
