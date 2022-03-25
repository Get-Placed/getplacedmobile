import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  TextEditingController dateCtl = TextEditingController();

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
          email,
          password,
          username,
          userRole,
          userClg,
        )
            .then(
          (value) async {
            await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            print(value);
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(email)
                .update({
              "ssc": ssc,
              "hsc": hsc.isEmpty ? "N/A" : hsc,
              "yoc": yoc,
              "sscyoc": sscyoc,
              "hscyoc": hscyoc.isEmpty ? "N/A" : hscyoc,
              "dob": dob,
              "cgpa": cgpa,
              "dipcgpa": dipcgpa.isEmpty ? "N/A" : dipcgpa,
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
          physics: BouncingScrollPhysics(),
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
                    elevation: 5.0,
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
                              return val!.isEmpty ? "Enter Email" : null;
                            },
                            onSave: (value) {
                              email = value!.trim();
                            },
                          ),
                          sizedH1,
                          buildFormTile(
                            type: TextInputType.name,
                            size: size,
                            label: "Username",
                            icon: Icons.person_outline,
                            val: (val) {
                              return val!.isEmpty ? "Enter Username" : null;
                            },
                            onSave: (value) {
                              username = value!.trim();
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
                              return val!.isEmpty ? "Enter Password" : null;
                            },
                            onSave: (value) {
                              password = value!.trim();
                            },
                          ),
                          sizedH1,
                          buildFormTile(
                            obsText: true,
                            type: TextInputType.visiblePassword,
                            size: size,
                            label: "Confirm Password",
                            val: (val) {
                              return (val!.isEmpty || password != confirmpass)
                                  ? "Password does not match"
                                  : null;
                            },
                            icon: Icons.lock_outline,
                            onSave: (value) {
                              confirmpass = value!.trim();
                            },
                          ),
                          sizedH1,
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                color: k_btnColor,
                              ),
                              SizedBox(
                                width: size.width * 0.03,
                              ),
                              Text(
                                "Date Of Birth",
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
                          TextFormField(
                            readOnly: true,
                            controller: dateCtl,
                            onSaved: (value) {
                              dob = value!;
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? "Enter Date of Birth"
                                  : null;
                            },
                            keyboardType: TextInputType.none,
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2004, 1, 1),
                                firstDate: DateTime(1997),
                                lastDate: DateTime(2004, 12),
                                builder: (context, child) {
                                  return Theme(
                                    child: child!,
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light().copyWith(
                                        primary: Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              );
                              if (date != null) {
                                dateCtl.text =
                                    DateFormat("dd/MM/yyyy").format(date);
                              }
                            },
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
                                  onSave: (value) {
                                    ssc = value!.trim();
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter SSC Marks"
                                        : null;
                                  },
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "SSC YOC",
                                  icon: Icons.grading_outlined,
                                  onSave: (value) {
                                    sscyoc = value!.trim();
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter SSC YOC"
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
                                  label: "HSC Marks",
                                  icon: Icons.grading_outlined,
                                  onSave: (value) {
                                    hsc = value!.trim();
                                  },
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: buildFormTile(
                                  align: TextAlign.center,
                                  size: size,
                                  label: "HSC YOC",
                                  icon: Icons.grading_outlined,
                                  onSave: (value) {
                                    hscyoc = value!.trim();
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
                                  ? 'Please select College'
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
                                  label: "SEM 1",
                                  icon: Icons.grading_outlined,
                                  onSave: (value) {
                                    sem1 = value!.trim();
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
                                  label: "SEM 2",
                                  icon: Icons.grading_outlined,
                                  onSave: (value) {
                                    sem2 = value!.trim();
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
                                  onSave: (value) {
                                    sem3 = value!.trim();
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter SEM 3 Marks"
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
                                  onSave: (value) {
                                    sem4 = value!.trim();
                                  },
                                  val: (val) {
                                    return val!.isEmpty
                                        ? "Enter SEM 4 Marks"
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
                                  onSave: (value) {
                                    sem5 = value!.trim();
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
                                  onSave: (value) {
                                    sem6 = value!.trim();
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
                                  onSave: (value) {
                                    sem7 = value!.trim();
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
                                  onSave: (value) {
                                    sem8 = value!.trim();
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
                                  onSave: (value) {
                                    yoc = value!.trim();
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
                                  onSave: (value) {
                                    cgpa = value!.trim();
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
                            onSave: (value) {
                              dipcgpa = value!.trim();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
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
                  height: size.height * 0.05,
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
    required void Function(String? value)? onSave,
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
            ),
            SizedBox(
              width: size.width * 0.03,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 18.0,
                color: k_btnColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        TextFormField(
          readOnly: readOnly,
          textAlign: align,
          validator: val,
          obscureText: obsText,
          keyboardType: type,
          onSaved: onSave,
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
    );
  }
}
