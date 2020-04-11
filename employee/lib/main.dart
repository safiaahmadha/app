import 'package:flutter/material.dart';
import 'package:employee/router.dart';
void main() => runApp(new EmployeeApp());

class EmployeeApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Employee Reports',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: routes,
//      home: Login(),
    );
  }
}
