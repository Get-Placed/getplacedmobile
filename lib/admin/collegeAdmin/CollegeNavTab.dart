import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/collegeAdmin/AllJobsCollege.dart';
import 'package:placement_cell/admin/collegeAdmin/AllStudents.dart';
import 'package:placement_cell/admin/collegeAdmin/AllStudentsApplied.dart';
import 'package:placement_cell/admin/collegeAdmin/CollegeAnalytics.dart';
import 'package:placement_cell/admin/collegeAdmin/createNotices.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class CollegeNavTab extends StatefulWidget {
  final String clgName;

  const CollegeNavTab({
    Key? key,
    required this.clgName,
  });

  @override
  _CollegeNavTabState createState() => _CollegeNavTabState();
}

class _CollegeNavTabState extends State<CollegeNavTab> {
  AuthService _authService = AuthService();
  int _selectedIndex = 1;

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        content: Text("You will be logged out of Session!"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("OK"),
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
    List<Widget> _widgets = [
      AllStudents(clgName: widget.clgName),
      CollegeAnalytics(collegeName: widget.clgName),
      AllStudentsApplied(clgName: widget.clgName),
    ];
    return Scaffold(
      backgroundColor: k_themeColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              _onBackPressed();
            },
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: k_btnColor,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.school, color: k_themeColor, size: 30.0),
                title: const Text(
                  "College Login",
                  style: TextStyle(color: k_themeColor, fontSize: 25.0),
                ),
              ),
              SizedBox(height: 10.0),
              // Divider(color: k_themeColor, height: 2.0, thickness: 1.5),
              ListTile(
                leading: Icon(Icons.work, color: k_themeColor),
                title: const Text(
                  "Jobs Available",
                  style: TextStyle(color: k_themeColor, fontSize: 18.0),
                ),
                onTap: () => Get.to(AllJobsCollege(clgName: widget.clgName)),
              ),
              ListTile(
                leading: Icon(Icons.create, color: k_themeColor),
                title: const Text(
                  "Create Notice",
                  style: TextStyle(color: k_themeColor, fontSize: 18.0),
                ),
                onTap: () => Get.to(CreateNotices(clgName: widget.clgName)),
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          final shouldPop = await _onBackPressed();

          return shouldPop ?? false;
        },
        child: _widgets.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTapped,
        selectedItemColor: k_btnColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Students List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Job Applications",
          ),
        ],
      ),
    );
  }
}
