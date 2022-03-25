import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/components/drawer.dart';
import 'package:placement_cell/components/transition.dart';
import 'package:placement_cell/pages/companyDetails.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class Home extends StatefulWidget {
  final String clgName;
  final String userName, userEmail, dob, cgpa, yoc, branch, resume, photo;
  const Home({
    Key? key,
    required this.clgName,
    required this.userName,
    required this.userEmail,
    required this.cgpa,
    required this.dob,
    required this.yoc,
    required this.branch,
    required this.resume,
    required this.photo,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var jobData;
  var salaryData;
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
    print(jobData);
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
          resume: widget.resume,
          photo: widget.photo,
        ),
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
                  style: GoogleFonts.aBeeZee(
                    color: k_btnColor,
                    fontSize: 30.0,
                  ),
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                                            .data()["aSalary"]
                                            .toString(),
                                        userEmail: widget.userEmail,
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
                                        joblink: snapshot.data.docs[index]
                                            .data()["joblink"],
                                        cgpa: snapshot.data.docs[index]
                                            .data()["cgpa"],
                                        hsc: snapshot.data.docs[index]
                                            .data()["hsc"],
                                        ssc: snapshot.data.docs[index]
                                            .data()["ssc"],
                                        jobID: snapshot.data.docs[index].id,
                                        userName: widget.userName,
                                        clgName: widget.clgName,
                                        branch: widget.branch,
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
                                      .data()["aSalary"]
                                      .toString(),
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
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      child: Card(
        elevation: 8.0,
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
