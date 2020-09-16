import 'dart:convert';
import 'package:adminApp/adminlogin.dart';
import 'package:adminApp/adminrequest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:sakecblue/AdminApp/adminrequest.dart';
// import 'package:sakecblue/AdminApp/auth.dart';
// import 'package:sakecblue/AdminApp/provider.dart';
// import 'package:sakecblue/Dashboard/dashboard.dart';
// import '../page_transition.dart';

void main() {
  runApp(AdminFirst());
}

var count = 0;
class AdminFirst extends StatefulWidget {
  @override
  _AdminFirstState createState() => _AdminFirstState();
}

class _AdminFirstState extends State<AdminFirst> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "sample text",
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState(){
  super.initState();
  setState(() {
    count = 0;
  });
  
}



  @override
  Widget build(BuildContext context) {
    void _toDash() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    return WillPopScope(
        onWillPop: () {
          _toDash();
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            // onPressed: () async {
            //   print("Adminfirst page output: ");
            //   var firebaseUser = await FirebaseAuth.instance.currentUser();
            //   print(firebaseUser.email);
            //   final response = (await FirebaseDatabase.instance
            //           .reference()
            //           .child('admin')
            //           .once())
            //       .value;
            //   var jsonEncodeCount = jsonEncode(response);
            //   Map jsonDecodeCount = jsonDecode(jsonEncodeCount);
            //   try {
            //     var uidCount = jsonDecodeCount.keys.toList();
            //     print(
            //         'inside adminfirst==========================================================');
            //     var i;
            //     for (i in uidCount) {
            //       final response1 = (await FirebaseDatabase.instance
            //               .reference()
            //               .child('admin')
            //               .child(i)
            //               .child('email')
            //               .once())
            //           .value;

            //       if (firebaseUser.email == response1) {
            //         setState(() {
            //           count=1;
            //         });
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => AdminLog()),
            //         );
            //       }
            //     }
            //     print(count);
            //     if (count == 0) {
            //       // print("Enter valid credentials");
            //       // invalidUser(context);
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => AdminLog()),
            //       );
            //     }
            //   } catch (e) {}
            // },
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminLog()),
              );
            },
            child: Icon(Icons.arrow_forward),
          ),
          backgroundColor: Colors.white,
          appBar: AppBar(
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back, color: Colors.black),
            //   onPressed: () {
            //     //Navigator.of(context).popUntil((route) => route.isFirst);
            //     Navigator.push(
            //       context,
            //       PageTransition(
            //           type: PageTransitionType.rightToLeftWithFade,
            //           duration: Duration(milliseconds: 600),
            //           child: Dash()),
            //     );
            //   },
            // ),
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
        )
        );

     
  }
}
class Baselayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Welcome to the\nadmin panel of\n'CovidProtect'",
                  style: TextStyle(
                      fontFamily: "Bebas", fontSize: 48, color: Colors.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: splay_image(),
            ),
          ],
        ));
  }
}

class splay_image extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage('images/admin/admin_splay.png'));
  }
}
