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
  var studentData;
  var _sscAverage = 0.0;
  var _hscAverage = 0.0;
  var _cgpaAverage = 0.0;
  var totalJobsApplied = 0;
  var totalJobsSelected = 0;
  var jobsData;
  @override
  void initState() {
    super.initState();
    getStudentData();
    getJobData();
  }

  getJobData() async {
    await FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("clgName", isEqualTo: widget.collegeName)
        .get()
        .then((value) {
      setState(() {
        totalJobsApplied = value.docs.length;
        jobsData = value.docs;
      });
    });
    for (var i = 0; i < jobsData.length; i++) {
      if (jobsData[i].data()["status"] == "ACCEPTED") {
        totalJobsSelected++;
      }
    }
  }

  getStudentData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: 0)
        .where("userFrom", isEqualTo: widget.collegeName)
        .get()
        .then(
      (value) {
        setState(() {
          studentData = value.docs;
        });
      },
    );
    getsscAverage();
    getHscAverage();
    getCgpaAverage();
  }

  getsscAverage() {
    int sum = 0;
    for (var i = 0; i < studentData.length; i++) {
      print(studentData[i].data()["email"] + studentData[i].data()["ssc"]);
      sum += int.tryParse(studentData[i].data()['ssc'])!;
    }
    _sscAverage = sum / studentData.length;
  }

  getHscAverage() {
    int sum = 0;
    for (var i = 0; i < studentData.length; i++) {
      print(studentData[i].data()["email"] + studentData[i].data()["hsc"]);
      sum += int.tryParse(studentData[i].data()['hsc'])!;
    }
    _hscAverage = sum / studentData.length;
  }

  getCgpaAverage() {
    int sum = 0;
    for (var i = 0; i < studentData.length; i++) {
      print(studentData[i].data()["email"] + studentData[i].data()["cgpa"]);
      sum += int.tryParse(studentData[i].data()['cgpa'])!;
    }
    _cgpaAverage = sum / studentData.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("College Analytics",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff4338CA),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff000000), Color(0xff7f8c8d)],
              stops: [0.5, 1.0],
            ),
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     elevation: 10,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           "Total Jobs Applied: $totalJobsApplied",
            //           style: GoogleFonts.montserrat(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Card(
            //     elevation: 10,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           "Total Jobs Selected: $totalJobsSelected",
            //           style: GoogleFonts.montserrat(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "SSC Average : " + _sscAverage.toString() + "%",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "HSC Average : " + _hscAverage.toString() + "%",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CGPA Average : " + _cgpaAverage.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Total Students : " + studentData.length.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Jobs Analytics",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            // Make a pie chart for the data
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PieChart(
                      dataMap: {
                        'Jobs Applied':
                            double.parse(totalJobsApplied.toString()),
                        'Jobs Selected':
                            double.parse(totalJobsSelected.toString()),
                      },
                      chartType: ChartType.disc,
                      colorList: [
                        Colors.blue,
                        Colors.green,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Make a pie chart using fl_chart
          ],
        ),
      ),
    );
  }
}
