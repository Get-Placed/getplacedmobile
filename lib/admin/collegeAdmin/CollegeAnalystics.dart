import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

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
      appBar: AppBar(
        title: const Text("College Analytics"),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff000000), Color(0xff7f8c8d)],
              stops: [0.5, 1.0],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    child: Text(
                      "Total Registered Students: $registeredStudents",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    child: Text(
                      "Total Job Offers: ${jobsData.length}",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
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
                      PieChart(
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
                      PieChart(
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
