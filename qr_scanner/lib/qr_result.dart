import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:fluttertoast/fluttertoast.dart';

class QRResult extends StatefulWidget {
  final Map<String, dynamic> qrData;
  const QRResult({super.key, required this.qrData});

  @override
  State<QRResult> createState() => _QRResultState();
}

class _QRResultState extends State<QRResult> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateTime now = DateTime.now();

  Future<void> register() async {
    try {
      String formattedDate = "${now.year}-${now.month}-${now.day}";
      final data = <String, dynamic>{
        'userId': widget.qrData['id'],
        'date': formattedDate
      };
      await db
          .collection('attendance')
          .add(data)
          .then((DocumentReference doc) => Fluttertoast.showToast(
                msg: 'Attendence Registered',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ));
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: ${widget.qrData['id']}'),
            Text('Name: ${widget.qrData['username']}'),
            ElevatedButton(
                onPressed: () {
                  register();
                },
                child: Text('Register Attendance'))
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
