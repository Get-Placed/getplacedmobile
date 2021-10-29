import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/services/database.dart';
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

  createClg() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      clgId = randomAlphaNumeric(12);
      Map<String, dynamic> clgData = {
        "clgName": clgName,
        "clgAddr": clgAddr,
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
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          splashColor: Colors.blue[800],
          backgroundColor: Colors.blue,
          onPressed: () {
            createClg();
          },
          icon: Icon(
            Icons.add,
            color: Colors.black,
            size: 28.0,
          ),
          label: Text(
            "Add",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
