import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:page_transition/page_transition.dart';
import 'main.dart';
import 'adminlogin.dart';
// import '../page_transition.dart';

var count = 0;

class AdminReq extends StatefulWidget {
  @override
  _AdminReqState createState() => _AdminReqState();
}

class _AdminReqState extends State<AdminReq> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "sample text",
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _toDash() {
      // Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 600),
            child: AdminFirst()),
      );
    }

    return WillPopScope(
        onWillPop: () {
          _toDash();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 600),
                    child: AdminFirst()),
              ),
            ),
            backgroundColor: Colors.white,
            iconTheme: new IconThemeData(color: Colors.black),
            title: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "Admin Panel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            elevation: 0,
          ),
          body: Baselayout(),
        ));
  }
}

void invalidUser(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("Invalid Credentials"),
    content: Text("Admin has not accepted your request please try again later"),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text("OK"),
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

class Baselayout extends StatefulWidget {
  @override
  _Baselayout createState() => _Baselayout();
}

class _Baselayout extends State<Baselayout> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(30.0),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            // Padding(
            // padding: const EdgeInsets.only(
            //   left: 10.0, top: 10.0, right: 10.0),
            Column(
              children: <Widget>[
                Card(),
                Text(
                  'Your organization has to be verified to avail the Admin part of CovidProtect',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Container(
                  child: RaisedButton(
                    color: Colors.black,
                    onPressed: () {
                      send();
                    },
                    child: Center(
                      child: Text(
                        'Request Credentials',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    elevation: 5,
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("Already Requested?")),
                Container(
                  child: RaisedButton(
                    color: Colors.black,
                    onPressed: ()
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LoginPage()),
                        // );
                        async {
                      print("Admin page output: ");
                      var firebaseUser =
                          await FirebaseAuth.instance.currentUser();
                      print(firebaseUser.email);
                      final response = (await FirebaseDatabase.instance
                              .reference()
                              .child('admin')
                              .once())
                          .value;
                      var jsonEncodeCount = jsonEncode(response);
                      Map jsonDecodeCount = jsonDecode(jsonEncodeCount);
                      try {
                        var uidCount = jsonDecodeCount.keys.toList();
                        print(
                            'inside adminfirst==========================================================');
                        var i;
                        for (i in uidCount) {
                          final response1 = (await FirebaseDatabase.instance
                                  .reference()
                                  .child('admin')
                                  .child(i)
                                  .child('email')
                                  .once())
                              .value;

                          if (firebaseUser.email == response1) {
                            count = 1;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminLog()),
                            );
                          }
                        }
                        print(count);
                        if (count == 0) {
                          print("Enter valid credentials");
                          invalidUser(context);
                        }
                      } catch (e) {}
                    },
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ],
        )));
  }

  bool isHTML = false;

  Future<void> send() async {
    final Email email = Email(
      body:
          'I am (name) representing (organization name) with the position of (designation). I sincerely state that,'
          ' I will be using the admin part for the benefit of my organization and to join in the public goal of fighting against this virus.\n\n'
          'Thanks and regards,\n'
          '(Name)',
      subject: 'Request for Admin Credentials',
      recipients: ['cblueeyesoft@gmail.com'],
      // cc: ['cc@example.com'],
      isHTML: isHTML,
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      showAlertDialog(context);
    } catch (error) {
      platformResponse = error.toString();
    }
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('Dialog');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminReq()),
      );
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Success"),
    content: Text(
        "Your request is successfully sent. We will provide you the admin credentials as soon as possible."),
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

class Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Admin App is a custom part created crucially for your administration',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Bebas", fontSize: 30, color: Colors.black),
          ),
          Text(
            'The Admin Part is going to help you validate and keep track of the number of cases in your organization',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Divider(
            height: 20,
          ),
          Image(image: AssetImage('images/admin/app.png')),
          Divider(
            height: 20,
          ),
        ]);
  }
}
