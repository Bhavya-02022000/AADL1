import 'dart:io';
import 'dart:typed_data';

import 'auth.dart';
import 'data_store.dart';

import 'provider.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin_dasboard.dart';
import 'main1.dart';

class Upload_data extends StatefulWidget {
  @override
  _Upload_dataState createState() => _Upload_dataState();
}

class _Upload_dataState extends State<Upload_data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Register Users'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                Auth auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Admin_dash()),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
      body: Sheet_Layout(),
    );
  }
}

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
          Add_files(),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Instructions_layout(),
        ],
      ),
    );
  }
}

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

class Add_files extends StatelessWidget {
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
                print("Ab tuje kya natak hai");
                // File data = new File(filePath);
                // ByteData data = await rootBundle.load(filePath);
                Uint8List byteData = new File(filePath).readAsBytesSync();
                ByteData data = ByteData.view(byteData.buffer);
                var bytes = data.buffer
                    .asUint8List(data.offsetInBytes, data.lengthInBytes);
                var excel = Excel.decodeBytes(bytes, update: true);
                for (var table in excel.tables.keys) {
                  print(table); //sheet Name
                  var cols = excel.tables[table].maxCols;
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
                  for (var i = 1; i < rows; i++) {
                    email = listOfRows[i][emailIndex];
                    password = listOfRows[i][passwordIndex];
                    organization = listOfRows[i][orgIndex];
                    print(email);
                    print(password);
                    print(organization);
                    loginpage.submit1(email, password, organization);
                    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    emailList.add(email);
                    Auth auth = Provider.of(context).auth;
                    await auth.signOut();
                  }
                  // loginpage.submit2(DataStore.storedEmailOfAdmin,DataStore.storedPasswordOfAdmin);
                  var firebaseUser = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: DataStore.storedEmailOfAdmin,
                          password: DataStore.storedPasswordOfAdmin);
                  print("dhoodh ka dhoodh paani ka paani");
                  print(firebaseUser);

                  // var emailString = emailList.toString();
                  // // emailList.removeAt(-1);
                  // print(emailString);
                  // var e1 = emailString.replaceFirst('[', '');
                  // var e2 = e1.replaceFirst(']', '');
                  // print(e2);
                  // final Email emailsender = Email(
                  //   body: 'Email Id: ' + e2 + '\nPassword' + password,
                  //   subject: 'Email and Password',
                  //   recipients: [e2],
                  //   // cc: ['cc@example.com'],

                  //   // bcc: [e2],
                  //   // attachmentPaths: ['Aaj k liye bas ab sojaa'],
                  //   isHTML: false,
                  // );
                  // await FlutterEmailSender.send(emailsender);
                }
              },
              child: Text("Add Files", style: TextStyle(color: Colors.white)),
            )));
  }
}

class Instructions_layout extends StatefulWidget {
  @override
  _Instructions_layoutState createState() => _Instructions_layoutState();
}

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
