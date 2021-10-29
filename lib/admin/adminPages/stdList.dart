import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:placement_cell/services/values.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  var stdData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
    );
    loadstdList();
  }

  loadstdList() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .where("role", isEqualTo: 0)
        .get()
        .then((value) {
      setState(() {
        stdData = value;
        isLoading = false;
      });
      print(stdData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: k_btnColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : InteractiveViewer(
              constrained: false,
              child: Column(
                children: <Widget>[
                  DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                          ),
                        ),
                        numeric: false,
                        tooltip: "Full Name",
                      ),
                      DataColumn(
                        label: Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                          ),
                        ),
                        numeric: false,
                        tooltip: "Email",
                      ),
                      DataColumn(
                        label: Text(
                          "College Name",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                          ),
                        ),
                        numeric: false,
                        tooltip: "College Name",
                      ),
                    ],
                    rows: stdData.docs.map<DataRow>(
                      (doc) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                doc["userName"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                doc["email"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                doc["userFrom"],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
