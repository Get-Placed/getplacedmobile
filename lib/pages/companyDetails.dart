import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/services/database.dart';
import 'package:placement_cell/services/values.dart';

class CompanyInfo extends StatefulWidget {
  final String designation,
      lpa,
      time,
      logo,
      owner,
      compName,
      qual1,
      qual2,
      abt1,
      abt2,
      jobID,
      userName,
      clgName,
      userEmail;

  const CompanyInfo({
    Key? key,
    required this.designation,
    required this.time,
    required this.lpa,
    required this.logo,
    required this.owner,
    required this.compName,
    required this.qual1,
    required this.qual2,
    required this.abt1,
    required this.abt2,
    required this.jobID,
    required this.userName,
    required this.clgName,
    required this.userEmail,
  });

  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  String appliedID = "";
  DataService _dataService = DataService();
  void applyForJob() {
    setState(() {
      appliedID = widget.jobID + widget.userEmail;
    });
    Map<String, dynamic> appliedJobData = {
      "appliedName": widget.userName,
      "clgName": widget.clgName,
      "designation": widget.designation,
      "logoUrl": widget.logo,
      "compName": widget.compName,
      "owner": widget.owner,
      "userEmail": widget.userEmail,
      "jobid": widget.jobID,
      "acceptedBy": "user ${widget.clgName}",
    };
    _dataService.appliedJobs(appliedJobData, appliedID).then((value) {
      Get.snackbar(
          widget.compName, "Job has been applied for ${widget.designation}");
      loadData();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool dataAvailable = true;

  loadData() async {
    setState(() {
      appliedID = widget.jobID + widget.userEmail;
    });
    await FirebaseFirestore.instance
        .collection("Applied Jobs")
        .doc(appliedID)
        .get()
        .then((doc) {
      print("here it is $doc");
      if (doc.exists) {
        setState(() {
          dataAvailable = !dataAvailable;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final sizedH1 = SizedBox(
      height: size.height * 0.03,
    );
    return Scaffold(
      backgroundColor: k_themeColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 200.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  "https://image.freepik.com/free-vector/recruit-agent-analyzing-candidates_74855-4565.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              leading: InkWell(
                onTap: () {
                  Get.back();
                  print("back");
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: k_btnColor,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildJobCard(
                size: size,
                jobName: widget.designation,
                lpa: widget.lpa,
                time: widget.time,
                logo: widget.logo,
                owner: widget.owner,
                company: widget.compName,
              ),
              sizedH1,
              detailCard(
                size: size,
                header: "Qualifications",
                info1: widget.qual1,
                info2: widget.qual2,
              ),
              sizedH1,
              detailCard(
                size: size,
                header: "About the Job",
                info1: widget.abt1,
                info2: widget.abt2,
              ),
              sizedH1,
              ElevatedButton.icon(
                onPressed: dataAvailable ? applyForJob : null,
                icon: Icon(
                  Icons.analytics,
                  size: 30.0,
                ),
                label: Text(
                  dataAvailable ? "Apply" : "Applied",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 30.0,
                  ),
                  primary: Colors.black,
                ),
              ),
              sizedH1,
            ],
          ),
        ),
      ),
    );
  }

  Widget bulletCircle() {
    return Container(
      height: 5.0,
      width: 5.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget detailCard({
    required Size size,
    required String header,
    required String info1,
    required String info2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  bottom: 12.0,
                ),
                child: Text(
                  header,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              ListTile(
                minLeadingWidth: 10,
                leading: bulletCircle(),
                title: Text(
                  info1,
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              ListTile(
                minLeadingWidth: 10,
                leading: bulletCircle(),
                title: Text(
                  info2,
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildJobCard({
    required Size size,
    required String jobName,
    required String lpa,
    required String time,
    required String logo,
    required String owner,
    required String company,
  }) {
    Color colorWhite = Colors.white;
    Color colorBlack = k_btnColor;
    return Container(
      color: colorWhite,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                jobName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  color: colorBlack,
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
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: colorBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.logo == ""
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
                SizedBox(
                  width: size.width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: colorBlack,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      owner,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
