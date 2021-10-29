import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:placement_cell/components/widgets/widgets.dart';
import 'package:placement_cell/services/database.dart';
import 'package:random_string/random_string.dart';

class CreateCompanies extends StatefulWidget {
  const CreateCompanies({Key? key}) : super(key: key);

  @override
  _CreateCompaniesState createState() => _CreateCompaniesState();
}

class _CreateCompaniesState extends State<CreateCompanies> {
  final _formKey = GlobalKey<FormState>();

  String compName = "", compAddr = "", compID = "", compLogoUrl = "";
  DataService _dataService = DataService();
  createComp() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      compID = randomAlphaNumeric(12);
      Map<String, dynamic> compData = {
        "compName": compName,
        "compAddr": compAddr,
        "compLogoUrl": compLogoUrl,
      };

      _dataService.addCompanies(compData, compID).then((value) {
        Get.snackbar(
          compName,
          "Added to your Database !!",
        );
        _formKey.currentState!.reset();
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
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80.0),
                    child: compLogoUrl == ""
                        ? Image.asset(
                            "assets/logos/logo.png",
                            height: 150.0,
                            width: 150.0,
                          )
                        : Image.network(
                            compLogoUrl,
                            height: 150.0,
                            width: 150.0,
                          ),
                  ),
                ),
                buildHeaderText(start: "Add ", end: "Company"),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    validator: (val) {
                      return val!.isEmpty ? "Enter the Logo URL" : null;
                    },
                    decoration: InputDecoration(
                      labelText: "Company Logo URL",
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
                    onChanged: (val) {
                      setState(() {
                        compLogoUrl = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    validator: (val) {
                      return val!.isEmpty ? "Enter the Company Name" : null;
                    },
                    decoration: InputDecoration(
                      labelText: "Company Name",
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
                    onChanged: (val) {
                      compName = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    validator: (val) {
                      return val!.isEmpty ? "Enter the Company Address" : null;
                    },
                    maxLines: 4,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Company Address",
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
                    onChanged: (val) {
                      compAddr = val;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          splashColor: Colors.blue[800],
          backgroundColor: Colors.blue,
          onPressed: () {
            createComp();
          },
          icon: Icon(
            Icons.add,
            color: Colors.black,
            size: 28.0,
          ),
          label: Text(
            "Add",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
