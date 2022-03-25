import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/components/widgets/widgets.dart';
import 'package:placement_cell/services/database.dart';
import 'package:placement_cell/services/values.dart';

class CreateJob extends StatefulWidget {
  final String owner, logoUrl, compName;
  const CreateJob({
    Key? key,
    required this.owner,
    required this.logoUrl,
    required this.compName,
  });

  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  final _formKey = GlobalKey<FormState>();
  late Query clgData;
  @override
  void initState() {
    super.initState();
    loadClgData();
  }

  loadClgData() {
    clgData = FirebaseFirestore.instance.collection("Colleges");
  }

  DataService _dataService = DataService();
  String designation = "",
      aSalary = "",
      qual1 = "",
      qual2 = "",
      abtJob1 = "",
      abtJob2 = "",
      ssc = "",
      hsc = "",
      joblink = "",
      cgpa = "";
  var selClgVal;
  String _timeValue = "Full Time";

  createJob() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (int.parse(ssc) > 100 ||
          int.parse(hsc) > 100 ||
          int.parse(cgpa) > 10) {
        Get.snackbar("Error", "Invalid CGPA");

        return;
      }
      Map<String, dynamic> jobData = {
        "selClgVal": selClgVal,
        "designation": designation,
        "_timeValue": _timeValue,
        "aSalary": aSalary,
        "qual1": qual1,
        "qual2": qual2,
        "ssc": int.parse(ssc),
        "hsc": int.parse(hsc),
        "cgpa": int.parse(cgpa),
        "joblink": joblink,
        "abtJob1": abtJob1,
        "abtJob2": abtJob2,
        "owner": widget.owner,
        "logoUrl": widget.logoUrl,
        "compName": widget.compName,
        "status": 0,
      };
      _dataService.createJob(jobData).then((value) {
        Get.snackbar("$designation Job", "has been created!!");
        _formKey.currentState!.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Center(child: buildHeaderText(start: "Create ", end: "Job")),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: StreamBuilder(
                  stream: clgData.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.only(
                              top: 16.0,
                            ),
                            child: DropdownButtonFormField(
                              validator: (value) => value == null
                                  ? 'Please select the College'
                                  : null,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              value: selClgVal,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  selClgVal = value;
                                });
                              },
                              hint: Text('Choose College'),
                              items: snapshot.data.docs
                                  .map<DropdownMenuItem<String>>((doc) {
                                return DropdownMenuItem<String>(
                                  value: doc.data()["clgName"],
                                  child: Text("${doc.data()["clgName"]}"),
                                );
                              }).toList(),
                            ),
                          );
                  },
                ),
              ),
            ),
            buildFormField(
              label: "Designation",
              onChange: (value) {
                designation = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Requirements",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            buildFormField(
              label: "SSC%",
              onChange: (value) {
                ssc = value;
              },
            ),
            buildFormField(
              label: "HSC%",
              onChange: (value) {
                hsc = value;
              },
            ),
            buildFormField(
              label: "CGPA",
              onChange: (value) {
                cgpa = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "External Link",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildFormField(
              label: "Link",
              onChange: (value) {
                joblink = value;
              },
            ),
            Divider(
              thickness: 1.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      RadioListTile(
                        activeColor: Colors.black,
                        title: Text("Full Time"),
                        value: "Full Time",
                        groupValue: _timeValue,
                        onChanged: (String? value) {
                          setState(() {
                            _timeValue = value!;
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: Colors.black,
                        title: Text("Part Time"),
                        value: "Part Time",
                        groupValue: _timeValue,
                        onChanged: (String? value) {
                          setState(() {
                            _timeValue = value!;
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: buildFormField(
                    label: "Annual Salary",
                    onChange: (value) {
                      aSalary = value;
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
              child: Text(
                "Qualifications",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            buildFormField(
              label: "Point 1",
              maxLines: 3,
              onChange: (value) {
                qual1 = value;
              },
              alignLabel: true,
            ),
            buildFormField(
              label: "Point 2",
              maxLines: 3,
              onChange: (value) {
                qual2 = value;
              },
              alignLabel: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
              child: Text(
                "About The Job",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            buildFormField(
              label: "Point 1",
              maxLines: 3,
              onChange: (value) {
                abtJob1 = value;
              },
              alignLabel: true,
            ),
            buildFormField(
              label: "Point 2",
              maxLines: 3,
              onChange: (value) {
                abtJob2 = value;
              },
              alignLabel: true,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  createJob();
                },
                child: Text("Create Job"),
                style: ElevatedButton.styleFrom(
                  primary: k_btnColor,
                  textStyle: TextStyle(fontSize: 25.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 60.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFormField({
    required String label,
    required void Function(String)? onChange,
    int? maxLines,
    TextInputType? keyboard,
    bool? alignLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        validator: label == "Link"
            ? null
            : (val) {
                return val!.isEmpty ? "Enter the $label" : null;
              },
        textAlignVertical: TextAlignVertical.top,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          alignLabelWithHint: alignLabel,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 5.0,
            ),
          ),
        ),
        onChanged: onChange,
      ),
    );
  }
}
