import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/compAdmin/stdJobInfoComp.dart';
import 'package:placement_cell/services/values.dart';

class CompanyHome extends StatefulWidget {
  final String owner, logoUrl, compName, jobID;
  const CompanyHome({
    Key? key,
    required this.owner,
    required this.logoUrl,
    required this.compName,
    required this.jobID,
  });

  @override
  _CompanyHomeState createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  late Query appliedJob;
  loadData() {
    print("JOBID:" + widget.jobID);
    appliedJob = FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("jobid", isEqualTo: widget.jobID)
        .where("acceptedBy", isEqualTo: "clg ${widget.compName}");
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<bool> selectedList = [];
  List<String> uidList = [];
  String commonStatus = "APPLIED";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: k_btnColor),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        title: Text(
          "Applied Jobs List",
          style: GoogleFonts.aBeeZee(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.04,
          ),
          Expanded(
            child: StreamBuilder(
              stream: appliedJob.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data.docs.length;
                  for (int i = 0; i < count; i++) {
                    selectedList.add(false);
                  }
                  for (int i = 0; i < count; i++) {
                    uidList.add(snapshot.data.docs[i].id);
                  }
                }
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: Card(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => StudentInfoComp(
                                            userEmail: snapshot.data.docs[index]
                                                .data()["userEmail"],
                                            jobid: snapshot.data.docs[index]
                                                .data()["jobid"],
                                            appliedID:
                                                snapshot.data.docs[index].id,
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
                                        clgName: snapshot.data.docs[index]
                                            .data()["clgName"],
                                        logo: snapshot.data.docs[index]
                                            .data()["logoUrl"],
                                        appliedID: snapshot.data.docs[index].id,
                                        status: snapshot.data.docs[index]
                                            .data()["status"],
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: selectedList[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedList[index] =
                                            !selectedList[index];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          Container(
            height: size.height * 0.1,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: DropdownButton<String>(
                items: <String>[
                  "APPLIED",
                  "CODING ROUND",
                  "GD ROUND",
                  "TECHNICAL INTERVIEW",
                  "HR INTERVIEW",
                  "ACCEPTED",
                  "REJECTED",
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          value,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                hint: Text(
                  "Select Status",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: commonStatus,
                onChanged: (value) {
                  setState(() {
                    commonStatus = value!;
                  });
                }),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          ElevatedButton(
              child: Text(
                "Update",
                style: GoogleFonts.aBeeZee(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black54,
                textStyle: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                List<String> _selectedList = [];
                for (int i = 0; i < selectedList.length; i++) {
                  if (selectedList[i]) {
                    _selectedList.add(uidList[i]);
                  }
                }
                if (_selectedList.length == 0) {
                  Get.snackbar(
                    "Alert",
                    "Please select atleast one applicant",
                    icon: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    backgroundColor: Colors.white,
                    colorText: Colors.red,
                    borderRadius: 10.0,
                    margin: EdgeInsets.all(10.0),
                    duration: Duration(seconds: 2),
                    animationDuration: Duration(seconds: 2),
                  );
                } else {
                  print(selectedList);
                  for (int i = 0; i < _selectedList.length; i++) {
                    if (commonStatus == "ACCEPTED") {
                      FirebaseFirestore.instance
                          .collection("Applied Jobs")
                          .doc(_selectedList[i])
                          .update({
                        "status": commonStatus,
                        "acceptedBy": "Done",
                      });
                    } else {
                      FirebaseFirestore.instance
                          .collection("Applied Jobs")
                          .doc(_selectedList[i])
                          .update({
                        "status": commonStatus,
                      });
                    }
                  }
                  Get.snackbar(
                    "Alert",
                    "Status Updated Successfully",
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    backgroundColor: Colors.white,
                    colorText: Colors.green,
                    borderRadius: 10.0,
                    margin: EdgeInsets.all(10.0),
                    duration: Duration(seconds: 2),
                    animationDuration: Duration(seconds: 2),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget buildApplyJob(
    Size size, {
    required String appliedName,
    required String designation,
    String logo = "",
    required String clgName,
    required String appliedID,
    required String status,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10.0),
      title: Text(
        appliedName,
        style: GoogleFonts.aBeeZee(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "Applied For " +
            designation +
            "\n" +
            "College : " +
            clgName +
            "\n" +
            "Status : " +
            status,
        style: GoogleFonts.aBeeZee(
          fontSize: 16.0,
        ),
      ),
    );
  }
}
