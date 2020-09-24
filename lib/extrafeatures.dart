
import 'package:adminApp/camera.dart';
import 'package:adminApp/maps.dart';
import 'package:adminApp/youtube.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// void main(List<String> args) {
//   runApp(FeatureApp());
// }

class FeatureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AADL APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.blueAccent,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20.0,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
      home: ButtonPage(),
    );
  }
}

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AADL PROJECT")),
      body: Padding(
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0, top: 8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Features",
                      style: TextStyle(
                          fontSize: 23.0,
                          fontFamily: 'Cambria',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MapFeature(),
                      Video(),
                      Camera()
                    ],
                  ),
                ],
              ),
            ],
          )

          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     // Text(
          //     //   "Button 1",
          //     // ),
          //     // Text(
          //     //   "Button 2",
          //     // ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         FlatButton(
          //             onPressed: () {
          //               print("Camera");
          //               Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (context) => CameraApp(),
          //               ));
          //               // CameraApp();
          //             },
          //             child: Text('Camera')),
          //         FlatButton(
          //             onPressed: () {
          //               print("Maps");
          //               // MapsDemo();
          //               Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (context) => MapsDemo(),
          //               ));
          //             },
          //             child: Text('Maps')),
          //         FlatButton(
          //             onPressed: () {
          //               print("Video");
          //               Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (context) => YoutubePlayerDemoApp(),
          //               ));
          //               // CameraApp();
          //             },
          //             child: Text('Video')),
          //       ],
          //     )
          //   ],
          // ),
          ),
    );
  }
}

class MapFeature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 2.0, left: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.25,
        child: RaisedButton(
          onPressed: () {
            print("Maps");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MapsDemo(),
            ));
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(
                  alignment: Alignment.center,
                  image: AssetImage('images/heatmap.png'),
                ),
                AutoSizeText(
                  "Map",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ]),
          elevation: 3.0,
          color: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class Video extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 2.0, left: 190),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.25,
        child: RaisedButton(
          onPressed: () {
            print("Video");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => YoutubePlayerDemoApp(),
            ));
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(
                  alignment: Alignment.center,
                  image: AssetImage('images/video.png'),
                ),
                AutoSizeText(
                  "Video",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ]),
          elevation: 3.0,
          color: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 2.0, left: 5),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.25,
        child: RaisedButton(
          onPressed: () {
            print("Camera");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CameraApp(),
            ));
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(
                  alignment: Alignment.center,
                  image: AssetImage('images/camera.PNG'),
                ),
                AutoSizeText(
                  "Camera",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ]),
          elevation: 3.0,
          color: Colors.lightBlue[50],
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}