import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/admin/adminPages/createCollege.dart';
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
              onTap: () {
                Get.to(() => CreateCollege());
              },
              leading: Icon(
                Icons.school_rounded,
                color: Colors.white,
              ),
              title: Text(
                "Create Colleges",
                style: TextStyle(
                  color: Colors.white,
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
                "Create Companies",
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
