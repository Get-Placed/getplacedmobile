import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/collegeAdmin/stdJobInfo.dart';
import 'package:placement_cell/services/values.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';

class AllStudentsApplied extends StatefulWidget {
  final String clgName;
  const AllStudentsApplied({
    Key? key,
    required this.clgName,
  });

  @override
  _AllStudentsAppliedState createState() => _AllStudentsAppliedState();
}

class _AllStudentsAppliedState extends State<AllStudentsApplied> {
  late Query<Map<String, dynamic>> appliedJob;

  loadData() {
    appliedJob = FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("clgName", isEqualTo: "${widget.clgName}");
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _exportJobData() async {
    if (await Permission.storage.request().isDenied) {
      Get.snackbar(
        "Storage Permission",
        "Please first grant storage permission to download the data",
        backgroundColor: Colors.red,
        animationDuration: Duration(seconds: 3),
      );
      return;
    }
    QuerySnapshot<Map<String, dynamic>> jobData = await appliedJob.get();

    List<List<String>> csvData = [
      [
        "Name",
        "Email ID",
        "Branch",
        "Company",
        "Designation",
        "Salary Package",
        "Status",
      ],
      ...jobData.docs.map((job) => [
            job["appliedName"],
            job["userEmail"],
            job["branch"],
            job["compName"],
            job["designation"],
            job["salary"],
            job["status"],
          ]),
    ];

    String csv = ListToCsvConverter().convert(csvData);
    final String path = "storage/emulated/0/Documents/placement_data.csv";

    final File file = File(path);

    await file.writeAsString(csv);

    Get.snackbar("Placement Data", "saved in $path",
        animationDuration: Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: k_themeColor,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Job Applications",
                style: GoogleFonts.aBeeZee(fontSize: 25.0)),
          ),
          Expanded(
            child: StreamBuilder(
              stream: appliedJob.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => StudentJobInfo(
                                  userEmail: snapshot.data.docs[index]
                                      .data()["userEmail"],
                                  jobid:
                                      snapshot.data.docs[index].data()["jobid"],
                                  appliedID: snapshot.data.docs[index].id,
                                  compName: snapshot.data.docs[index]
                                      .data()["compName"],
                                ),
                              );
                            },
                            child: buildApplyJob(
                              size,
                              appliedName: snapshot.data.docs[index]
                                  .data()["appliedName"],
                              designation: snapshot.data.docs[index]
                                  .data()["designation"],
                              compName:
                                  snapshot.data.docs[index].data()["compName"],
                              compOwner:
                                  snapshot.data.docs[index].data()["owner"],
                              logo: snapshot.data.docs[index].data()["logoUrl"],
                              appliedID: snapshot.data.docs[index].id,
                              status:
                                  snapshot.data.docs[index].data()["status"],
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
          _exportJobData();
        },
        label: const Text("Export to CSV"),
        icon: const Icon(Icons.file_download_outlined),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget buildApplyJob(
    Size size, {
    required String appliedName,
    required String designation,
    String logo = "",
    required String compName,
    required String compOwner,
    required String appliedID,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      child: Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                appliedName,
                style: GoogleFonts.ubuntu(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                "Applied For",
                style: GoogleFonts.poppins(),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                designation,
                style: GoogleFonts.aBeeZee(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text("Application Status: $status",
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: size.height * 0.01,
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: logo == ""
                        ? Image.asset(
                            "assets/logos/logo.png",
                            fit: BoxFit.cover,
                            height: 30.0,
                            width: 30.0,
                          )
                        : Image.network(
                            logo,
                            fit: BoxFit.cover,
                            height: 30.0,
                            width: 30.0,
                          ),
                  ),
                ),
                title: Text(
                  compName,
                  style: GoogleFonts.poppins(
                    fontSize: 17.0,
                  ),
                ),
                subtitle: Text(
                  compOwner,
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
