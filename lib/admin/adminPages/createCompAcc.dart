import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:placement_cell/components/widgets/widgets.dart';
import 'package:placement_cell/services/auth.dart';

class CompAccount extends StatefulWidget {
  const CompAccount({Key? key}) : super(key: key);

  @override
  _CompAccountState createState() => _CompAccountState();
}

class _CompAccountState extends State<CompAccount> {
  late Query compData;
  var compDropdownVal;
  final _formKey = GlobalKey<FormState>();

  AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadCompData();
  }

  @override
  void dispose() {
    super.dispose();
    loadCompData();
  }

  loadCompData() {
    compData = FirebaseFirestore.instance.collection("Company");
  }

  String owner = "", email = "", pass = "", conpass = "";
  int compRole = 4;
  Map<String, String> compLogoMap = {};

  createCompAcc() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await _authService
            .signUpEmailPass(
                email.trim(), pass, owner, compRole, compDropdownVal)
            .then(
          (value) async {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(email)
                .update({
              "compLogoUrl": compLogoMap[compDropdownVal],
            });
            Get.snackbar(email, "Account has been created !!");
            _formKey.currentState!.reset();
          },
        );
      }
    } on Exception catch (e) {
      Get.snackbar(email, "$e.message");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: compDropdownVal == null
                        ? Image.asset(
                            "assets/logos/logo.png",
                            height: 150.0,
                            width: 150.0,
                          )
                        : Image.network(
                            "${compLogoMap[compDropdownVal]}",
                            height: 150.0,
                            width: 150.0,
                          ),
                  ),
                ),
                buildHeaderText(
                  start: "Create ",
                  end: "Company",
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: StreamBuilder(
                      stream: compData.snapshots(),
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
                                  value: compDropdownVal,
                                  isExpanded: true,
                                  onChanged: (value) {
                                    setState(() {
                                      compDropdownVal = value;
                                    });
                                  },
                                  hint: Text('Choose Company'),
                                  items: snapshot.data.docs
                                      .map<DropdownMenuItem<String>>((doc) {
                                    compLogoMap.addAll({
                                      doc.data()["compName"]:
                                          doc.data()["compLogoUrl"],
                                    });
                                    return DropdownMenuItem<String>(
                                      value: doc.data()["compName"],
                                      child: Text("${doc.data()["compName"]}"),
                                    );
                                  }).toList(),
                                ),
                              );
                      },
                    ),
                  ),
                ),
                accFormField(
                    label: "Name of the Owner",
                    val: (val) {
                      return val!.isEmpty
                          ? "Enter the Name of the Owner"
                          : null;
                    },
                    onChange: (value) {
                      owner = value;
                    }),
                accFormField(
                    label: "Email",
                    val: (val) {
                      return val!.isEmpty ? "Enter the Email" : null;
                    },
                    onChange: (value) {
                      email = value;
                    }),
                accFormField(
                    label: "Password",
                    password: true,
                    val: (val) {
                      return val!.isEmpty ? "Enter the Password" : null;
                    },
                    onChange: (value) {
                      pass = value;
                    }),
                accFormField(
                    label: "Confirm Password",
                    password: true,
                    val: (val) {
                      return val!.isEmpty || val != conpass
                          ? "Password does not match"
                          : null;
                    },
                    onChange: (value) {
                      conpass = value;
                    }),
                SizedBox(
                  height: height * 0.07,
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
            createCompAcc();
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
