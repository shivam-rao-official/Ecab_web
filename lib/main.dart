import 'package:flutter/material.dart';
import 'package:gmaps_demo/Screens/Admin/demo.dart';
import 'package:gmaps_demo/Screens/Admin/homecreen.dart';
import 'package:gmaps_demo/Screens/Admin/reports.dart';
import 'package:gmaps_demo/Screens/Login/loginScreen.dart';
import 'package:gmaps_demo/Screens/User/bookingPage.dart';
import 'package:gmaps_demo/Screens/User/homecreen.dart';
import 'package:gmaps_demo/Screens/User/splash.dart';
import 'package:gmaps_demo/Screens/User/splash2.dart';
import 'package:gmaps_demo/Screens/User/tripSummary.dart';
import 'package:gmaps_demo/Screens/accounts.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var EmpID = prefs.getString('EmpID');
  var PhoneNum = prefs.getString('PhoneNum');
  var Name = prefs.getString('Name');
  var role = prefs.getString('Role');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Mission e-Cab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff003566),
        buttonColor: Color(0xffffd60a),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xffffd60a),
          elevation: 20,
          splashColor: Color(0xffffc300),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xff003566),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      routes: <String, WidgetBuilder>{
        '/splash2': (BuildContext ctxt) => Splash2(),
        '/login': (BuildContext ctxt) => LoginScreen(),
        '/home': (BuildContext ctxt) => HomeScreen(),
        '/bookTrip': (BuildContext ctxt) => TripBooking(),
        '/tripSummary': (BuildContext ctxt) => TripSummary(),
        '/account': (BuildContext ctxt) => AccountScreen(),
        // ADMIN ROUTES
        '/admin': (BuildContext ctxt) => AdminHomeScreen(),
        '/report': (BuildContext ctxt) => Reports(),
      },
      home: Splash2(),
    );
  }
}
