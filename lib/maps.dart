import 'package:adminApp/extrafeatures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() => runApp(MyApp());

class MapsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Marker> allMarkers = [];

  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(19.0482, 72.9117)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => FeatureApp(),
                ),
              ),
            ),
        // actions: [
        //     IconButton(
        //       icon: const Icon(Icons.arrow_back),
        //       onPressed: () => Navigator.push(
        //         context,
        //         CupertinoPageRoute(
        //           builder: (context) => MyApp(),
        //         ),
        //       ),
        //     ),
        //   ],
        title: Text('Maps'),
      ),
      body: Stack(
        children: [Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(19.0482, 72.9117), zoom: 12.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: InkWell(
        //     onTap: movetoBoston,
        //     child: Container(
        //       height: 40.0,
        //       width: 40.0,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20.0),
        //         color: Colors.green
        //       ),
        //       child: Icon(Icons.forward, color: Colors.white),
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: InkWell(
        //     onTap: movetoNewYork,
        //     child: Container(
        //       height: 40.0,
        //       width: 40.0,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20.0),
        //         color: Colors.red
        //       ),
        //       child: Icon(Icons.backspace, color: Colors.white),
        //     ),
        //   ),
        // )
        ]
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(19.0482, 72.9117), zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(19.0482, 72.9117), zoom: 12.0),
    ));
  }
}