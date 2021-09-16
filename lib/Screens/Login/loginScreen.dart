import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmaps_demo/Screens/Admin/demo.dart';
import 'package:gmaps_demo/Screens/Admin/homecreen.dart';
import 'package:gmaps_demo/Screens/User/homecreen.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _empId;
  String _passwd;
  String _role;

  bool isSubmit = false;

  final _formKey = GlobalKey<FormState>();
  static var counter = 1;
  bool obscure = true;
  bool obscureCount() {
    counter++;
    return counter % 2 != 0 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image.asset('assets/image/Mission pic.jpg'),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Center(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/icons/ambulance.png'),
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width / 10,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      /**
                     *    Email Field
                     */

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Emp ID",
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fillColor: Color(0xffC4C4C4).withOpacity(.2),
                            filled: true,
                          ),
                          onChanged: (val) {
                            _empId = val;
                          },
                          onSaved: (val) {
                            _empId = val;
                          },
                          // ignore: missing_return
                          validator: (val) {
                            if (val.isEmpty) return 'Employee ID is Required';
                          },
                        ),
                      ),

                      /**
                     *    Password Field
                     */
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: counter % 2 == 0
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  obscure = obscureCount();
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          obscureText: obscure,
                          obscuringCharacter: '*',
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (val) {
                            _passwd = val;
                          },
                          onSaved: (val) {
                            _passwd = val;
                          },
                          // ignore: missing_return
                          validator: (val) {
                            if (val.isEmpty)
                              return 'Password is Required';
                            else if (val.length < 8)
                              return 'Password must contains minimum 8 characters';
                            else if (!val.contains(RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')))
                              return "Password must contains atleast \n At least one uppercase letter, \n One lowercase letter, \n One number and \n One special character";
                          },
                        ), //Password Field Ends
                      ),
                      SizedBox(height: 30),
                      isSubmit
                          ? CircularProgressIndicator()
                          : MaterialButton(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                  right: 40,
                                  left: 40,
                                ),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              color: Color(0xfff2400FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    getData();
                                  });
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    setState(() {
      isSubmit = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res =
        await Dio().post('http://cab-server.herokuapp.com/user/login', data: {
      "empId": _empId,
      "passwd": _passwd,
    });

    if (res.statusCode == 200) {
      if (res.data["status"]) {
        await prefs.setString('EmpID', res.data["data"]["empId"]);
        await prefs.setString('Name', res.data["data"]["name"]);
        await prefs.setString('PhoneNum', res.data["data"]["phoneNum"]);
        if (res.data['data']['role'] != null) {
          await prefs.setString('Role', res.data["data"]["role"]);
          _role = await res.data['data']['role'];
        }
        signInMessage(res.data["status"], res.data["msg"]);
      } else {
        signInMessage(res.data["status"], res.data["msg"]);
      }
    }
    setState(() {
      isSubmit = false;
    });
  }

  signInMessage(bool success, String msg) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return success && _role == "admin"
            ? AlertDialog(
                title: Text("Login Alert"),
                content: Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Message : $msg"),
                      Text("Employee ID : $_empId"),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Proceed"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminHomeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              )
            : success
                ? AlertDialog(
                    title: Text("Login Alert"),
                    content: Container(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Message : You have user permission"),
                          Text("Kindly Login using Mobile App"),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("Proceed"),
                        onPressed: () {
                          setState(() {
                            _role = null;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                : AlertDialog(
                    title: Text("Login Alert"),
                    content: Container(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Oops Error Occured"),
                          Text("Error Message"),
                          Text("$msg"),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("Retry"),
                        onPressed: () {
                          _formKey.currentState.reset();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
      },
    );
  }
}
