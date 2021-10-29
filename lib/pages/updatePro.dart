import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/services/UpdateProfileController.dart';
import 'package:placement_cell/services/values.dart';

class UpdateProfile extends StatefulWidget {
  final String userName, userEmail, dob, cgpa, yoc;

  const UpdateProfile({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.dob,
    required this.cgpa,
    required this.yoc,
  });

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  UpdateProfileController _controller = Get.put(UpdateProfileController());

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
        appBar: AppBar(
          title: Text(
            "Profile",
            style: GoogleFonts.aBeeZee(
              color: Colors.black,
            ),
          ),
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
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                color: Colors.grey.shade700,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: FittedBox(
                    child: Text(
                      "Student",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: GetBuilder<UpdateProfileController>(
          init: _controller,
          builder: (_controller) {
            return Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: CircleAvatar(
                          radius: 85.0,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80.0,
                            backgroundImage: NetworkImage(
                                "https://ui-avatars.com/api/?name=${widget.userName}"),
                          ),
                        ),
                      ),
                      buildFormTile(
                        initial: widget.userName,
                        status: _controller.statusName,
                        size: size,
                        label: "Name",
                        icon: Icons.person_rounded,
                        val: (val) {
                          return val!.isEmpty ? "Enter the Name" : null;
                        },
                      ),
                      sizedH1,
                      buildFormTile(
                        initial: widget.userEmail,
                        status: _controller.statusEmail,
                        size: size,
                        label: "Email",
                        icon: Icons.email_outlined,
                        val: (val) {
                          return val!.isEmpty ? "Enter the Email" : null;
                        },
                      ),
                      sizedH1,
                      buildFormTile(
                        initial: widget.dob,
                        status: _controller.statusDOB,
                        size: size,
                        label: "Date Of Birth",
                        icon: Icons.calendar_today,
                        val: (val) {
                          return val!.isEmpty
                              ? "Enter the Date Of Birth"
                              : null;
                        },
                      ),
                      sizedH1,
                      buildFormTile(
                        initial: widget.cgpa == "" ? "N/A" : widget.cgpa,
                        status: _controller.statusCGPA,
                        size: size,
                        label: "Average CGPA",
                        icon: Icons.check_box_outlined,
                        val: (val) {
                          return val!.isEmpty ? "Enter the Average CGPA" : null;
                        },
                      ),
                      sizedH1,
                      buildFormTile(
                        initial: widget.yoc,
                        status: _controller.statusYOC,
                        size: size,
                        label: "Year Of Completion",
                        icon: Icons.calendar_today,
                        val: (val) {
                          return val!.isEmpty
                              ? "Enter the Year Of Completion"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
    String? initial,
    TextInputType? type,
    bool obsText = false,
    required bool status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
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
            alignment: Alignment.centerRight,
            children: <Widget>[
              TextFormField(
                textAlign: TextAlign.center,
                initialValue: initial,
                style: TextStyle(
                  color: Colors.black,
                ),
                enabled: status,
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
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
