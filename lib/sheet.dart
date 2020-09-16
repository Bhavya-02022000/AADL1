import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
// import 'package:sakecblue/AdminApp/auth.dart';
// import 'package:sakecblue/AdminApp/provider.dart';
// import 'package:sakecblue/Dashboard/dashboard.dart';
// import 'package:sakecblue/Login/Login2/screens/login/login.dart';
// import 'package:sakecblue/Login/auth.dart';
// import 'package:sakecblue/Login/provider.dart';

// import '../Login/auth.dart';
// import '../Login/provider.dart';
// import '../page_transition.dart';
import 'package:adminApp/auth.dart';
import 'package:adminApp/provider.dart';
import 'package:page_transition/page_transition.dart';

import 'main.dart';
import 'datastore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admindash.dart';
import 'adminlogin.dart';

// ignore: camel_case_types

class Upload_data extends StatefulWidget {
  @override
  _Upload_dataState createState() => _Upload_dataState();
}

var counter = 0;

class _Upload_dataState extends State<Upload_data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600),
                child: AdminFirst()),
          ),
        ),
        backgroundColor: Colors.black,
        title: Text('Register Users'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                if (counter == 1) {
                  wait(context);
                } else {
                  Auth auth = Provider.of(context).auth;
                  await auth.signOut();
                }
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          // setState(() {
          //   counter = 1;
          // });
          if (counter == 1) {
            wait(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Admin_dash()),
            );
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
      body: Sheet_Layout(),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      counter = 0;
    });
  }
}

// ignore: camel_case_types
class Sheet_Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Upload Data Here",
                style: TextStyle(
                    fontFamily: 'Courgette',
                    fontSize: MediaQuery.of(context).size.width / 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          File_name(),
          // Add_files(),
          AddExcelFile(),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Instructions_layout(),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class File_name extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Uploaded_file(),
      ],
    );
  }
}

// ignore: camel_case_types
class Uploaded_file extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: 25,
        ),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.limeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: <Widget>[
              Text(
                "To add Employees/Students of your Organization please upload .xlsx file",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Fondamento',
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ])
            /*Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.limeAccent,
            child: Center(
              child: Text(
                  "To add Employees/Students of your Organization please upload .xlsx file"),
            ))*/
            ));
  }
}

class AddExcelFile extends StatefulWidget {
  @override
  _AddExcelFileState createState() => _AddExcelFileState();
}

class _AddExcelFileState extends State<AddExcelFile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.05,
            child: RaisedButton(
              splashColor: Colors.grey[350],
              elevation: 5.0,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () async {
                // FilePicker.getFile();
                setState(() {
                  counter = 1;
                });

                var email;
                var password;
                var organization;
                var emailIndex;
                var passwordIndex;
                var orgIndex;
                var loginpage = new LoginPageState();
                List listOfRows = [];
                var filePath = await FilePicker.getFilePath(type: FileType.any);
                // File file = await FilePicker.getFile(type: FileType.any);
                print(filePath);
                print("FILE");
                // File data = new File(filePath);
                // ByteData data = await rootBundle.load(filePath);
                Uint8List byteData = new File(filePath).readAsBytesSync();
                ByteData data = ByteData.view(byteData.buffer);
                var bytes = data.buffer
                    .asUint8List(data.offsetInBytes, data.lengthInBytes);
                var excel = Excel.decodeBytes(bytes, update: true);
                for (var table in excel.tables.keys) {
                  print(table); //sheet Name
                  //var cols = excel.tables[table].maxCols;
                  var rows = excel.tables[table].maxRows;
                  List row1 = [];
                  for (var table in excel.tables.keys) {
                    print(table); //sheet Name
                    print(excel.tables[table].maxCols);
                    print(excel.tables[table].maxRows);
                    for (var row in excel.tables[table].rows) {
                      for (var eachElement = 0;
                          eachElement < row.length;
                          eachElement++) {
                        row1.add(row[eachElement]);
                      }
                      // print("$row");
                      break;
                    }
                    print(row1);
                  }
                  for (var row in excel.tables[table].rows) {
                    listOfRows.add(row);
                  }
                  print(listOfRows);
                  for (var i = 0; i < row1.length; i++) {
                    if (row1[i] == 'Email') {
                      emailIndex = i;
                    } else if (row1[i] == 'Password') {
                      passwordIndex = i;
                    } else if (row1[i] == 'Organization') {
                      orgIndex = i;
                    }
                  }
                  // var firebaseUserAdmin = await FirebaseAuth.instance.currentUser();
                  // var currentUserEmail = firebaseUserAdmin.email;
                  List emailList = [];
                  print(emailIndex.toString() + ' ' + passwordIndex.toString());
                  bool val;
                  for (var i = 1; i < rows; i++) {
                    email = listOfRows[i][emailIndex];
                    password = listOfRows[i][passwordIndex];
                    organization = listOfRows[i][orgIndex];
                    print(email);
                    print(password);
                    print(organization);
                    val =
                        await loginpage.submit1(email, password, organization);
                    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    emailList.add(email);
                  }
                  uploadedSheetAlert(context);
                  Auth auth = Provider.of(context).auth;
                  await auth.signOut();
                }
              },
              child: Text("Add Files", style: TextStyle(color: Colors.white)),
            )));
  }
}

wait(BuildContext context) {
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.push(
      //   context,
      //   // MaterialPageRoute(builder: (context) => Login1()),
      //   MaterialPageRoute(builder: (context) => pop()),
      // );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Note:"),
    content: Text("Please wait for few seconds until we add all the users!"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

uploadedSheetAlert(BuildContext context) {
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Login1()),
      //   // MaterialPageRoute(builder: (context) => pop()),
      // );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Congratulations!"),
    content: Text("Users Added Successfully! Please login again"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// ignore: camel_case_types
class Instructions_layout extends StatefulWidget {
  @override
  _Instructions_layoutState createState() => _Instructions_layoutState();
}

// ignore: camel_case_types
class _Instructions_layoutState extends State<Instructions_layout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: <Widget>[
          Text(
            "Instructions to upload .xlsx File",
            style: TextStyle(
                fontFamily: 'Courgette',
                color: Colors.black,
                fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Uploaded file must include 3 columns named as Email, Password, Organization",
            style: TextStyle(
                fontFamily: 'Courgette',
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Email will be sent to all the Employees/Students to reset their default password",
            style: TextStyle(
                fontFamily: 'Courgette',
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
    /*Container(
      child: Column(
        children: <Widget>[
          Divider(),
          Text("Instructions to upload .xlsx File"),
          Divider(),
          Text(
              "Uploaded file must include 3 columns named as Email, Password, Organization"),
          Divider(),
          Text(
              "Email will be sent to all the Employees/Students to reset their default password"),
        ],
      ),
      // child: Text("Instructions to upload .xlsx File"),
    );*/
  }
}
