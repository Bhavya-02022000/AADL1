import 'dart:async';
import 'dart:convert';
// import 'package:adminApp/adminrequest.dart';
import 'package:adminApp/auth.dart';
import 'package:adminApp/main.dart';
import 'package:adminApp/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:sakecblue/AdminApp/auth.dart';
// import 'package:sakecblue/AdminApp/provider.dart';
// import 'package:sakecblue/Dashboard/dashboard.dart';
// import 'package:sakecblue/Login/Login2/screens/login/login.dart';
// import 'package:sakecblue/Login/auth.dart';
// import 'package:sakecblue/Login/provider.dart';

// import '../page_transition.dart';
// import 'AI/lib/InputScreen/timetableinputscreen.dart';
import 'adminlogin.dart';
import 'datastore.dart';
import 'sheet.dart';

int abc;
int highRiskCount = 0;
int lowRiskCount = 0;
int medRiskCount = 0;
void selectType(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("Are you sure?"),
    content: Text("Do you want to go to the First page"),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text("No"),
      ),
      FlatButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600),
                child: AdminFirst()),
          );
        },
        child: Text("Yes"),
      )
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

// ignore: camel_case_types
class Admin_dash extends StatefulWidget {
  @override
  _Admin_dashState createState() => _Admin_dashState();
}

// ignore: camel_case_types
class _Admin_dashState extends State<Admin_dash> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          selectType(context);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              // onPressed: () => Navigator.push(
              //   context,
              //   PageTransition(
              //       type: PageTransitionType.rightToLeft,
              //       duration: Duration(milliseconds: 600),
              //       child: Upload_data()),
              // ),
              onPressed: () {
                selectType(context);
              },
            ),
            title: Text('Dashboard'),
            backgroundColor: Colors.black,
            actions: <Widget>[
              FlatButton(
                child: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile_dash(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Dashboard_Layout(),
        ));
  }
}

// ignore: camel_case_types
class Dashboard_Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LeftText(),
                  // Right_graph(),
                ],
              ),
            ],
          ),
        ));
  }
}

//pie chart end
class LeftText extends StatefulWidget {
  @override
  _LeftTextState createState() => _LeftTextState();
}

var loginpage1 = new LoginPageState();

