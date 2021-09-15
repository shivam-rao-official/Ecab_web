import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget tableData(String data) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: Text(data)),
  );
}

Widget tableDate(String data) {
  DateTime timestamp = DateTime.parse(data);
  String formattedDate = DateFormat('EEE dd/MM/yyyy').format(timestamp);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: Text(formattedDate)),
  );
}
