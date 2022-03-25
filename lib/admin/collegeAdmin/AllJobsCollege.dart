import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/services/values.dart';

class AllJobsCollege extends StatefulWidget {
  final String clgName;
  const AllJobsCollege({
    Key? key,
    required this.clgName,
  });

  @override
  _AllJobsCollegeState createState() => _AllJobsCollegeState();
}

class _AllJobsCollegeState extends State<AllJobsCollege> {
  late Query appliedJob;

  loadData() {
    appliedJob = FirebaseFirestore.instance
        .collection("Jobs")
        .where("selClgVal", isEqualTo: "${widget.clgName}");
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: k_themeColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: k_btnColor),
        backgroundColor: k_themeColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: k_btnColor,
          ),
        ),
        title: const Text(
          "Jobs Available",
          style: TextStyle(color: k_btnColor, fontSize: 25.0),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: appliedJob.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildApplyJob(
                            size,
                            designation:
                                snapshot.data.docs[index].data()["designation"],
                            compName:
                                snapshot.data.docs[index].data()["compName"],
                            compOwner:
                                snapshot.data.docs[index].data()["owner"],
                            logo: snapshot.data.docs[index].data()["logoUrl"],
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

  Widget buildApplyJob(
    Size size, {
    required String designation,
    String logo = "",
    required String compName,
    required String compOwner,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      child: Card(
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                "Job Role",
                style: GoogleFonts.poppins(),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                designation,
                style: GoogleFonts.aBeeZee(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
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
                  compName,
                  style: GoogleFonts.poppins(
                    fontSize: 17.0,
                  ),
                ),
                subtitle: Text(
                  compOwner,
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
