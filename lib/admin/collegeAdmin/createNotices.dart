import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placement_cell/components/widgets/widgets.dart';
import 'package:placement_cell/services/database.dart';
import 'package:placement_cell/services/values.dart';

class CreateNotices extends StatefulWidget {
  final String clgName;
  const CreateNotices({
    Key? key,
    required this.clgName,
  }) : super(key: key);

  @override
  _CreateNoticesState createState() => _CreateNoticesState();
}

class _CreateNoticesState extends State<CreateNotices> {
  String title = "", link = "", desc = "";

  final _formKey = GlobalKey<FormState>();
  DataService _dataService = DataService();
  createNotices() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> noticeData = {
        "title": title,
        "link": link,
        "desc": desc,
        "clgName": widget.clgName,
      };
      _dataService.createNotices(noticeData).then(
        (value) {
          Get.snackbar(title, "has been Created");
          _formKey.currentState!.reset();
        },
      );
    }
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.08,
              ),
              buildHeaderText(start: "Create ", end: "Notice"),
              SizedBox(
                height: size.height * 0.05,
              ),
              buildFormField(
                label: "Title",
                onChange: (value) {
                  title = value;
                },
              ),
              buildFormField(
                label: "Link",
                onChange: (value) {
                  link = value;
                },
              ),
              buildFormField(
                label: "Description",
                onChange: (value) {
                  desc = value;
                },
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    createNotices();
                  },
                  icon: Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                  label: Text(
                    "Create",
                    style: GoogleFonts.ubuntu(
                      fontSize: 24.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: k_btnColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
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
    );
  }

  Widget buildFormField({
    required String label,
    required void Function(String)? onChange,
    int? maxLines,
    TextInputType? keyboard,
    bool? alignLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        validator: (val) {
          return val!.isEmpty ? "Enter the $label" : null;
        },
        textAlignVertical: TextAlignVertical.top,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          alignLabelWithHint: alignLabel,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 5.0,
            ),
          ),
        ),
        onChanged: onChange,
      ),
    );
  }
}
