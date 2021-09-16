import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmaps_demo/Widgets/Report/tableData.dart';
import 'package:gmaps_demo/Widgets/Report/tableHeading.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (ConnectionState.active != null && !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (ConnectionState.done != null && snapshot.hasError) {
            return Center(
              child: Text('Oops some has occured'),
            );
          }
          if (ConnectionState.done != null &&
              snapshot.hasData &&
              snapshot.data.toString() == '[{msg: No Data found}]') {
            return Center(
              child: Text(
                "No Trips has been done yet",
                style: TextStyle(fontSize: 30),
              ),
            );
          }
          return Column(
            children: [
              Table(
                border: TableBorder.all(
                  color: Colors.black,
                  width: 1,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                    ),
                    children: [
                      tableHeading('Emp Id'),
                      tableHeading('Origin'),
                      tableHeading('Destination'),
                      tableHeading('Vehicle Type'),
                      tableHeading('Vehicle Number'),
                      tableHeading('Driver Number'),
                      tableHeading('Confirmed By'),
                      tableHeading('Created At'),
                      tableHeading('Confirmed At'),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          children: [
                            TableRow(
                              children: [
                                //Padding is given to only element because only for this element every other elements get corrected.
                                tableData(snapshot.data[index]['empId']),
                                tableData(snapshot.data[index]['origin']),
                                tableData(snapshot.data[index]['destination']),
                                tableData(snapshot.data[index]['vehicleType']),
                                tableData(snapshot.data[index]['vehicleNum']),
                                tableData(snapshot.data[index]['driverNum']),
                                tableData(snapshot.data[index]['confirmedBy']),
                                tableDate(snapshot.data[index]['createdAt']),
                                tableDate(snapshot.data[index]['updatedAt']),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ],
          );
        },
        future: retrieveData(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }

  Future retrieveData() async {
    var res =
        await Dio().get('https://cab-server.herokuapp.com/trip/viewAllTrips');

    print(res.data['msg']);
    return res.data["msg"];
  }
}

// final pdf = pw.Document();
// openPdf() {
//   pdf.addPage(
//     pw.Page(
//       build: (context) {
//         return pw.Header(
//           level: 1,
//           child: pw.Text("Header"),
//         );
//       },
//     ),
//   );
// }


/**
 * ListTile(
                      tileColor: Colors.green[50],
                      title: Row(
                        children: [
                          Row(
                            children: [
                              Text("Origin ->"),
                              SizedBox(width: 10),
                              Text(snapshot.data[index]['origin']),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text("Destination ->"),
                              SizedBox(width: 10),
                              Text(snapshot.data[index]['destination']),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Row(
                            children: [
                              Text("Employee ID ->"),
                              SizedBox(width: 10),
                              Text(snapshot.data[index]['empId']),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text("Raised Date ->"),
                              SizedBox(width: 10),
                              Text(snapshot.data[index]['createdAt']),
                            ],
                          ),
                        ],
                      ),
                    ));
 */