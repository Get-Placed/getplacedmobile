import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisteredCompanies extends StatefulWidget {
  const RegisteredCompanies({Key? key}) : super(key: key);

  @override
  _RegisteredCompaniesState createState() => _RegisteredCompaniesState();
}

class _RegisteredCompaniesState extends State<RegisteredCompanies> {
  late Query compData;

  @override
  void initState() {
    super.initState();
    loadCompData();
  }

  loadCompData() {
    compData = FirebaseFirestore.instance.collection("Company");
    print(compData);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.power_settings_new_outlined,
              color: Colors.red,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 20.0,
            ),
            child: Text(
              "Registered",
              style: GoogleFonts.aBeeZee(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Text(
              "Companies",
              style: GoogleFonts.aBeeZee(
                fontSize: 35.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: compData.snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: ClipOval(
                                child: Image.network(
                                  snapshot.data.docs[index]
                                      .data()["compLogoUrl"],
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ),
                              title: Text(
                                snapshot.data.docs[index].data()["compName"],
                              ),
                              subtitle: Text(
                                snapshot.data.docs[index].data()["compAddr"],
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
