import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:placement_cell/admin/collegeAdmin/StudentPage.dart';
import 'package:placement_cell/admin/collegeAdmin/stdJobInfo.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';

class AllStudents extends StatefulWidget {
  final String clgName;
  const AllStudents({Key? key, required this.clgName}) : super(key: key);

  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  late QuerySnapshot<Map<String, dynamic>> stdData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
    );
    loadstdList();
  }

  loadstdList() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: 0)
        .where("userFrom", isEqualTo: widget.clgName)
        .get()
        .then((value) {
      setState(() {
        stdData = value;
        isLoading = false;
      });
      print(stdData);
    });
  }

  AuthService _authService = AuthService();

  Future<bool?> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        // alert on back button pressed
        title: Text(
          "Alert",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "You will be logged out of Session!",
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Cancel",
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text(
              "OK",
            ),
            onPressed: () {
              _authService.signOut().then(
                    (value) => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                  );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportStudentData() async {
    if (await Permission.storage.request().isDenied) {
      Get.snackbar(
        "Storage Permission",
        "Please first grant storage permission to download the data",
        backgroundColor: Colors.red,
        animationDuration: Duration(seconds: 3),
      );
      return;
    }
    List<List<String>> csvData = [
      [
        "Name",
        "Email ID",
        "Branch",
        "Date Of Birth",
        "SSC Marks",
        "HSC Marks",
        "Diploma CGPA",
        "Sem 1",
        "Sem 2",
        "Sem 3",
        "Sem 4",
        "Sem 5",
        "Sem 6",
        "Sem 7",
        "Sem 8",
        "CGPA"
      ],
      ...stdData.docs.map((std) => [
            std["userName"],
            std["email"],
            std["dept"],
            std["dob"],
            std["ssc"],
            std["hsc"],
            std["dipcgpa"],
            std["sem1"],
            std["sem2"],
            std["sem3"],
            std["sem4"],
            std["sem5"],
            std["sem6"],
            std["sem7"],
            std["sem8"],
            std["cgpa"]
          ]),
    ];

    String csv = ListToCsvConverter().convert(csvData);
    final String path = "storage/emulated/0/Documents/student_data.csv";

    final File file = File(path);

    await file.writeAsString(csv);

    Get.snackbar("Student Data", "saved in $path",
        animationDuration: Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text("All Students", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff4338CA),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff000000), Color(0xff7f8c8d)],
              stops: [0.5, 1.0],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _onBackPressed();
            },
            icon: Icon(
              Icons.power_settings_new_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: stdData.docs.map<Widget>((doc) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(doc['userName']),
                      subtitle: Text(doc['email']),
                      onTap: () {
                        Get.to(
                          () => StudentPage(
                            userEmail: doc["email"],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _exportStudentData();
        },
        label: const Text("Download Student Data"),
        icon: const Icon(Icons.file_download_outlined),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
