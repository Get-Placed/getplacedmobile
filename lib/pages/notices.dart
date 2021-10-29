import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/services/values.dart';
import 'package:url_launcher/url_launcher.dart';

class Notices extends StatefulWidget {
  final String clgName;
  const Notices({
    Key? key,
    required this.clgName,
  }) : super(key: key);

  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  late Query notices;

  @override
  void initState() {
    super.initState();
    loadNotices();
  }

  loadNotices() {
    notices = FirebaseFirestore.instance.collection("Notices").where(
          "clgName",
          isEqualTo: widget.clgName,
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: k_btnColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: size.height * 0.04,
          ),
          Text(
            "Notices",
            style: GoogleFonts.aBeeZee(
              fontSize: 35.0,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
              child: Container(
            child: StreamBuilder(
              stream: notices.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Container(
                  child: !snapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildNoticeCard(
                              title: snapshot.data.docs[index].data()["title"],
                              desc: snapshot.data.docs[index].data()["desc"],
                              link: snapshot.data.docs[index].data()["link"],
                            );
                          },
                        ),
                );
              },
            ),
          ))
        ],
      ),
    );
  }

  buildNoticeCard({
    required String title,
    required String desc,
    required String link,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
      child: InkWell(
        onTap: () async {
          final _url = link;
          print(_url);
          await canLaunch(_url)
              ? await launch(_url)
              : throw 'Could not launch $_url';
        },
        child: Card(
          elevation: 5.0,
          child: ListTile(
            title: Text(title),
            subtitle: Text(desc),
          ),
        ),
      ),
    );
  }
}
