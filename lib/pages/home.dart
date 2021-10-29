import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/components/drawer.dart';
import 'package:placement_cell/components/transition.dart';
import 'package:placement_cell/pages/companyDetails.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class Home extends StatefulWidget {
  final String clgName;
  final String userName, userEmail, dob, cgpa, yoc;
  const Home({
    Key? key,
    required this.clgName,
    required this.userName,
    required this.userEmail,
    required this.cgpa,
    required this.dob,
    required this.yoc,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var jobData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadJobData();
  }

  loadJobData() {
    jobData = FirebaseFirestore.instance
        .collection("Jobs")
        .where("selClgVal", isEqualTo: widget.clgName)
        .snapshots();
  }

  AuthService _authService = AuthService();

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
        key: _scaffoldKey,
        backgroundColor: k_themeColor,
        drawer: MyDrawer(
          userName: widget.userName,
          userEmail: widget.userEmail,
          clgName: widget.clgName,
          dob: widget.dob,
          cgpa: widget.cgpa,
          yoc: widget.yoc,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Icon(
                  Icons.menu_rounded,
                  color: k_btnColor,
                ),
              ),
            ),
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.04,
                ),
                StreamBuilder(
                  stream: jobData,
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
                                  Navigator.push(
                                    context,
                                    SizeRoute(
                                      page: CompanyInfo(
                                        designation: snapshot.data.docs[index]
                                            .data()["designation"],
                                        time: snapshot.data.docs[index]
                                            .data()["_timeValue"],
                                        lpa: snapshot.data.docs[index]
                                            .data()["aSalary"],
                                        logo: snapshot.data.docs[index]
                                            .data()["logoUrl"],
                                        owner: snapshot.data.docs[index]
                                            .data()["owner"],
                                        compName: snapshot.data.docs[index]
                                            .data()["compName"],
                                        qual1: snapshot.data.docs[index]
                                            .data()["qual1"],
                                        qual2: snapshot.data.docs[index]
                                            .data()["qual2"],
                                        abt1: snapshot.data.docs[index]
                                            .data()["abtJob1"],
                                        abt2: snapshot.data.docs[index]
                                            .data()["abtJob2"],
                                        jobID: snapshot.data.docs[index].id,
                                        userName: widget.userName,
                                        clgName: widget.clgName,
                                        userEmail: widget.userEmail,
                                      ),
                                    ),
                                  );
                                },
                                child: buildJobCardD(
                                  size: size,
                                  colorBlack: index % 2 == 0
                                      ? k_btnColor
                                      : Colors.white,
                                  colorWhite: index % 2 == 0
                                      ? Colors.white
                                      : k_btnColor,
                                  timeColor: index % 2 == 0
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300,
                                  jobName: snapshot.data.docs[index]
                                      .data()["designation"],
                                  lpa: snapshot.data.docs[index]
                                      .data()["aSalary"],
                                  time: snapshot.data.docs[index]
                                      .data()["_timeValue"],
                                  logo: snapshot.data.docs[index]
                                      .data()["logoUrl"],
                                  owner:
                                      snapshot.data.docs[index].data()["owner"],
                                  company: snapshot.data.docs[index]
                                      .data()["compName"],
                                ),
                              );
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJobCardD({
    required Size size,
    required String jobName,
    required String lpa,
    required String time,
    String logo = "",
    required String owner,
    required String company,
    Color colorWhite = k_btnColor,
    Color colorBlack = Colors.white,
    Color? timeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        bottom: 20.0,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        color: colorBlack,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  jobName,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: colorWhite,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "₹$lpa / year",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    color: timeColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: colorWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorWhite,
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
                  company,
                  style: GoogleFonts.poppins(
                    fontSize: 17.0,
                    color: colorWhite,
                  ),
                ),
                subtitle: Text(
                  owner,
                  style: GoogleFonts.poppins(
                    color: colorWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}