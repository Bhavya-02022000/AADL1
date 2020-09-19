import 'dart:convert';

import 'package:adminApp/adminrequest.dart';
import 'package:adminApp/auth.dart';
import 'package:adminApp/provider.dart';
import 'package:adminApp/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:sakecblue/Login/auth.dart';
// import 'package:sakecblue/Login/provider.dart';
// import 'package:sakecblue/AdminApp/auth.dart';
// import 'package:sakecblue/AdminApp/provider.dart';

// import 'package:sakecblue/Login/validators.dart';

import 'datastore.dart';
import 'sheet.dart';

class AdminLog extends StatefulWidget {
  @override
  _AdminLogState createState() => _AdminLogState();
}

class _AdminLogState extends State<AdminLog> {
  @override
  void initState() {
    super.initState();
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Admin App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool loggedIn = snapshot.hasData;
          if (loggedIn == true) {
            debugPrint("Logged IN");
            return Upload_data();
          } else {
            return LoginPage();
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Welcome Page'),
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              try {
                Auth auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e);
              }
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text('Welcome'),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  // var emailOfAdmin;
  // var passwordOfAdmin;
  // ignore: non_constant_identifier_names
  String PhoneNo, verificationId, smsCode;
  String email, password, organization;
  String emailOfStudent, passwordOfStudent;
  FormType _formType = FormType.login;

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // var emailOfAdmin;
  // var passwordOfAdmin;

  void submit2(email, password) async {
    final auth = Provider.of(context).auth;
    String userId = await auth.signInWithEmailAndPassword(
      email,
      password,
    );
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    print("Submit2 " + firebaseUser.uid);
  }

  void invalidUser(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Invalid Credentials"),
      content:
          Text("You are already a member of an organization. Please register with another email or else ask your organization head to add you as Admin."),
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

  void submit() async {
    print("Inside submit");
    if (validate()) {
      try {
        print("Inside signin");
        print(email);
        print(password);
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
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

              if (email == response1) {
                setState(() {
                  count = 1;
                });
                String userId = await auth.signInWithEmailAndPassword(
                  email,
                  password,
                );
                print('Signed in $userId');

                print("Admin page output: ");
                var firebaseUser = await FirebaseAuth.instance.currentUser();
                print(firebaseUser.email);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Upload_data()),
                );
              }
            }
            print(count);
            if (count == 0) {
              print("Enter valid credentials");

              Auth auth = Provider.of(context).auth;
              await auth.signOut();
              invalidUser(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AdminLog()),
              // );
            }
          } catch (e) {}
        } else {
          print("Inside create acc");
          String userId = await auth.createUserWithEmailAndPassword(
            email,
            password,
          );

          var firebaseUser = await FirebaseAuth.instance.currentUser();
          print("Inside createUserWithEmailAndPassword");
          print(firebaseUser.uid);
          print(firebaseUser.email);
          (await FirebaseDatabase.instance
              .reference()
              .child('selfAssessmentUser')
              .child(firebaseUser.uid)
              .set(
                  {"email": firebaseUser.email, "organization": organization, "result":"Low Risk"}));

          DataStore.storedEmailOfAdmin = email;
          DataStore.storedPasswordOfAdmin = password;

          print('Registered in $userId');

          DataStore.uid = firebaseUser.uid;

          await FirebaseDatabase.instance
              .reference()
              .child("admin")
              .child(firebaseUser.uid)
              .set({"organization": organization, "email": email, "result": "Low Risk"});
          // Auth auth1 = Provider.of(context).auth;
          // await auth.signOut();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  showAlertDialog(BuildContext context) {
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

  Future<bool> addAdmin(email, password, organization) async {
    try {
      print("New Admin " + email + " " + password);
      try {
        AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        var firebaseUser = await FirebaseAuth.instance.currentUser();
        await FirebaseDatabase.instance
            .reference()
            .child("selfAssessmentUser")
            .child(firebaseUser.uid)
            .update({
          'organization': organization,
        });
        await FirebaseDatabase.instance
            .reference()
            .child("selfAssessmentUser")
            .child(firebaseUser.uid)
            .update({
          'email': email,
        });
        await FirebaseDatabase.instance
            .reference()
            .child("admin")
            .child(firebaseUser.uid)
            .set({"organization": organization, "email": email, "result":"Low Risk"});
        showAlertDialog(context);
        Auth auth = Provider.of(context).auth;
        await auth.signOut();
      } catch (e) {
        // AuthResult user = await FirebaseAuth.instance
        //     .signInWithEmailAndPassword(email: email, password: password);
        // .createUserWithEmailAndPassword(email: email, password: password);
        final response = (await FirebaseDatabase.instance
                .reference()
                .child('selfAssessmentUser')
                .once())
            .value;
        var jsonEncodeCount = jsonEncode(response);
        Map jsonDecodeCount = jsonDecode(jsonEncodeCount);
        try {
          var uidCount = jsonDecodeCount.keys.toList();
          print(
              'inside try==========================================================');
          var i;
          for (i in uidCount) {
            final response1 = (await FirebaseDatabase.instance
                    .reference()
                    .child('selfAssessmentUser')
                    .child(i)
                    .child('email')
                    .once())
                .value;
            if (response1 == email) {
              print(email);
              print(response1);
              var ref = await FirebaseDatabase.instance
                  .reference()
                  .child('selfAssessmentUser')
                  .child(i)
                  .update({'organization': organization});

              var ref3 = await FirebaseDatabase.instance
                  .reference()
                  .child('selfAssessmentUser')
                  .child(i)
                  .update({'email': email});
              await FirebaseDatabase.instance
                  .reference()
                  .child("admin")
                  .child(i)
                  .set({"organization": organization, "email": email, "result" :"Low Risk"});

              // final DatabaseReference dbref =
              //     FirebaseDatabase.instance.reference();
              // final datasnapshot = (await FirebaseDatabase.instance
              //         .reference()
              //         .child('selfAssessmentUser')
              //         .child(i)
              //         .child('result')
              //         .once())
              //     .value;

              // var ref1 = await FirebaseDatabase.instance
              //     .reference()
              //     .child('organization')
              //     .child(organization)
              //     .child(i)
              //     .update({'status': datasnapshot, 'email': email});
              // break;
            }
          }
        } catch (e) {}
      }

      //  Auth auth = Provider.of(context).auth;
      //           await auth.signOut();
      return true;
    } catch (e) {
      // Auth auth = Provider.of(context).auth;
      //           await auth.signOut();
      return false;
    }
  }

  Future<bool> submit1(email, password, organization) async {
    print(email + ' ' + password);
    try {
      print("Inside submit 11");
      AuthResult user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("Inside submit 12");
      var firebaseUser = await FirebaseAuth.instance.currentUser();
      print('Inside validate');
      var ref = await FirebaseDatabase.instance
          .reference()
          .child('selfAssessmentUser')
          .child(firebaseUser.uid)
          .update({'organization': organization});

      var ref3 = await FirebaseDatabase.instance
          .reference()
          .child('selfAssessmentUser')
          .child(firebaseUser.uid)
          .update({'email': email});

      var ref2 = await FirebaseDatabase.instance
          .reference()
          .child('selfAssessmentUser')
          .child(firebaseUser.uid)
          .update({'result': "Low Risk"});

      var ref1 = await FirebaseDatabase.instance
          .reference()
          .child('organization')
          .child(organization)
          .child(firebaseUser.uid)
          .update({'status': "Low Risk", 'email': email});
      Auth auth = Provider.of(context).auth;
      await auth.signOut();
      return true;
    } catch (e) {
      // AuthResult user = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email, password: password);

      final response = (await FirebaseDatabase.instance
              .reference()
              .child('selfAssessmentUser')
              .once())
          .value;
      var jsonEncodeCount = jsonEncode(response);
      Map jsonDecodeCount = jsonDecode(jsonEncodeCount);
      try {
        var uidCount = jsonDecodeCount.keys.toList();
        print(
            'inside try==========================================================');
        var i;
        for (i in uidCount) {
          final response1 = (await FirebaseDatabase.instance
                  .reference()
                  .child('selfAssessmentUser')
                  .child(i)
                  .child('email')
                  .once())
              .value;
          if (response1 == email) {
            print(email);
            print(response1);
            var ref = await FirebaseDatabase.instance
                .reference()
                .child('selfAssessmentUser')
                .child(i)
                .update({'organization': organization});

            var ref3 = await FirebaseDatabase.instance
                .reference()
                .child('selfAssessmentUser')
                .child(i)
                .update({'email': email});

            final DatabaseReference dbref =
                FirebaseDatabase.instance.reference();
            final datasnapshot = (await FirebaseDatabase.instance
                    .reference()
                    .child('selfAssessmentUser')
                    .child(i)
                    .child('result')
                    .once())
                .value;

            var ref1 = await FirebaseDatabase.instance
                .reference()
                .child('organization')
                .child(organization)
                .child(i)
                .update({'status': datasnapshot, 'email': email});
            break;
          }
        }
      } catch (e) {}

      // Auth auth = Provider.of(context).auth;
      //               await auth.signOut();
    }

    // final DatabaseReference dbref = FirebaseDatabase.instance.reference();
    // final datasnapshot = (await FirebaseDatabase.instance
    //         .reference()
    //         .child('selfAssessmentUser')
    //         .child(firebaseUser.uid)
    //         .child('result')
    //         .once())
    //     .value;
    // if (datasnapshot != null) {
    //   var ref1 = await FirebaseDatabase.instance
    //       .reference()
    //       .child('organization')
    //       .child(organization)
    //       .child(firebaseUser.uid)
    //       .update({'status': datasnapshot, 'email': email});
    // } else {
    //   var ref1 = await FirebaseDatabase.instance
    //       .reference()
    //       .child('organization')
    //       .child(organization)
    //       .child(firebaseUser.uid)
    //       .update({'status': "Low Risk", 'email': email});
    // }

    // Auth auth = Provider.of(context).auth;
    // await auth.signOut();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String emailOfAdmin = prefs.getString('emailOfAdmin') ?? 'idhar hi kuch gadbad hai';
    // String passwordOfAdmin = prefs.getString('passwordOfAdmin' ?? 'ab kya kareeeee');
  }

  void switchFormState(String state) {
    formKey.currentState.reset();

    if (state == 'register') {
      setState(() {
        _formType = FormType.register;
      });
    } else {
      setState(() {
        _formType = FormType.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
      ),
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Login/Register',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontFamily: 'Bebas',
                      ),
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage("images/admin/log.png"),
                          fit: BoxFit.scaleDown,
                        )),
                  ),
                  ...buildInputs(),
                  ...buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        style: TextStyle(
          color: Colors.black,
        ),
        validator: EmailValidator.validate,
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Email',
            labelStyle: TextStyle(color: Colors.black, letterSpacing: 1.3),
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0))),
        onSaved: (value) => email = value,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
          style: TextStyle(
            color: Colors.black,
          ),
          validator: PasswordValidator.validate,
          decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.black, letterSpacing: 1.3),
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0))),
          obscureText: true,
          onSaved: (value) => password = value,
        ),
      ),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: RaisedButton(
            elevation: 3,
            child: Text(
              'Login',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            color: Colors.black,
            onPressed: submit,
          ),
        ),
        SizedBox(width: 50.0),
        RaisedButton(
          elevation: 3,
          child: Text(
            'Register Account',
            style: TextStyle(color: Colors.black),
          ),
          color: Colors.white,
          onPressed: () {
            switchFormState('register');
          },
        ),
        SizedBox(
          height: 50.0,
        ),
      ];
    } else {
      return [
        TextFormField(
          style: TextStyle(
            color: Colors.black,
          ),
          // validator: EmailValidator.validate,
          decoration: InputDecoration(
              labelText: 'Organization Name',
              hintText: 'ABC Company',
              labelStyle: TextStyle(color: Colors.black, letterSpacing: 1.3),
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0))),
          onSaved: (value) => organization = value,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: RaisedButton(
            elevation: 3,
            child:
                Text('Create Account', style: TextStyle(color: Colors.white)),
            color: Colors.black,
            onPressed: submit,
          ),
        ),
        RaisedButton(
          elevation: 3,
          child: Text(
            'Go to Login',
            style: TextStyle(color: Colors.black),
          ),
          color: Colors.white,
          onPressed: () {
            switchFormState('login');
          },
        )
      ];
    }
  }
}
