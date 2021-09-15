import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmaps_demo/Screens/Admin/Widgets/tripSummaryText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmBookScreens extends StatefulWidget {
  var tripId;
  var empId;

  ConfirmBookScreens({this.tripId, this.empId});
  @override
  _ConfirmBookScreensState createState() => _ConfirmBookScreensState();
}

class _ConfirmBookScreensState extends State<ConfirmBookScreens> {
  var origin;
  var dest;
  var vehicleType;
  var vehicleNum;
  var driverNum;
  var confirmedBy;
  bool isSubmit = false;
  Future getTripData() async {
    var res = await Dio().post(
        'https://cab-server.herokuapp.com/trip/tripDetail/' + widget.tripId);

    if (res.statusCode == 200)
      setState(() {
        origin = res.data['msg']['origin'];
        dest = res.data['msg']['destination'];
        vehicleType = res.data['msg']['vehicleType'];
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTripData();
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TRIP DETAILS",
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2 + 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff003566),
                    spreadRadius: 3,
                    blurRadius: 8,
                  ),
                ]),
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tripConfirmText("From", origin, context),
                    SizedBox(
                      height: 5,
                    ),
                    tripConfirmText("Destination", dest, context),
                    SizedBox(
                      height: 5,
                    ),
                    tripConfirmText("Vehicle Type", vehicleType, context),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Vehicle Number",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    vehicleNum = val;
                                  },
                                  onSaved: (val) {
                                    vehicleNum = val;
                                  },
                                  // ignore: missing_return
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return 'Vehicle Number is Required';
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Driver's Number",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onChanged: (val) {
                                    driverNum = val;
                                  },
                                  onSaved: (val) {
                                    driverNum = val;
                                  },
                                  // ignore: missing_return
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return 'Driver Number is Required';
                                    if (val.contains(RegExp(r'[a-z]')) ||
                                        val.contains(RegExp(r'[A-Z]')))
                                      return "Number contains invalid character";
                                    if (val.length < 10 || val.length > 10)
                                      return 'Enter a valid Number';
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    isSubmit
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: MaterialButton(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                  right: 40,
                                  left: 40,
                                ),
                                child: Text(
                                  "CONFIRM BOOKING",
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
                                if (_key.currentState.validate()) {
                                  // confirmBooking();
                                }
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future confirmBooking() async {
    setState(() {
      isSubmit = true;
    });
    var res = await Dio().put(
        'https://cab-server.herokuapp.com/trip/confirmTrip/' + widget.tripId,
        data: {
          "vehicleNum": vehicleNum,
          "driverNum": driverNum,
          "confirmedBy": widget.empId,
          "confirmed": true,
        });
    setState(() {
      isSubmit = false;
    });
    if (res.statusCode == 200) {
      signInMessage(res.data['status'], res.data['msg']);
    } else {
      signInMessage(res.data['status'], res.data['msg']);
    }
  }

  signInMessage(bool success, String msg) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return success
            ? AlertDialog(
                title: Text("Success Alert"),
                content: Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Message : $msg"),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Proceed"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/admin');
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text("Failure Alert"),
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
                      _key.currentState.reset();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
      },
    );
  }
}
