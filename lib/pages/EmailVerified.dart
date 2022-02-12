import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class EmailVerified extends StatefulWidget {
  const EmailVerified({Key? key}) : super(key: key);

  @override
  _EmailVerifiedState createState() => _EmailVerifiedState();
}

class _EmailVerifiedState extends State<EmailVerified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Dialog(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 1.5,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff4338CA), Color(0xff6D28D9)]),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(12, 26),
                      blurRadius: 50,
                      spreadRadius: 0,
                      color: Colors.grey.withOpacity(.1)),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(.05),
                  radius: 25,
                  child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/FlutterBricksLogo-Med.png?alt=media&token=7d03fedc-75b8-44d5-a4be-c1878de7ed52"),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Your Email is not Verified",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 3.5,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                        "Please verify your email to continue!(Check your spam folder / inbox)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shadowColor: Colors.grey.withOpacity(.5),
                          elevation: 0),
                      onPressed: () {
                        _auth.currentUser!.sendEmailVerification();
                      },
                      child: Text("Resend Verification Email")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shadowColor: Colors.grey.withOpacity(.5),
                          elevation: 0),
                      onPressed: () {
                        _auth.signOut();
                        Navigator.pop(context);
                      },
                      child: Text("Logout")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