class _LeftTextState extends State<LeftText> {
  static List<String> statusCount = [];
  static List<String> emailCount = [];
  var loginpage = new LoginPageState();
  adminLogin() async {
    var firebaseUser1 = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: DataStore.storedEmailOfAdmin,
        password: DataStore.storedPasswordOfAdmin);
    var firebaseUser2 = await FirebaseAuth.instance.currentUser();
    print("Init state " + firebaseUser2.uid);
    setState(() {
      statusCount = [];
      emailCount = [];
    });
  }

  newFunction() async {
    // setState(() async {
    setState(
      () {
        statusCount = [];
        emailCount = [];
      },
    );
    print("In function================");
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.uid);
    String organization = (await FirebaseDatabase.instance
            .reference()
            .child('selfAssessmentUser')
            .child(firebaseUser.uid)
            .child('organization')
            .once())
        .value;
    print(organization);
    final response = (await FirebaseDatabase.instance
            .reference()
            .child('organization')
            .child(organization)
            .once())
        .value;
    var jsonEncodeCount = jsonEncode(response);
    Map jsonDecodeCount = jsonDecode(jsonEncodeCount);
    try {
      var uidCount = jsonDecodeCount.keys.toList();
      for (var i in uidCount) {
        final response1 = (await FirebaseDatabase.instance
                .reference()
                .child('organization')
                .child(organization)
                .child(i)
                .child('status')
                .once())
            .value;
        var res1 = response1.toString();
        var res2 = res1.trim();
        statusCount.add(
          res2,
        );
        final response2 = (await FirebaseDatabase.instance
                .reference()
                .child('organization')
                .child(organization)
                .child(i)
                .child('email')
                .once())
            .value;
        emailCount.add(response2.toString());
      }
      setState(() {
        medRiskCount = 0;
        highRiskCount = 0;
        lowRiskCount = 0;
      });
      print(statusCount);
      for (var i in statusCount) {
        if (i == " Low Risk" || i == "Low Risk") {
          setState(() {
            lowRiskCount = lowRiskCount + 1;
          });
        } else if (i == " Medium Risk" || i == "Medium Risk") {
          setState(() {
            medRiskCount = medRiskCount + 1;
          });
        } else if (i == " High Risk" || i == "High Risk") {
          setState(() {
            highRiskCount = highRiskCount + 1;
          });
        } else {
          // setState(() {
          //   highRiskCount = 0;
          //   medRiskCount = 0;
          //   lowRiskCount = 0;
          // });
        }
      }
      print(uidCount.length);
      print(highRiskCount);
      print(medRiskCount);
      print(lowRiskCount);
      // print(DataStore.uid);
      setState(() {
        total = uidCount.length;
      });
    } catch (e) {
      setState(() {
        total = 0;
        medRiskCount = 0;
        highRiskCount = 0;
        lowRiskCount = 0;
      });
    }
  }

  int total = 0;
  int medRiskCount = 0;
  int highRiskCount = 0;
  int lowRiskCount = 0;
  void initState() {
    super.initState();
    adminLogin();
    newFunction();
    print('Init me ghusaa================================');
    const fiveSeconds = const Duration(seconds: 100);
    Timer.periodic(fiveSeconds, (Timer t) => newFunction());
  }

  Widget build(BuildContext context) {
    const grph_time = const Duration(milliseconds: 20);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // yellow box
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.25,
            //color: Colors.limeAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.32,
                  height: MediaQuery.of(context).size.height * 0.25,
                  //color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            highRiskCount.toString() ?? "Load",
                            style: TextStyle(
                                fontFamily: "Bebas",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.18,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "High Risk",
                            style: TextStyle(
                                fontFamily: "Bebas",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08,
                                color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
//                Container(
//                  width: MediaQuery.of(context).size.width * 0.52,
//                  height: MediaQuery.of(context).size.height * 0.25,
//                  // color: Colors.limeAccent,
//                  child: Chart(),
//                  // decoration: BoxDecoration(
//                  //     borderRadius: BorderRadius.all(Radius.circular(5)),
//                  //     color: Colors.white,
//                  //     image: DecorationImage(
//                  //       image: AssetImage("images/admindash.png"),
//                  //       fit: BoxFit.scaleDown,
//                  //     )),
//                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Center(
              child: Text(
                "Risk In Campus",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.black),
              ),
            ),
          ),
          // numbers row
          SizedBox(
            height: 10,
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            highRiskCount.toString() ?? "Load",
                            style: TextStyle(
                                fontFamily: "Bebas",
                                fontSize: 40,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "High Risk",
                            style: TextStyle(
                                fontFamily: 'Helvitica',
                                fontSize: 14,
                                color: Colors.red),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.limeAccent,
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            total.toString() ?? "Loading",
                            style: TextStyle(fontFamily: "Bebas", fontSize: 40),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Total",
                            style: TextStyle(
                              fontFamily: 'Helvitica',
                              fontSize: 14,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  //color: Colors.limeAccent,
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            medRiskCount.toString() ?? "Load",
                            style: TextStyle(
                                fontFamily: "Bebas",
                                fontSize: 40,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Med Risk",
                            style: TextStyle(
                                fontFamily: 'Helvitica',
                                fontSize: 14,
                                color: Colors.blue),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  //color: Colors.limeAccent,
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            lowRiskCount.toString() ?? "Load",
                            style: TextStyle(
                                fontFamily: "Bebas",
                                fontSize: 40,
                                color: Colors.green),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Low Risk",
                            style: TextStyle(
                                fontFamily: 'Helvitica',
                                fontSize: 14,
                                color: Colors.green),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 15,
          ),

          // circular indicators

          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      width: MediaQuery.of(context).size.width * 0.04,
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Text("\t\High Risk"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.blue,
                      ),
                      width: MediaQuery.of(context).size.width * 0.04,
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Text("\t\tMedium Risk"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.green,
                      ),
                      width: MediaQuery.of(context).size.width * 0.04,
                      height: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Text("\t\tLow Risk"),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 30,
          ),
          //table

          Card(
            margin: EdgeInsets.all(0),
            color: Colors.white,
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.25,
              child: ListView.builder(
                itemCount: statusCount.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Card(
                      margin: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                child: Text(
                                  "${emailCount[index]}",
                                  textAlign: TextAlign.center,
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                          //                   <--- left side
                                          color: Colors.black,
                                        ),
                                        bottom: BorderSide(
                                          //                   <--- left side
                                          color: Colors.black,
                                        ),
                                        top: BorderSide(
                                          //                    <--- top side
                                          color: Colors.black,
                                        ))),
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                child: Text(
                                  "${statusCount[index]}",
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  );

                  /*
                    ListTile(
                      title: Text(
                          "${emailCount[index]}" + " " + "${statusCount[index]}"),
                    );*/
                },
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // Container(
          //     width: MediaQuery.of(context).size.width * 0.85,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         Container(
          //             width: MediaQuery.of(context).size.width * 0.42,
          //             child: RaisedButton(
          //                 onPressed: () {
          //                   Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => IotData()),
          //                   );
          //                 },
          //                 color: Colors.black,
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(5.0),
          //                 ),
          //                 child: Padding(
          //                   padding: EdgeInsets.only(top: 10, bottom: 10),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                     children: <Widget>[
          //                       Icon(
          //                         Icons.broken_image,
          //                         color: Colors.white,
          //                       ),
          //                       AutoSizeText(
          //                         " IOT Statistics",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ))),
          //         // Container(
          //         //   width: MediaQuery.of(context).size.width * 0.42,
          //         //   child: RaisedButton(
          //         //       onPressed: () {
          //         //         Navigator.push(
          //         //           context,
          //         //           MaterialPageRoute(
          //         //               builder: (context) => TimeTableInput()),
          //         //         );
          //         //       },
          //         //       color: Colors.black,
          //         //       shape: RoundedRectangleBorder(
          //         //         borderRadius: BorderRadius.circular(5.0),
          //         //       ),
          //         //       child: Padding(
          //         //         padding: EdgeInsets.only(top: 10, bottom: 10),
          //         //         child: Row(
          //         //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         //           children: <Widget>[
          //         //             Icon(
          //         //               Icons.table_chart,
          //         //               color: Colors.white,
          //         //             ),
          //         //             AutoSizeText(
          //         //               ' AI Scheduler',
          //         //               style: TextStyle(color: Colors.white),
          //         //             ),
          //         //           ],
          //         //         ),
          //         //       )),
          //         // ),
          //       ],
          //     ))
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class Right_graph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.53,
        height: MediaQuery.of(context).size.height * 0.25,
        child: RaisedButton(
          onPressed: () {
            //link page here
          },
          child: Text("Graph Appears Here"),
          elevation: 0.0,
          color: Colors.limeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class Profile_dash extends StatefulWidget {
  @override
  _Profile_dashState createState() => _Profile_dashState();
}

// ignore: camel_case_types
class _Profile_dashState extends State<Profile_dash> {
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
                child: Admin_dash()),
          ),
        ),
        title: Text("Admin Preferences"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(35.0),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("images/admin/pre.png"),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              elevation: 3.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(3.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Add_Admin()),
                );
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Add_Admin()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Add Admin",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              elevation: 3.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(3.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Edit_organization()),
                );
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Edit_organization()),
                          );
                          // showAlertDialog_orgInstruc(context);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Edit Organization name",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              elevation: 3.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(3.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Upload_data()),
                );
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.people,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Upload_data()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Edit Users",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // RaisedButton(
            //   elevation: 3.0,
            //   color: Colors.white,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(3.0),
            //   ),
            //   onPressed: () {
            //     //link here
            //   },
            // child: Container(
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         flex: 1,
            //         child: IconButton(
            //           icon: Icon(
            //             Icons.exit_to_app,
            //             color: Colors.black,
            //             size: 30,
            //           ),
            //           onPressed: () async {
            //             try {
            //               Auth auth = Provider.of(context).auth;
            //               await auth.signOut();
            //             } catch (e) {
            //               print(e + " asdasdasdsd");
            //             }
            //             Navigator.pushReplacement(
            //               context,
            //               PageTransition(
            //                   type: PageTransitionType.rightToLeftWithFade,
            //                   duration: Duration(milliseconds: 600),
            //                   child: Dash()),
            //             );
            //           },
            //         ),
            //       ),
            //       Expanded(
            //         flex: 3,
            //         child: Text(
            //           "Sign out",
            //           textAlign: TextAlign.left,
            //           style: TextStyle(
            //               fontSize: 16,
            //               color: Colors.black54,
            //               fontWeight: FontWeight.w700),
            //         ),
            //       ),
            //       SizedBox(height: 50),
            //     ],
            //   ),
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () async {
      Auth auth = Provider.of(context).auth;
      await auth.signOut();
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
    title: Text("Congratulations!"),
    content: Text(
        "Admin Added Successfully! Please login again. \nNote:\nIf the new admin is already registered then their password will not be changed!"),
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

showAlertDialog1(BuildContext context) {
  Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile_dash()),
        );
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error Message"),
    content: Text("Please add valid credentials"),
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

