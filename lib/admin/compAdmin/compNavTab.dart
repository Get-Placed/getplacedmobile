import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/compAdmin/TrackJobs.dart';
import 'package:placement_cell/admin/compAdmin/compTrackInfo.dart';
import 'package:placement_cell/admin/compAdmin/createJob.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class CompNavTab extends StatefulWidget {
  final String logoUrl, owner, compName;
  const CompNavTab({
    Key? key,
    required this.owner,
    required this.compName,
    required this.logoUrl,
  });

  @override
  _CompNavTabState createState() => _CompNavTabState();
}

class _CompNavTabState extends State<CompNavTab> {
  int _selectedIndex = 0;
  AuthService _authService = AuthService();

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
    List<Widget> _widgets = [
      TrackJobs(
          owner: widget.owner,
          logoUrl: widget.logoUrl,
          compName: widget.compName),
      CreateJob(
        owner: widget.owner,
        logoUrl: widget.logoUrl,
        compName: widget.compName,
      ),
      // CompAnalytics(
      //     owner: widget.owner,
      //     logoUrl: widget.logoUrl,
      //     compName: widget.compName),
      CompInfoTrack(
        compName: widget.compName,
      ),
    ];
    return Scaffold(
      backgroundColor: k_themeColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            icon: Icon(Icons.list),
            label: "Job Profiles",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Create Job",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.analytics),
          //   label: "Colleges List",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart_outlined),
            label: "Job Status",
          ),
        ],
      ),
    );
  }
}
