import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/collegeAdmin/createNotices.dart';
import 'package:placement_cell/admin/collegeAdmin/stdJobInfo.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class CollegeHome extends StatefulWidget {
  final String clgName;
  const CollegeHome({
    Key? key,
    required this.clgName,
  });

  @override
  _CollegeHomeState createState() => _CollegeHomeState();
}

class _CollegeHomeState extends State<CollegeHome> {
  late Query appliedJob;
  AuthService _authService = AuthService();
  loadData() {
    appliedJob = FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("acceptedBy", isEqualTo: "user ${widget.clgName}");
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _onBackPressed();

        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: k_themeColor,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _onBackPressed();
              },
              icon: Icon(
                Icons.power_settings_new_outlined,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Text(
              "Applied Jobs List",
              style: GoogleFonts.aBeeZee(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: appliedJob.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(
                                    () => StudentJobInfo(
                                      userEmail: snapshot.data.docs[index]
                                          .data()["userEmail"],
                                      jobid: snapshot.data.docs[index]
                                          .data()["jobid"],
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
                                  compName: snapshot.data.docs[index]
                                      .data()["compName"],
                                  compOwner:
                                      snapshot.data.docs[index].data()["owner"],
                                  logo: snapshot.data.docs[index]
                                      .data()["logoUrl"],
                                  appliedID: snapshot.data.docs[index].id,
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => CreateNotices(
                  clgName: widget.clgName,
                ));
          },
          backgroundColor: k_btnColor,
          child: Icon(
            Icons.add,
          ),
        ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        bottom: 10.0,
      ),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                appliedName,
                style: GoogleFonts.ubuntu(
                  fontSize: 30.0,
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
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
