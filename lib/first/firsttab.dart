import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/admin/collegeAdmin/AllStudentsApplied.dart';
import 'package:placement_cell/admin/collegeAdmin/CollegeNavTab.dart';
import 'package:placement_cell/admin/compAdmin/compNavTab.dart';
import 'package:placement_cell/admin/dashboard.dart';
import 'package:placement_cell/components/StudentController.dart';
import 'package:placement_cell/first/login.dart';
import 'package:placement_cell/first/signup.dart';
import 'package:placement_cell/pages/EmailVerified.dart';
import 'package:placement_cell/pages/home.dart';
import 'package:placement_cell/services/values.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class MainTab extends StatefulWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 1), onDoneLoading);
  }

  StudentController controller = Get.put(StudentController());
  void onDoneLoading() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser!.email)
        .get()
        .then((doc) {
      var userdata = doc.data();
      print(userdata);
      bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (!isEmailVerified) {
        print("Email Verified");
        Get.to(EmailVerified());
      } else if (userdata!['role'] == 0) {
        print(userdata["role"]);
        controller.setStudent(userdata);
        Get.to(() => Home(
              clgName: userdata['userFrom'],
              userName: userdata['userName'],
              userEmail: userdata['email'],
              dob: userdata['dob'],
              cgpa: userdata['cgpa'],
              yoc: userdata['yoc'],
              resume: userdata['resume'] ?? "NA",
              photo: userdata['photo'] ?? "NA",
            ));
      } else if (userdata['role'] == 4) {
        print(userdata['userName']);
        Get.to(() => CompNavTab(
              owner: userdata['userName'],
              logoUrl: userdata['compLogoUrl'],
              compName: userdata["userFrom"],
            ));
      } else if (userdata['role'] == 3) {
        print(userdata['role']);
        Get.to(() => Dashboard());
      } else if (userdata['role'] == 2) {
        print(userdata['role']);
        Get.to(
          () => CollegeNavTab(
            clgName: userdata['userFrom'],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: k_themeColor,
            title: Text(
              "GetPlaced",
              style: TextStyle(
                color: k_btnColor,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            bottom: TabBar(
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: k_btnColor,
              ),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Signup",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Login(),
              Signup(),
            ],
          ),
        ),
      ),
    );
  }
}
