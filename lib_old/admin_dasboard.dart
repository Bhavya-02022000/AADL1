import 'package:adminApp/sheet.dart';
import 'auth.dart';
import 'data_store.dart';
import 'provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:adminApp/main1.dart';

class Admin_dash extends StatefulWidget {
  @override
  _Admin_dashState createState() => _Admin_dashState();
}

class _Admin_dashState extends State<Admin_dash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile_dash()),
          );
        },
        label: Text('Admin Profile'),
        icon: Icon(Icons.perm_identity),
        backgroundColor: Colors.blueAccent,
      ),
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              try {
                Auth auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e + " asdasdasdsd");
              }
            },
          )
        ],
      ),
      body: Dashboard_Layout(),
    );
  }
}

class Dashboard_Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          //date start
          /*   Container(
              child: Align(
            alignment: Alignment.centerRight,
            // child: RaisedButton.icon(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(25),
            //   ),
            //   color: Colors.black,
            //   onPressed: () {
            //     //date picker here
            //   },
            //   icon: Icon(
            //     Icons.date_range,
            //     color: Colors.white,
            //   ),
            //   label: Text(
            //     "Date",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          )),*/
          //date end
          //text and graph row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LeftText(),
              // Right_graph(),
            ],
          ),
          //text and graph end
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.only(top: 20, bottom: 5),
          //       child: Text(
          //         "Risk In Campus",
          //         style: TextStyle(fontFamily: "Helvitica", fontSize: 20),
          //       ),
          //     )
          //   ],
          // ),
          // risk numbers
          /*  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // TotalriskNumbers(),
              // HighriskNumbers(),
              // MedriskNumbers(),
              // LowriskNumbers(),
            ],
          ),*/

          //risk numbers end
        ],
      ),
    );
  }
}

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
    setState(() {
      statusCount = [];
      emailCount = [];
    });
    print("In function================");
    // var firebaseUser = await FirebaseAuth.instance.currentUser();
    // loginpage1.callAdminCredentials();
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.uid);
    String organization = (await FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(firebaseUser.uid)
            .child('organization')
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
        statusCount.add(response1.toString());
        // var jsonEncodeCount1 = jsonEncode(response1);
        // Map jsonDecodeCount1 = jsonDecode(jsonEncodeCount1);
        // var uidCount = jsonDecodeCount1.keys;
        // print(uidCount);
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
        primaryCount = 0;
        infectedCount = 0;
        safeCount = 0;
      });
      print(statusCount);
      for (var i in statusCount) {
        if (i == "Safe") {
          setState(() {
            safeCount = safeCount + 1;
          });
        } else if (i == "Primary Infected") {
          setState(() {
            primaryCount = primaryCount + 1;
          });
        } else {
          setState(() {
            infectedCount = infectedCount + 1;
          });
        }
      }
      print(uidCount.length);
      print(infectedCount);
      print(primaryCount);
      print(safeCount);
      // print(DataStore.uid);
      setState(() {
        total = uidCount.length;
      });
    } catch (e) {
      setState(() {
        total = 0;
        primaryCount = 0;
        infectedCount = 0;
        safeCount = 0;
      });
    }
  }

  @override
  int total = 0;
  int safeCount = 0;
  int primaryCount = 0;
  int infectedCount = 0;
  // var loginpage = new LoginPageState();
  void initState() {
    super.initState();
    adminLogin();
    // loginpage.submit2(DataStore.storedEmailOfAdmin,DataStore.storedPasswordOfAdmin);
    // var firebaseUser =
    //       await FirebaseAuth.instance.currentUser();
    // print("Init state "+firebaseUser.uid);
    newFunction();
    print('Init me ghusaa================================');
    const fiveSeconds = const Duration(seconds: 10);
    Timer.periodic(fiveSeconds, (Timer t) => newFunction());
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.33,
        // height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: <Widget>[
            RaisedButton(
              elevation: 5.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(11.0),
              ),
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              infectedCount.toString() ?? "Load",
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
                              "Confirmed",
                              style: TextStyle(
                                  fontFamily: 'Bebas',
                                  fontSize: 20,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              total.toString() ?? "Loading",
                              style:
                                  TextStyle(fontFamily: "Bebas", fontSize: 40),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total",
                              style:
                                  TextStyle(fontFamily: 'Bebas', fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              primaryCount.toString() ?? "Load",
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
                              "Primary",
                              style: TextStyle(
                                  fontFamily: 'Bebas',
                                  fontSize: 20,
                                  color: Colors.blue),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              safeCount.toString() ?? "Load",
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
                              "Safe",
                              style: TextStyle(
                                  fontFamily: 'Bebas',
                                  fontSize: 20,
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
              height: 30,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.04,
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.red,
                          ),
                          Text("\t\tInfected")
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.only(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.04,
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.blue,
                          ),
                          Text("\t\tPrimary Infected")
                        ],
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.only(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.04,
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: Colors.green,
                          ),
                          Text("\t\tSafe")
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              margin: EdgeInsets.all(0),
              color: Colors.white,
              elevation: 15,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
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
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

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

class Profile_dash extends StatefulWidget {
  @override
  _Profile_dashState createState() => _Profile_dashState();
}

class _Profile_dashState extends State<Profile_dash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              elevation: 5.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
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
                      flex: 3,
                      child: Text(
                        "Add Admin",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 50),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Add_Admin()),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              elevation: 5.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
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
                      flex: 3,
                      child: Text(
                        "Edit Organization name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 50),
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
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              elevation: 5.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
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
                      flex: 3,
                      child: Text(
                        "Edit Users",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 50),
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile_dash()),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Congratulations!"),
    content: Text("Admin Added Successfully"),
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

class Edit_organization extends StatefulWidget {
  @override
  _Edit_organizationState createState() => _Edit_organizationState();
}

class _Edit_organizationState extends State<Edit_organization> {
  String organization;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Organization"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    icon: Icon(
                      Icons.people,
                      color: Colors.blue,
                    ),
                    iconSize: 50,
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
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
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
                        // validator: EmailValidator.validate,
                        decoration: InputDecoration(labelText: 'Organization'),
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
                          color: Colors.blueAccent,
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          onPressed: () async {
                            print("Admin Profile inside Raised Button");
                            print(organization);
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: DataStore.storedEmailOfAdmin,
                                      password:
                                          DataStore.storedPasswordOfAdmin);

                              var firebaseUser =
                                  await FirebaseAuth.instance.currentUser();
                              await FirebaseDatabase.instance
                                  .reference()
                                  .child("admin")
                                  .child(firebaseUser.uid)
                                  .set({"organization": organization});
                              await FirebaseDatabase.instance
                                  .reference()
                                  .child("users")
                                  .child(firebaseUser.uid)
                                  .child("organization")
                                  .set({'organization': organization});
                              showAlertDialogEditOrganization(context);
                            } catch (e) {
                              showAlertDialog2(context);
                            }
                            // await auth.signOut();
                          }),
                    ],
                  )
                  // ADD your Bt address  TextField here-----------------------------------------------

                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class Add_Admin extends StatefulWidget {
  @override
  _Add_AdminState createState() => _Add_AdminState();
}

