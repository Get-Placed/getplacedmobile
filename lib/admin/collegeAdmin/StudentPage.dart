import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/services/values.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentPage extends StatefulWidget {
  final String userEmail;

  const StudentPage({
    Key? key,
    required this.userEmail,
  });

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  String logo = "loading....",
      name = "loading....",
      clgName = "loading....",
      ssc = "loading....",
      hsc = "loading....",
      sem1 = "loading....",
      sem2 = "loading....",
      sem3 = "loading....",
      sem4 = "loading....",
      sem5 = "loading....",
      sem6 = "loading....",
      sem7 = "loading....",
      photo = "",
      resume = "",
      sem8 = "loading....";

  loadUserData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userEmail)
        .get()
        .then((value) {
      var fields = value.data();

      setState(() {
        name = fields?["userName"];
        clgName = fields?["userFrom"];
        ssc = fields?["ssc"];
        hsc = fields?["hsc"];
        sem1 = fields?["sem1"];
        sem2 = fields?["sem2"];
        sem3 = fields?["sem3"];
        sem4 = fields?["sem4"];
        sem5 = fields?["sem5"];
        sem6 = fields?["sem6"];
        sem7 = fields?["sem7"];
        sem8 = fields?["sem8"];
        photo = fields?["photo"] ?? "";
        resume = fields?["resume"] ?? "";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: k_themeColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 85.0,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80.0,
                    backgroundImage: NetworkImage(photo == ""
                        ? "https://ui-avatars.com/api/?name=$name"
                        : photo),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Text(
                "$name",
                style: GoogleFonts.ubuntu(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${widget.userEmail}",
                style: GoogleFonts.aBeeZee(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                "$clgName",
                style: GoogleFonts.aBeeZee(
                  fontSize: 24.0,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: buildScoreTile(
                      size,
                      score: "$ssc",
                      name: "SSC SCORE",
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Expanded(
                    child: buildScoreTile(
                      size,
                      score: "$hsc",
                      name: "HSC SCORE",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              buildSemScoreTile(
                size,
                semNoL: "I",
                scoreL: "$sem1",
                semNoR: "II",
                scoreR: "$sem2",
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              buildSemScoreTile(
                size,
                semNoL: "III",
                scoreL: "$sem3",
                semNoR: "IV",
                scoreR: "$sem4",
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              buildSemScoreTile(
                size,
                semNoL: "V",
                scoreL: "$sem5",
                semNoR: "VI",
                scoreR: "$sem6",
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              buildSemScoreTile(
                size,
                semNoL: "VII",
                scoreL: "$sem7",
                semNoR: "VIII",
                scoreR: "$sem8",
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: RaisedButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    onPressed: () {
                      if (resume == "") {
                        Get.snackbar(
                          "Error",
                          "Resume not available",
                          snackPosition: SnackPosition.TOP,
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                      } else {
                        Get.snackbar("Resume", "Opening Resume");
                        launch(resume);
                      }
                    },
                    child: Text(
                      "Open Resume",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSemScoreTile(
    Size size, {
    required String semNoL,
    required String scoreL,
    required String semNoR,
    required String scoreR,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Semester $semNoL",
              style: GoogleFonts.aBeeZee(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              "$scoreL",
              style: GoogleFonts.aBeeZee(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              "Semester $semNoR",
              style: GoogleFonts.aBeeZee(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              "$scoreR",
              style: GoogleFonts.aBeeZee(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildScoreTile(
    Size size, {
    required String score,
    required String name,
  }) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            Text(
              score,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              name,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
