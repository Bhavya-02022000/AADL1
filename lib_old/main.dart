import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyApp1()),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Baselayout(),
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
                  "Welcome to the\nadmin pannel of\n'CovidProtect'",
                  style: TextStyle(
                      fontFamily: "Bebas",
                      fontSize: 48,
                      color: Colors.blueAccent),
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
    return Image(image: AssetImage('images/admin_splay.png'));
  }
}
