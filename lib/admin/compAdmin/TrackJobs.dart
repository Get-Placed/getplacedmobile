import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/admin/compAdmin/compHome.dart';
import 'package:placement_cell/services/values.dart';

class TrackJobs extends StatefulWidget {
  final String owner, logoUrl, compName;
  const TrackJobs({
    Key? key,
    required this.owner,
    required this.logoUrl,
    required this.compName,
  });

  @override
  _TrackJobsState createState() => _TrackJobsState();
}

class _TrackJobsState extends State<TrackJobs> {
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
        .where("compName", isEqualTo: widget.compName)
        .snapshots();
    print(jobData);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        SizedBox(height: 8.0),
        Text(
          "Job Profiles",
          style: GoogleFonts.aBeeZee(
            fontSize: 24.0,
          ),
        ),
        SizedBox(height: 8.0),
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
                            Get.to(() => CompanyHome(
                                  owner: widget.compName,
                                  logoUrl: widget.logoUrl,
                                  compName: widget.compName,
                                  jobID: snapshot.data.docs[index].id,
                                ));
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
                            jobName:
                                snapshot.data.docs[index].data()["designation"],
                            lpa: snapshot.data.docs[index]
                                .data()["aSalary"]
                                .toString(),
                            time:
                                snapshot.data.docs[index].data()["_timeValue"],
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
