import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:placement_cell/services/values.dart';

class CollegeAnalytics extends StatefulWidget {
  final String collegeName;
  const CollegeAnalytics({Key? key, required this.collegeName})
      : super(key: key);

  @override
  _CollegeAnalyticsState createState() => _CollegeAnalyticsState();
}

class _CollegeAnalyticsState extends State<CollegeAnalytics> {
  late int registeredStudents;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> jobsData;
  late int totalOffers;
  Map<String, double> companyCount = {};
  Map<String, double> branchCount = {};
  bool isLoading = true;

  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var studentData = await FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: 0)
        .where("userFrom", isEqualTo: widget.collegeName)
        .get();
    registeredStudents = studentData.docs.length;

    var snapshot = await FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("clgName", isEqualTo: widget.collegeName)
        .where("status", isEqualTo: "ACCEPTED")
        .get();
    jobsData = snapshot.docs;

    for (int i = 0; i < jobsData.length; i++) {
      String compName = jobsData[i].data()["compName"];
      String branch = jobsData[i].data()["branch"];
      companyCount.update(compName, (value) => value + 1, ifAbsent: () => 1);
      branchCount.update(branch, (value) => value + 1, ifAbsent: () => 1);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: k_themeColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                Text(
                  "Analytics",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(fontSize: 25.0),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 8.0),
                              child: Text(
                                "Total Students:",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 8.0),
                              child: Text(
                                "$registeredStudents",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 50.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 8.0),
                              child: Text(
                                "Job Offers:",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 8.0),
                              child: Text(
                                "${jobsData.length}",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 50.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        "Company-wise Placement",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      jobsData.length == 0
                          ? Text(
                              "No Data Available",
                              style: GoogleFonts.aBeeZee(
                                fontSize: 20.0,
                              ),
                            )
                          : PieChart(
                              dataMap: companyCount,
                              chartValuesOptions: ChartValuesOptions(
                                decimalPlaces: 0,
                                chartValueStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              legendOptions: LegendOptions(
                                legendPosition: LegendPosition.bottom,
                                showLegendsInRow: true,
                                legendTextStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(height: 8.0),
                Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        "Branch-wise Placement",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      jobsData.length == 0
                          ? Text(
                              "No Data Available",
                              style: GoogleFonts.aBeeZee(
                                fontSize: 20.0,
                              ),
                            )
                          : PieChart(
                              dataMap: branchCount,
                              chartValuesOptions: ChartValuesOptions(
                                decimalPlaces: 0,
                                chartValueStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              legendOptions: LegendOptions(
                                legendPosition: LegendPosition.bottom,
                                showLegendsInRow: true,
                                legendTextStyle: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
    );
  }
}
