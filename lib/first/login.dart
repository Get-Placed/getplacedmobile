import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/admin/collegeAdmin/AllStudentsApplied.dart';
import 'package:placement_cell/admin/collegeAdmin/CollegeNavTab.dart';
import 'package:placement_cell/admin/compAdmin/compHome.dart';
import 'package:placement_cell/admin/compAdmin/compNavTab.dart';
import 'package:placement_cell/admin/dashboard.dart';
import 'package:placement_cell/components/StudentController.dart';
import 'package:placement_cell/pages/EmailVerified.dart';
import 'package:placement_cell/pages/home.dart';
import 'package:placement_cell/pages/resetpassword.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService _authService = AuthService();
  signIn() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await _authService.signInEmailPass(email, password).then(
          (value) async {
            if (value == email) {
              setState(() {
                email = "";
                password = "";
              });

              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(_auth.currentUser!.email)
                  .get()
                  .then((doc) {
                var userdata = doc.data();
                print(userdata);
                StudentController _controller = Get.find();
                _controller.setStudent(userdata!);
                bool isEmailVerified = _auth.currentUser!.emailVerified;

                if (!isEmailVerified) {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  Get.to(EmailVerified());
                } else if (userdata['role'] == 0) {
                  print(userdata["role"]);

                  Get.to(() => Home(
                        clgName: userdata['userFrom'],
                        userName: userdata['userName'],
                        userEmail: userdata['email'],
                        dob: userdata['dob'],
                        cgpa: userdata['cgpa'],
                        yoc: userdata['yoc'],
                        branch: userdata['dept'],
                        resume: userdata['resume'] ?? "NA",
                        photo: userdata['photo'] ?? "NA",
                      ));
                  _formKey.currentState!.reset();
                } else if (userdata['role'] == 4) {
                  print(userdata['userName']);
                  Get.to(() => CompNavTab(
                        owner: userdata['userName'],
                        logoUrl: userdata['compLogoUrl'],
                        compName: userdata["userFrom"],
                      ));
                  _formKey.currentState!.reset();
                } else if (userdata['role'] == 3) {
                  print(userdata['role']);
                  Get.to(() => Dashboard());
                  _formKey.currentState!.reset();
                } else if (userdata['role'] == 2) {
                  print(userdata['role']);
                  Get.to(
                    () => CollegeNavTab(
                      clgName: userdata['userFrom'],
                    ),
                  );
                  _formKey.currentState!.reset();
                }
              });
            }
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: k_themeColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 35.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          buildFormTile(
                            type: TextInputType.emailAddress,
                            size: size,
                            label: "Email",
                            icon: Icons.email_outlined,
                            onChange: (value) {
                              email = value;
                            },
                            val: (val) {
                              return val!.isEmpty ? "Enter the email" : null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          buildFormTile(
                            obsText: true,
                            type: TextInputType.visiblePassword,
                            size: size,
                            label: "Password",
                            icon: Icons.lock_outline,
                            onChange: (value) {
                              password = value;
                            },
                            val: (val) {
                              return val!.isEmpty ? "Enter the Password" : null;
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          InkWell(
                            splashColor: k_themeColor,
                            onTap: () {
                              Get.to(() => ResetPass());
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: k_btnColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.09,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Text(
                    "Login",
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: k_btnColor,
                    textStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormTile({
    required Size size,
    required String label,
    required IconData icon,
    required String? Function(String? value)? val,
    Function(String value)? onChange,
    TextInputType? type,
    bool obsText = false,
  }) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              icon,
              color: k_btnColor,
              size: 25.0,
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 20.0,
                color: k_btnColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Stack(
          children: <Widget>[
            TextFormField(
              obscureText: obsText,
              validator: val,
              keyboardType: type,
              onChanged: onChange,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                    40.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