var loginpage = new LoginPageState();

class _Add_AdminState extends State<Add_Admin> {
  // var email, password, organization;
  String email, password, organization;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Admin"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    icon: Icon(
                      Icons.people,
                      color: Colors.blue,
                    ),
                    iconSize: 50,
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  "Admin",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
                        // validator: EmailValidator.validate,
                        decoration: InputDecoration(labelText: 'Email'),
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
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        onSaved: (value) => password = value,
                        onChanged: (text) {
                          print("Text : $text");
                          setState(() {
                            password = text;
                          });
                        },
                      ),
                      TextFormField(
                        // validator: PasswordValidator.validate,
                        decoration: InputDecoration(labelText: 'Organization'),
                        obscureText: true,
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
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blueAccent,
                          onPressed: () async {
                            print("Admin Profile inside Raised Button");
                            print(email);
                            print(password);
                            bool val = await loginpage.addAdmin(
                                email, password, organization);
                            if (val) {
                              showAlertDialog(context);
                            } else {
                              showAlertDialog1(context);
                            }
                            // // var firebaseUser = await FirebaseAuth.instance.currentUser();
                            // Auth auth = Provider.of(context).auth;
                            // await auth.signOut();
                          }),
                    ],
                  )
                  // ADD your Bt address  TextField here-----------------------------------------------

                  ),
            ],
          ),
        ),
      ),
    );
  }
}
