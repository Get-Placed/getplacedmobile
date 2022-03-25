import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompAnalytics extends StatefulWidget {
  final String owner, logoUrl, compName;
  CompAnalytics(
      {Key? key,
      required this.owner,
      required this.logoUrl,
      required this.compName})
      : super(key: key);

  @override
  _CompAnalyticsState createState() => _CompAnalyticsState();
}

class _CompAnalyticsState extends State<CompAnalytics> {
  late Query appliedJob;

  loadData() {
    appliedJob = FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("compName", isEqualTo: "${widget.compName}");
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Text(
                "Applied Jobs Analytics",
                style: GoogleFonts.aBeeZee(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        StreamBuilder(
          stream: appliedJob.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var total;
            var _colleges;
            var totalSelectd = 0;
            if (snapshot.hasData) {
              total = snapshot.data.docs.length;
              _colleges = snapshot.data.docs
                  .map((doc) => doc.data()['clgName'])
                  .toSet()
                  .toList();
            }
            if (snapshot.hasData) {
              var statusList = snapshot.data.docs
                  .map((doc) => doc.data()['status'])
                  .toList();
              for (var i = 0; i < statusList.length; i++) {
                if (statusList[i] == "ACCEPTED") {
                  totalSelectd++;
                }
              }
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Total Applied Jobs: ${total}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Total Selected For Jobs: ${totalSelectd}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Colleges Applied",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: _colleges.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            "${_colleges[index]}",
                            style: GoogleFonts.aBeeZee(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
