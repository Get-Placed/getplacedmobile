import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:placement_cell/admin/adminPages/AdminJobList.dart';
import 'package:placement_cell/admin/adminPages/stdList.dart';
import 'package:placement_cell/components/adminDrawer.dart';
import 'package:placement_cell/pages/regCompanies.dart';
import 'package:placement_cell/services/auth.dart';

import 'package:placement_cell/services/values.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int stdReg = 00;
  int jobReg = 00;
  int compReg = 00;
  int clgReg = 00;
  NumberFormat formatter = new NumberFormat("00");
  @override
  void initState() {
    super.initState();
    loadStdsCount();
    loadJobsCount();
    loadCompanyCount();
    loadCollegeCount();
  }

  AuthService _authService = AuthService();

  loadStdsCount() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .where(
          "role",
          isEqualTo: 0,
        )
        .get()
        .then((value) {
      setState(() {
        stdReg = value.docs.length;
      });
    });
  }

  loadJobsCount() async {
    await FirebaseFirestore.instance.collection("Jobs").get().then(
      (value) {
        setState(() {
          jobReg = value.docs.length;
        });
      },
    );
  }

  loadCompanyCount() async {
    await FirebaseFirestore.instance.collection("Company").get().then(
      (value) {
        setState(() {
          compReg = value.docs.length;
        });
      },
    );
  }

  loadCollegeCount() async {
    await FirebaseFirestore.instance.collection("Colleges").get().then(
      (value) {
        setState(() {
          clgReg = value.docs.length;
        });
      },
    );
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
    final sizedH1 = SizedBox(
      height: size.height * 0.1,
    );
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _onBackPressed();
        return shouldPop ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AdminDrawer(),
        backgroundColor: k_themeColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.near_me_outlined,
                    color: Colors.orange.shade800,
                    size: 35.0,
                  ),
                ),
                TextSpan(
                  text: "GetPlaced",
                  style: GoogleFonts.aBeeZee(color: k_btnColor, fontSize: 30.0),
                ),
              ],
            ),
          ),
          centerTitle: true,
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
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                sizedH1,
                InkWell(
                  onTap: () {
                    Get.to(
                      () => StudentList(),
                    );
                  },
                  child: adminCard(
                    size,
                    label: "Students Registered",
                    count: "${formatter.format(stdReg)}",
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => AdminJobList(),
                    );
                  },
                  child: adminCard(
                    size,
                    label: "Active Jobs",
                    count: "${formatter.format(jobReg)}",
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                InkWell(
                  onTap: () {
                    // Get.to(
                    //   () => AdminJobList(),
                    // );
                    Get.to(() => RegisteredCompanies());
                  },
                  child: adminCard(
                    size,
                    label: "Active Companies",
                    count: "${formatter.format(compReg)}",
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                InkWell(
                  onTap: () {
                    // Get.to(
                    //   () => AdminJobList(),
                    // );
                  },
                  child: adminCard(
                    size,
                    label: "Active Colleges",
                    count: "${formatter.format(clgReg)}",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget adminCard(
    Size size, {
    required String label,
    required String count,
  }) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: size.height * 0.2,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: [
              Color(0xFF00F5A0),
              Color(0xFF00D9F5),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                count,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 60.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
