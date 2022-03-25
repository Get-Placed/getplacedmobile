import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/admin/adminPages/createClgAcc.dart';
import 'package:placement_cell/admin/adminPages/createCollege.dart';
import 'package:placement_cell/admin/adminPages/createCompAcc.dart';
import 'package:placement_cell/admin/adminPages/createCompany.dart';
import 'package:placement_cell/services/values.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: k_btnColor,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 30.0,
              ),
              title: Text(
                "Admin Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            ListTile(
              onTap: () {
                Get.to(() => CreateCollege());
              },
              leading: Icon(
                Icons.school_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Create College",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => CreateCompanies());
              },
              leading: Icon(
                Icons.business_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Create Company",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ClgAccount());
              },
              leading: Icon(
                Icons.person_add_alt_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Add College User",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => CompAccount());
              },
              leading: Icon(
                Icons.person_add_alt_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Add Company User",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
