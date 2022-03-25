import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:placement_cell/services/UpdateProfileController.dart';
import 'package:placement_cell/services/values.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final String user = "";

  UpdateProfileController _controller = Get.put(UpdateProfileController());

  String? newName, oldPass, newPass, conPass;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
        ),
        body: GetBuilder<UpdateProfileController>(
          init: _controller,
          builder: (_controller) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.person_outline_rounded,
                      size: 200.0,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        Text(
                          "Change Username",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    buildFormField(
                      size: size,
                      hint: "New Username",
                      status: _controller.statusUserName,
                      obsText: false,
                      val: (val) {
                        return val!.isEmpty ? "Enter the Username" : null;
                      },
                      type: TextInputType.name,
                      onChange: (value) {
                        newName = value;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    buildFormField(
                      size: size,
                      hint: "Old Password",
                      status: _controller.oldPassword,
                      obsText: true,
                      val: (val) {
                        return val!.isEmpty ? "Enter the Old Password" : null;
                      },
                      type: TextInputType.visiblePassword,
                      onChange: (value) {
                        oldPass = value;
                      },
                    ),
                    buildFormField(
                      size: size,
                      hint: "New Password",
                      status: _controller.newPassword,
                      obsText: true,
                      val: (val) {
                        return val!.isEmpty ? "Enter the New Password" : null;
                      },
                      type: TextInputType.visiblePassword,
                      onChange: (value) {
                        newPass = value;
                      },
                    ),
                    buildFormField(
                      size: size,
                      hint: "Confirm Password",
                      status: _controller.conPassword,
                      obsText: true,
                      val: (val) {
                        return val!.isEmpty || newPass != conPass
                            ? "Password does not match"
                            : null;
                      },
                      type: TextInputType.visiblePassword,
                      onChange: (value) {
                        conPass = value;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    _controller.statusUserName == false
                        ? buildButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 47.0,
                              vertical: 15.0,
                            ),
                            label: "Edit",
                            ontap: () {
                              _controller.updatePass();
                            },
                          )
                        : buildButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 42.0,
                              vertical: 15.0,
                            ),
                            label: "Save",
                            ontap: () {
                              _controller.updatePass();
                            },
                          ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget buildButton({
    required String label,
    required void Function()? ontap,
    required EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton(
      onPressed: ontap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        primary: k_btnColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget buildFormField({
    required Size size,
    required String hint,
    required bool status,
    required bool obsText,
    required String? Function(String?)? val,
    required TextInputType? type,
    required void Function(String)? onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Container(
            height: size.height * 0.06,
            child: TextFormField(
              style: TextStyle(
                color: Colors.black,
              ),
              enabled: status,
              obscureText: obsText,
              validator: val,
              keyboardType: type,
              onChanged: onChange,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
