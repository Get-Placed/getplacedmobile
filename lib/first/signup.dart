import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/first/firsttab.dart';
import 'package:placement_cell/services/auth.dart';
import 'package:placement_cell/services/values.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    loadClgData();
  }

  late Query clgData;

  loadClgData() {
    clgData = FirebaseFirestore.instance.collection("Colleges");
  }

  String email = "",
      username = "",
      password = "",
      confirmpass = "",
      ssc = "",
      hsc = "",
      sem1 = "",
      sem2 = "",
      sem3 = "",
      sem4 = "",
      sem5 = "",
      sem6 = "",
      sem7 = "",
      sem8 = "",
      yoc = "",
      sscyoc = "",
      hscyoc = "",
      cgpa = "",
      dipcgpa = "",
      dob = "";
  var userClg, dept;
  int userRole = 0;

  AuthService _authService = AuthService();

  signUP() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (int.tryParse(ssc)! > 100 ||
            int.tryParse(hsc)! > 100 ||
            int.tryParse(cgpa)! > 10) {
          Get.snackbar("Error", "Invalid CGPA / SSC / HSC MARKS",
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              duration: Duration(seconds: 2));
        }
        await _authService
            .signUpEmailPass(
          email.trim(),
          password,
          username.trim(),
          userRole,
          userClg,
        )
            .then(
          (value) async {
            await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            print(value);
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(email.trim())
                .update({
              "ssc": ssc,
              "hsc": hsc,
              "yoc": yoc,
              "sscyoc": sscyoc,
              "hscyoc": hscyoc,
              "dob": dob,
              "cgpa": cgpa,
              "dipcgpa": dipcgpa,
              "sem1": sem1.isEmpty ? "N/A" : sem1,
              "sem2": sem2.isEmpty ? "N/A" : sem2,
              "sem3": sem3,
              "sem4": sem4,
              "sem5": sem5.isEmpty ? "N/A" : sem5,
              "sem6": sem6.isEmpty ? "N/A" : sem6,
              "sem7": sem7.isEmpty ? "N/A" : sem7,
              "sem8": sem8.isEmpty ? "N/A" : sem8,
              "dept": dept,
            });

            Get.off(
              () => MainTab(),
            );
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
    final sizedH1 = SizedBox(
      height: size.height * 0.03,
    );
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
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          buildFormTile(
                            type: TextInputType.emailAddress,
                            size: size,
                            label: "Email",
                            icon: Icons.email_outlined,
                            val: (val) {
                              return val!.isEmpty ? "Enter the Email" : null;
                            },
                            onChange: (value) {
                              email = value;
                            },
                          ),
                          sizedH1,
                          buildFormTile(
                            type: TextInputType.name,
                            size: size,
                            label: "Username",
                            icon: Icons.person_outline,
                            val: (val) {
                              return val!.isEmpty ? "Enter the Username" : null;
                            },
                            onChange: (value) {
                              username = value;
                            },
                          ),
                          sizedH1,
                          buildFormTile(
                            type: TextInputType.visiblePassword,
                            obsText: true,
                            size: size,
                            label: "Password",
                            icon: Icons.lock_outline,
                            val: (val) {
                              return val!.isEmpty ? "Enter the Password" : null;
                            },
                            onChange: (value) {
                              password = value;
                            },
                          ),
                          sizedH1,
                          buildFormTile(
                            obsText: true,
                            type: TextInputType.visiblePassword,
                            size: size,
                            label: "Confirm Password",
                            val: (val) {
                              return val!.isEmpty || password != confirmpass
                                  ? "Password does not match"
                                  : null;
                            },
                            icon: Icons.lock_outline,
                            onChange: (value) {
                              confirmpass = value;
                            },
                          ),
                          sizedH1,
                          buildFormTile(
                            size: size,
                            label: "Date Of Birth",
                            val: (val) {
                              return val!.isEmpty
                                  ? "Enter Date Of Birth"
                                  : null;
                            },
                            icon: Icons.calendar_today,
                            onChange: (value) {
                              dob = value;
                            },
                          ),
                          sizedH1,
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              "Education Details",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          sizedH1,
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SSC Marks *",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    ssc = value;
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter the SSC Marks"
                                        : null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SSC YOC",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sscyoc = value;
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter the SSC YOC"
                                        : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "HSC Marks *",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    hsc = value;
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter the HSC Marks"
                                        : null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "HSC YOC",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    hscyoc = value;
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter the HSC Marks"
                                        : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          sizedH1,
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              "Graduation Details",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            "(Marks of All Semesters)",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          sizedH1,
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 5.0),
                            child: Center(
                              child: StreamBuilder(
                                stream: clgData.snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
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
                                            value: userClg,
                                            isExpanded: true,
                                            onChanged: (value) {
                                              setState(() {
                                                userClg = value;
                                              });
                                            },
                                            hint: Text('Choose Your College'),
                                            items: snapshot.data.docs
                                                .map<DropdownMenuItem<String>>(
                                                    (doc) {
                                              return DropdownMenuItem<String>(
                                                value: doc.data()["clgName"],
                                                child: Text(
                                                    "${doc.data()["clgName"]}"),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                          sizedH1,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              validator: (value) => value == null
                                  ? 'Please select the College'
                                  : null,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              value: dept,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  dept = value;
                                });
                              },
                              hint: Text('Choose Your Department'),
                              items: [
                                "Computer Science",
                                "Information Technology",
                                "Electronics and Communication",
                                "Electrical Engineering",
                                "Mechanical Engineering",
                                "Civil Engineering",
                                "Chemical Engineering",
                                "Biotechnology",
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          sizedH1,
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 1 *",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem1 = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 2 *",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem2 = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          sizedH1,
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 3 *",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem3 = value;
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter the SEM 3 Marks"
                                        : null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 4 *",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem4 = value;
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter the SEM 4 Marks"
                                        : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          sizedH1,
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 5",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem5 = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 6",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem6 = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          sizedH1,
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 7",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem7 = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SEM 8",
                                  icon: Icons.grading_outlined,
                                  onChange: (value) {
                                    sem8 = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          sizedH1,
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "YOC",
                                  icon: Icons.calendar_today,
                                  onChange: (value) {
                                    yoc = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "CGPA",
                                  icon: Icons.star_border,
                                  onChange: (value) {
                                    cgpa = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          sizedH1,
                          buildFormTile(
                            align: TextAlign.center,
                            size: size,
                            label: "Diploma CGPA",
                            icon: Icons.star_border,
                            onChange: (value) {
                              dipcgpa = value;
                            },
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
                    signUP();
                  },
                  child: Text(
                    "Signup",
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
    required Function(String value) onChange,
    String? Function(String? value)? val,
    TextInputType? type,
    TextAlign align = TextAlign.start,
    bool obsText = false,
    bool readOnly = false,
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
              readOnly: readOnly,
              textAlign: align,
              validator: val,
              obscureText: obsText,
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
