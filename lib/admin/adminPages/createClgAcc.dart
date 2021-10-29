import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:placement_cell/services/auth.dart';

class ClgAccount extends StatefulWidget {
  const ClgAccount({Key? key}) : super(key: key);

  @override
  _ClgAccountState createState() => _ClgAccountState();
}

class _ClgAccountState extends State<ClgAccount> {
  String personName = "", emailAddr = "", pass = "", conPass = "";
  int clgRole = 2;
  final _formKey = GlobalKey<FormState>();
  var clgDropdownVal;

  late Query clgData;

  @override
  void initState() {
    super.initState();
    loadClgData();
  }

  loadClgData() {
    clgData = FirebaseFirestore.instance.collection("Colleges");
  }

  AuthService _authService = AuthService();

  createClgAcc() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _authService
          .signUpEmailPass(
              emailAddr.trim(), pass, personName, clgRole, clgDropdownVal)
          .then((value) {
        _formKey.currentState!.reset();
        Get.snackbar(emailAddr, "Account has been created !!");
        Navigator.maybePop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
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
                          text: "Create ",
                        ),
                        TextSpan(
                          text: "College",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                                padding:
                                    EdgeInsets.only(top: 16.0, bottom: 16.0),
                                child: DropdownButtonFormField(
                                  validator: (value) => value == null
                                      ? 'Please select the College'
                                      : null,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  value: clgDropdownVal,
                                  isExpanded: true,
                                  onChanged: (value) {
                                    setState(() {
                                      clgDropdownVal = value;
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
                accFormField(
                  label: "Person Name",
                  onChange: (val) {
                    personName = val;
                  },
                  val: (val) {
                    return val!.isEmpty ? "Enter the Person Name" : null;
                  },
                ),
                accFormField(
                  label: "Email Address",
                  onChange: (val) {
                    emailAddr = val;
                  },
                  val: (val) {
                    return val!.isEmpty ? "Enter the Email Address" : null;
                  },
                ),
                accFormField(
                  label: "Password",
                  onChange: (val) {
                    pass = val;
                  },
                  val: (val) {
                    return val!.isEmpty ? "Enter the Password" : null;
                  },
                  password: true,
                ),
                accFormField(
                  label: "Confirm Password",
                  onChange: (val) {
                    conPass = val;
                  },
                  val: (val) {
                    return val != pass ? "Password does not match" : null;
                  },
                  password: true,
                ),
                SizedBox(
                  height: size.height * 0.2,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          splashColor: Colors.blue[800],
          backgroundColor: Colors.blue,
          onPressed: () {
            createClgAcc();
          },
          icon: Icon(
            Icons.add,
            color: Colors.black,
            size: 28.0,
          ),
          label: Text(
            "Create",
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

  Widget accFormField({
    required String label,
    bool password = false,
    int maxLines = 1,
    required void Function(String)? onChange,
    String? Function(String?)? val,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
      child: TextFormField(
        validator: val,
        obscureText: password,
        maxLines: maxLines,
        decoration: InputDecoration(
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