showAlertDialog2(BuildContext context) {
  Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile_dash()),
        );
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error Message"),
    content: Text("An Error occured. Please try to sign in again and change."),
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

showAlertDialog_new(BuildContext context) {
  Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile_dash()),
        );
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error Message"),
    content:
        Text("This organization name already exists. Please try another name!"),
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

showAlertDialog_orgInstruc(BuildContext context) {
  Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Edit_organization()),
        );
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Note"),
    content: Text(
        "This will Edit only your organization name and NOT the members of your organization. To see the health status of your org members, please upload a new excel file with latest organization."),
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

showAlertDialogEditOrganization(BuildContext context) {
  Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile_dash()),
        );
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Update"),
    content: Text("Your Organization name was successfully updated."),
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
class Edit_organization extends StatefulWidget {
  @override
  _Edit_organizationState createState() => _Edit_organizationState();
}

// ignore: camel_case_types
class _Edit_organizationState extends State<Edit_organization> {
  String organization;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Organization"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("images/admin/edit.png"),
                      fit: BoxFit.scaleDown,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "Change Organization Name",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
                        // validator: EmailValidator.validate,
                        decoration: InputDecoration(
                            labelText: 'Enter New Organization'),
                        onSaved: (value) => organization = value,
                        onChanged: (text) {
                          print("Text : $text");
                          setState(() {
                            organization = text;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                          color: Colors.black,
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(3.0),
                          ),
                          onPressed: () async {
                            print("Admin Profile inside Raised Button");
                            print(organization);
                            try {
                              // await FirebaseAuth.instance
                              //     .signInWithEmailAndPassword(
                              //         email: DataStore.storedEmailOfAdmin,
                              //         password:
                              //             DataStore.storedPasswordOfAdmin);

                              var firebaseUser =
                                  await FirebaseAuth.instance.currentUser();

                              final response = (await FirebaseDatabase.instance
                                      .reference()
                                      .child('organization')
                                      .once())
                                  .value;
                              var jsonEncodeCount = jsonEncode(response);
                              Map jsonDecodeCount = jsonDecode(jsonEncodeCount);
                              var condition = 0;
                              try {
                                var uidCount = jsonDecodeCount.keys.toList();
                                print(
                                    'inside try==========================================================');
                                var i;
                                for (i in uidCount) {
                                  if (i == organization) {
                                    condition = 1;
                                    break;
                                  }
                                }
                              } catch (e) {}
                              if (condition == 0) {
                                await FirebaseDatabase.instance
                                    .reference()
                                    .child("admin")
                                    .child(firebaseUser.uid)
                                    .update({"organization": organization});
                                await FirebaseDatabase.instance
                                    .reference()
                                    .child("selfAssessmentUser")
                                    .child(firebaseUser.uid)
                                    .update({'organization': organization});
                                showAlertDialogEditOrganization(context);
                                // Auth auth = Provider.of(context).auth;
                                // await auth.signOut();
                              } else {
                                showAlertDialog_new(context);
                              }
                            } catch (e) {
                              showAlertDialog2(context);
                            }

                            // await auth.signOut();
                          }),
                      SizedBox(height: 20),
                      Text(
                        "This will change only your organization and NOT your users organization. Please upload a new excel file of your users with the new organization name if you wish to see your current users health status!",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                  // ADD your Bt address  TextField here-----------------------------------------------

                  ),
            ],
          ),
        ),
      )),
    );
  }
}

