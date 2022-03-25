import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/collegeAdmin/StudentPage.dart';
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
  late Query<Map<String, dynamic>> stdInstance;

  @override
  void initState() {
    super.initState();
    loadstdList();
  }

  loadstdList() {
    stdInstance = FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: 0)
        .where("userFrom", isEqualTo: widget.clgName);
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
    QuerySnapshot<Map<String, dynamic>> stdData = await stdInstance.get();
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
      backgroundColor: k_themeColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Students List",
              style: GoogleFonts.aBeeZee(fontSize: 25.0),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: stdInstance.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: ListTile(
                              title: Text(
                                  snapshot.data.docs[index].data()['userName']),
                              subtitle: Text(
                                  snapshot.data.docs[index].data()['email']),
                              onTap: () {
                                Get.to(
                                  () => StudentPage(
                                    userEmail: snapshot.data.docs[index]
                                        .data()["email"],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _exportStudentData();
        },
        label: const Text("Export to CSV"),
        icon: const Icon(Icons.file_download_outlined),
        backgroundColor: Colors.black,
      ),
    );
  }
}
