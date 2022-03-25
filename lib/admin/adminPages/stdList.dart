import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/collegeAdmin/StudentPage.dart';
import 'package:placement_cell/services/values.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  var stdData;
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
        .get()
        .then((value) {
      setState(() {
        stdData = value;
        isLoading = false;
      });
      print(stdData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: k_btnColor,
          ),
        ),
        title: Text(
          "Students Registered",
          style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 25.0),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: stdData.docs.map<Widget>((doc) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Text(doc['userName']),
                      subtitle: Text(doc['email']),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Get.to(StudentPage(userEmail: doc['email']));
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
