import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/services/auth.dart';

class CompInfoTrack extends StatefulWidget {
  final String compName;
  const CompInfoTrack({
    Key? key,
    required this.compName,
  });

  @override
  _CompInfoTrackState createState() => _CompInfoTrackState();
}

class _CompInfoTrackState extends State<CompInfoTrack> {
  AuthService _authService = AuthService();
  late Query appliedData;
  loadAppliedData() {
    appliedData = FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("acceptedBy", isEqualTo: "Done");
  }

  @override
  void initState() {
    super.initState();
    loadAppliedData();
  }

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
                    (value) => Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    ),
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
        appBar: AppBar(
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _onBackPressed();
              },
              icon: Icon(
                Icons.power_settings_new_outlined,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "Status",
              style: GoogleFonts.aBeeZee(
                fontSize: 24.0,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: appliedData.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
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
                                clgName:
                                    snapshot.data.docs[index].data()["clgName"],
                                status: snapshot.data.docs[index]
                                            .data()["status"] ==
                                        1
                                    ? "Accepted"
                                    : "Rejected",
                                statusColor: snapshot.data.docs[index]
                                            .data()["status"] ==
                                        1
                                    ? Colors.green
                                    : Colors.red,
                              );
                            },
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildStatusTile({
    required String name,
    required String designation,
    required String clgName,
    required String status,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 5.0,
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
          subtitle: Text(clgName),
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
