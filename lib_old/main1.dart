import 'package:adminApp/auth.dart';
import 'package:adminApp/data_store.dart';
import 'package:adminApp/provider.dart';
import 'package:adminApp/sheet.dart';
import 'package:adminApp/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyApp1 extends StatefulWidget {
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
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

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (_formType == FormType.login) {
          String userId = await auth.signInWithEmailAndPassword(
            email,
            password,
          );
          print("Idhar hi naatak chalu hai iska");
          DataStore.storedEmailOfAdmin = email;
          DataStore.storedPasswordOfAdmin = password;
          print('Signed in $userId');
        } else {
          String userId = await auth.createUserWithEmailAndPassword(
            email,
            password,
          );
          DataStore.storedEmailOfAdmin = email;
          DataStore.storedPasswordOfAdmin = password;
          // print(emailOfAdmin);
          // print(passwordOfAdmin);
          print('Registered in $userId');

          var firebaseUser = await FirebaseAuth.instance.currentUser();

          DataStore.uid = firebaseUser.uid;

          await FirebaseDatabase.instance
              .reference()
              .child("users")
              .child(firebaseUser.uid)
              .child('organization')
              .set({
            'organization': organization,
          });
          await FirebaseDatabase.instance
              .reference()
              .child("admin")
              .child(firebaseUser.uid)
              .set({"organization": organization});
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> addAdmin(email, password, organization) async {
    try {
      print("New Admin " + email + " " + password);
      try {
        AuthResult user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } catch (e) {
        AuthResult user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // .createUserWithEmailAndPassword(email: email, password: password);
      }
      var firebaseUser = await FirebaseAuth.instance.currentUser();
      await FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(firebaseUser.uid)
          .child('organization')
          .set({
        'organization': organization,
      });
      await FirebaseDatabase.instance
          .reference()
          .child("admin")
          .child(firebaseUser.uid)
          .set({"organization": organization});
      return true;
    } catch (e) {
      return false;
    }
  }

  submit1(email, password, organization) async {
    print(email + ' ' + password);
    try {
      AuthResult user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      AuthResult user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // .createUserWithEmailAndPassword(email: email, password: password);
    }
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    print('Inside validate');
    var ref = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(firebaseUser.uid)
        .child('organization')
        .set({'organization': organization});
    var ref2 = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(firebaseUser.uid)
        .child('status')
        .set({'status': "Safe"});
    var ref3 = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(firebaseUser.uid)
        .child('email')
        .set({'email': email});
    var ref1 = await FirebaseDatabase.instance
        .reference()
        .child('organization')
        .child(organization)
        .child(firebaseUser.uid)
        .update({'status': 'Safe', 'email': email});
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
        title: Text(
          'Login/Register',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 35.0,
            fontFamily: 'Bebas',
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
            elevation: 10,
            child: Text(
              'Login',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            color: Colors.blueAccent,
            onPressed: submit,
          ),
        ),
        SizedBox(width: 50.0),
        RaisedButton(
          elevation: 10,
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
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: RaisedButton(
            elevation: 10,
            child:
                Text('Create Account', style: TextStyle(color: Colors.white)),
            color: Colors.blueAccent,
            onPressed: submit,
          ),
        ),
        RaisedButton(
          elevation: 10,
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
