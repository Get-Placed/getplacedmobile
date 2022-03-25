import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/components/widgets/widgets.dart';
import 'package:placement_cell/services/auth.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  bool visible = false;
  AuthService _authService = AuthService();

  resetPass() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FirebaseFirestore.instance
          .collection("Users")
          .doc(email)
          .get()
          .then((doc) {
        if (doc.exists) {
          _authService.resetEmailPass(email);
          Get.snackbar(email, "An email has been sent");
          setState(() {
            visible = !visible;
          });
          _formKey.currentState!.reset();
        } else {
          print("There is no such user");
          Get.snackbar(email, "There is no such user");
          _formKey.currentState!.reset();
        }
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.08,
                ),
                buildHeaderText(
                  padding: EdgeInsets.all(0.0),
                  start: "Forget ",
                  end: "Password",
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  "Your Registered Email",
                  style: GoogleFonts.ubuntu(
                    fontSize: 24.0,
                  ),
                ),
                buildFormTile(
                  size: size,
                  val: (val) {
                    return val!.isEmpty ? "Enter the Email" : null;
                  },
                  onSave: (value) {
                    email = value!.trim();
                  },
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    resetPass();
                  },
                  icon: Icon(Icons.mail_outline),
                  label: Text(
                    "Send",
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    primary: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                visible
                    ? Text(
                        "We sent you have an email to reset your password",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 20.0,
                          color: Colors.green,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormTile({
    required Size size,
    required String? Function(String? value)? val,
    Function(String? value)? onSave,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Stack(
        children: <Widget>[
          TextFormField(
            validator: val,
            keyboardType: type,
            onSaved: onSave,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(40.0),
              ),
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
    );
  }
}
