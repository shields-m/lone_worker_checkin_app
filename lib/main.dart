import 'package:flutter/material.dart';
import 'package:lone_worker_checkin/Pages/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lone Worker Check-in',
      home: welcomePage(),
      theme: ThemeData(
        fontFamily: 'Manjari',

        brightness: Brightness.light,
        textSelectionHandleColor: Colors.green,
scaffoldBackgroundColor: Color.fromARGB(255, 205, 205, 199),

        appBarTheme: AppBarTheme(

          elevation: 0, // This removes the shadow from all App Bars.
          color: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.green,
          ),

          textTheme: TextTheme(
            title: TextStyle(

              fontFamily: 'Manjari',
              fontWeight: FontWeight.w700,
              color: Colors.green,
              fontSize: 24,
            ),
          ),
        ),
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
