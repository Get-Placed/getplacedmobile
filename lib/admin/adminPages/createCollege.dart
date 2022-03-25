import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/services/database.dart';
import 'package:placement_cell/services/values.dart';
import 'package:random_string/random_string.dart';

class CreateCollege extends StatefulWidget {
  const CreateCollege({Key? key}) : super(key: key);

  @override
  _CreateCollegeState createState() => _CreateCollegeState();
}

class _CreateCollegeState extends State<CreateCollege> {
  final _formKey = GlobalKey<FormState>();

  DataService _dataService = DataService();

  String clgId = "", clgName = "", clgAddr = "";
  String salaryRange1 = "", salaryRange2 = "", salaryRange3 = "";
  createClg() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      clgId = randomAlphaNumeric(12);
      Map<String, dynamic> clgData = {
        "clgName": clgName,
        "clgAddr": clgAddr,
        "salaryRange1": salaryRange1 == "" ? 0 : int.parse(salaryRange1),
        "salaryRange2": salaryRange2 == "" ? 0 : int.parse(salaryRange2),
        "salaryRange3": salaryRange3 == "" ? 0 : int.parse(salaryRange3),
      };
      _dataService.addColleges(clgData, clgId).then((value) {
        Get.snackbar(clgName, "Added to Database");
        _formKey.currentState!.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: k_themeColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Add ",
                      ),
                      TextSpan(
                        text: "Colleges",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  validator: (val) {
                    return val!.isEmpty ? "Enter the College Name" : null;
                  },
                  decoration: InputDecoration(
                    labelText: "College Name",
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
                  onChanged: (val) {
                    clgName = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  validator: (val) {
                    return val!.isEmpty
                        ? "Enter the College Description"
                        : null;
                  },
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "College Address",
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
                  onChanged: (val) {
                    clgAddr = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Salary Range Minimum",
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
                  onChanged: (val) {
                    salaryRange1 = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Salary Range Medium",
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
                  onChanged: (val) {
                    salaryRange2 = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Salary Range Maximum",
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
                  onChanged: (val) {
                    salaryRange3 = val;
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    createClg();
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
