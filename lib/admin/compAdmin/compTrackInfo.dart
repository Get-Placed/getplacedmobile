import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    print(widget.compName);
    appliedData = FirebaseFirestore.instance
        .collection("Applied Jobs")
        .where("compName", isEqualTo: widget.compName);
  }

  @override
  void initState() {
    super.initState();
    loadAppliedData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 8.0),
        Text(
          "Status",
          style: GoogleFonts.aBeeZee(
            fontSize: 24.0,
          ),
        ),
        SizedBox(height: 8.0),
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
                            name:
                                snapshot.data.docs[index].data()["appliedName"],
                            designation:
                                snapshot.data.docs[index].data()["designation"],
                            clgName:
                                snapshot.data.docs[index].data()["clgName"],
                            status: snapshot.data.docs[index].data()["status"]);
                      },
                    );
            },
          ),
        ),
      ],
    );
  }

  Padding buildStatusTile({
    required String name,
    required String designation,
    required String clgName,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
          subtitle: Text(clgName),
          trailing: Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
