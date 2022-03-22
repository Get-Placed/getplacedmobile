import 'package:flutter/material.dart';
import 'package:placement_cell/admin/CompAnalytics.dart';
import 'package:placement_cell/admin/collegeAdmin/AllJobsCollege.dart';
import 'package:placement_cell/admin/collegeAdmin/AllStudents.dart';
import 'package:placement_cell/admin/collegeAdmin/AllStudentsApplied.dart';
import 'package:placement_cell/admin/collegeAdmin/CollegeAnalytics.dart';
import 'package:placement_cell/admin/compAdmin/TrackJobs.dart';
import 'package:placement_cell/admin/compAdmin/compHome.dart';
import 'package:placement_cell/admin/compAdmin/compTrackInfo.dart';
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
  int _selectedIndex = 0;

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [
      CollegeAnalytics(collegeName: widget.clgName),
      AllStudents(clgName: widget.clgName),
      AllStudentsApplied(clgName: widget.clgName),
      AllJobsCollege(clgName: widget.clgName),
    ];
    return Scaffold(
      body: _widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTapped,
        selectedItemColor: k_btnColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Students List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Job Applications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart_outlined),
            label: "",
          ),
        ],
      ),
    );
  }
}