// ignore: camel_case_types
class Add_Admin extends StatefulWidget {
  @override
  _Add_AdminState createState() => _Add_AdminState();
}

var loginpage = new LoginPageState();

// ignore: camel_case_types
class _Add_AdminState extends State<Add_Admin> {
  // var email, password, organization;
  String email, password, organization;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Admin"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage("images/admin/add.png"),
                      fit: BoxFit.scaleDown,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Center(
                  child: Text(
                    " Add New Admin",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    TextFormField(
                      // validator: EmailValidator.validate,
                      decoration: InputDecoration(labelText: 'Enter Email'),
                      onSaved: (value) => email = value,
                      onChanged: (text) {
                        print("Text : $text");
                        setState(() {
                          email = text;
                        });
                      },
                    ),
                    TextFormField(
                      // validator: PasswordValidator.validate,
                      decoration: InputDecoration(labelText: 'Enter Password'),
                      obscureText: true,
                      onSaved: (value) => password = value,
                      onChanged: (text) {
                        print("Text : $text");
                        setState(() {
                          password = text;
                        });
                      },
                    ),
                    // TextFormField(
                    //   // validator: PasswordValidator.validate,
                    //   decoration: InputDecoration(
                    //       labelText: 'Enter Name of Organization'),
                    //   obscureText: true,
                    //   onSaved: (value) => organization = value,
                    //   onChanged: (text) {
                    //     print("Text : $text");
                    //     setState(() {
                    //       organization = text;
                    //     });
                    //   },
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.black,
                      onPressed: () async {
                        var firebaseUser =
                            await FirebaseAuth.instance.currentUser();
                        final response = (await FirebaseDatabase.instance
                                .reference()
                                .child('admin')
                                .child(firebaseUser.uid)
                                .child('organization')
                                .once())
                            .value;
                        setState(() {
                          organization = response;
                        });
                        print("Admin Profile inside Raised Button");
                        print(email);
                        print(password);
                        print("Calling addAdmin");
                        bool val = await loginpage.addAdmin(
                            email, password, organization);
                        print(val);
                        print("value");
                        if (val) {
                          showAlertDialog(context);
                          Auth auth = Provider.of(context).auth;
                          await auth.signOut();
                        } else {
                          showAlertDialog1(context);
                        }
                      },
                    ),
                  ],
                ),
                // ADD your Bt address  TextField here-----------------------------------------------
              ),
            ],
          ),
        ),
      )),
    );
  }
}

//pie chart start
//
//class Chart extends StatefulWidget {
//  @override
//  _ChartState createState() => _ChartState();
//}
//
//class _ChartState extends State<Chart> {
//  List<PieChartSectionData> _sections = List<PieChartSectionData>();
//
//  @override
//  void initState() {
//    super.initState();
//    PieChartSectionData _item1 = PieChartSectionData(
//        color: Colors.blueAccent, value: 30, radius: 15, title: " ");
//    PieChartSectionData _item2 = PieChartSectionData(
//        color: Colors.redAccent, value: 10, radius: 15, title: " ");
//    PieChartSectionData _item3 = PieChartSectionData(
//        color: Colors.green, value: 60, radius: 15, title: " ");
//    _sections = [_item1, _item2, _item3];
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: AspectRatio(
//        aspectRatio: 1,
//        child: FlChart(
//          chart: PieChart(
//            PieChartData(
//              sections: _sections,
//              borderData: FlBorderData(show: false),
//              centerSpaceRadius: 65,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
