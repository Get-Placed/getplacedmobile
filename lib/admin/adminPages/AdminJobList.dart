import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/adminPages/AdminCompanyDetails.dart';
import 'package:placement_cell/components/transition.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class AdminJobList extends StatefulWidget {
  @override
  _AdminJobListState createState() => _AdminJobListState();
}

class _AdminJobListState extends State<AdminJobList> {
  var jobData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadJobData();
  }

  loadJobData() {
    jobData = FirebaseFirestore.instance.collection("Jobs").snapshots();
  }

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: k_themeColor,
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
          "Active Jobs",
          style: GoogleFonts.aBeeZee(color: Colors.black, fontSize: 25.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: jobData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SizeRoute(
                                  page: AdminCompanyInfo(
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
                                    joblink: snapshot.data.docs[index]
                                        .data()["joblink"],
                                    cgpa: snapshot.data.docs[index]
                                        .data()["cgpa"],
                                    hsc:
                                        snapshot.data.docs[index].data()["hsc"],
                                    ssc:
                                        snapshot.data.docs[index].data()["ssc"],
                                    clgName: snapshot.data.docs[index]
                                        .data()["selClgVal"],
                                    jobID: snapshot.data.docs[index].id,
                                  ),
                                ),
                              );
                            },
                            child: buildJobCardD(
                              size: size,
                              colorBlack:
                                  index % 2 == 0 ? k_btnColor : Colors.white,
                              colorWhite:
                                  index % 2 == 0 ? Colors.white : k_btnColor,
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
                              logo: snapshot.data.docs[index].data()["logoUrl"],
                              owner: snapshot.data.docs[index].data()["owner"],
                              company:
                                  snapshot.data.docs[index].data()["compName"],
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
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
