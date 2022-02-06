import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/pages/jobStatus.dart';
import 'package:placement_cell/pages/notices.dart';
import 'package:placement_cell/pages/regCompanies.dart';
import 'package:placement_cell/pages/updatePro.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class MyDrawer extends StatefulWidget {
  final String userName, userEmail, clgName, dob, cgpa, yoc, resume, photo;
  const MyDrawer({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.clgName,
    required this.dob,
    required this.cgpa,
    required this.yoc,
    required this.resume,
    required this.photo,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: k_btnColor,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 35.0,
              ),
              title: Text(
                "Welcome ${widget.userName}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(
                  () => UpdateProfile(
                    userName: widget.userName,
                    userEmail: widget.userEmail,
                    dob: widget.dob,
                    cgpa: widget.cgpa,
                    yoc: widget.yoc,
                    resume: widget.resume,
                    photo: widget.photo,
                  ),
                );
              },
              leading: Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => Notices(
                      clgName: widget.clgName,
                    ));
              },
              leading: Icon(
                Icons.feed_outlined,
                color: Colors.white,
              ),
              title: Text(
                "Feeds",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(
                  () => RegisteredCompanies(),
                );
              },
              leading: Icon(
                Icons.business_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Companies",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => JobStatus(
                      userEmail: widget.userEmail,
                    ));
              },
              leading: Icon(
                Icons.track_changes_outlined,
                color: Colors.white,
              ),
              title: Text(
                "Job Status",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _authService.signOut().then(
                  (value) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                );
              },
              leading: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
