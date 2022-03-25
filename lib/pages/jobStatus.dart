import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class JobStatus extends StatefulWidget {
  final String userEmail;
  const JobStatus({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  _JobStatusState createState() => _JobStatusState();
}

class _JobStatusState extends State<JobStatus> {
  late Query appliedData;
  loadAppliedData() {
    appliedData = FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("userEmail", isEqualTo: widget.userEmail);
  }

  @override
  void initState() {
    super.initState();
    loadAppliedData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Text(
          "Job Status",
          style: GoogleFonts.aBeeZee(
            fontSize: 30.0,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.02,
          ),
          Expanded(
            child: StreamBuilder(
              stream: appliedData.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          print("object");
                          print(
                            snapshot.data.docs[index].data()["appliedName"],
                          );
                          return buildStatusTile(
                              name: snapshot.data.docs[index]
                                  .data()["appliedName"],
                              designation: snapshot.data.docs[index]
                                  .data()["designation"],
                              compName:
                                  snapshot.data.docs[index].data()["compName"],
                              status:
                                  snapshot.data.docs[index].data()["status"]);
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding buildStatusTile({
    required String name,
    required String designation,
    required String compName,
    required String status,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "$name ",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "($designation)",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(compName),
          trailing: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
