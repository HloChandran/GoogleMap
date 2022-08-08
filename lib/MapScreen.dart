import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_01_08_2022/polyline.dart';

import 'package:workmanager/workmanager.dart';


class MapScreen extends StatefulWidget {

  MapScreen({

    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with WidgetsBindingObserver  {

  final Completer<GoogleMapController> _controller = Completer();
  var maptype = MapType.terrain;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.9355763, 76.9797108),
    zoom: 14.4746,
  );
  late Position position;
  bool loading = true;
  double latitudecamera = 0.0;

  double longitudecamera = 0.0;
  var cameramove = false;
  List<Placemark> addressText = [];
  late List<Placemark> placemark;
  var LocationController = new TextEditingController();
  late AppLifecycleState _appLifecycleState;
  var  currentLatLng;
  var Name,pasword;

  static var sourcelat;
  static var sourcelang;

  static var Deslat;
  static var Deslang;



  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    loading = true;
    currentposition1();
    super.initState();
  }
  /* @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    print('tesApp');
    setState(() {
      _appLifecycleState = state;
    });
    if(state == AppLifecycleState.paused) {


      Timer.periodic(Duration(seconds: 1), (timer) {
        Geolocator.getCurrentPosition().then((currLocation) {
          setState(() {
            print('testlpaused:${currentLatLng}');

            currentLatLng =
            new LatLng(currLocation.latitude, currLocation.longitude);
            print('testpaused11:${currentLatLng}');
          });
        });
        setState(() {

          print('Timercall${timer}');
          print('testpaused:${currentLatLng}');
            });
          });


      print('AppLifecycleState state: Paused audio playback');
      print('testpaused:${currentLatLng}');

    }
    if(state == AppLifecycleState.resumed) {
      print('AppLifecycleState state: Resumed audio playback');
      print('App');

    }
    print('AppLifecycleState state:  $state');
  }*/
  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height/10,
        child: Row(
          children: [
            Expanded(flex:1, child:Container(
              height:MediaQuery.of(context).size.height/9,
              width:MediaQuery.of(context).size.width/2,
              margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown,
                      Colors.brown,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: FlatButton(
                child: const Text(
                  'Start',
                  style: TextStyle(fontSize: 13.0),
                ),
                textColor: Colors.white,
                onPressed: () async {

                  print('start');
                  Workmanager().registerOneOffTask('task', "backup"
                    ,initialDelay: Duration(seconds: 1),);

                },
              ),
            ),),
            Expanded(flex:1, child:Container(
              height:MediaQuery.of(context).size.height/9,
              width:MediaQuery.of(context).size.width/2,
              margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.brown,
                      Colors.brown,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: FlatButton(
                child: const Text(
                  'Stop',
                  style: TextStyle(fontSize: 13.0),
                ),
                textColor: Colors.white,
                onPressed: () async {

                  position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  setState(() {
                    loading = false;
                  });
                  List<Placemark> placemarks =
                  await placemarkFromCoordinates(position.latitude, position.longitude);
                  print('placemarks${placemarks}');
                  print('${position}');
                  print('la${position.latitude}');
                  print('${position.longitude}');
                  Deslat=position.latitude;
                  Deslang=position.longitude;
                  print('Deslat:${Deslat}');
                  print('Deslang:${Deslang}');





                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Are You Stop Background Services..!'),           // To display the title it is optional
                      content: Text('You Get Diration Map..! '),   // Message which will be pop up on the screen
                      // Action widget which will provide the user to acknowledge the choice
                      actions: [
                        FlatButton(                     // FlatButton widget is used to make a text to work like a button
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },             // function used to perform after pressing the button
                          child: Text('CANCEL'),
                        ),
                        FlatButton(
                          textColor: Colors.black,
                          onPressed: () {
                            print('test${Deslat}');
                            print('${Deslang}');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>polyline(desl:Deslat,deslong:Deslang)));
                          },
                          child: Text('ACCEPT'),
                        ),
                      ],
                    );
                  });
               //   await Workmanager().cancelAll();

                },
              ),
            ),),



          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GoogleMap(
                    mapType: maptype,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraIdle: () async {
                      print("idle");
                      if (cameramove == true) {
                        placemark = await placemarkFromCoordinates(
                            latitudecamera, longitudecamera);

                        cameramove = false;

                        print('$latitudecamera,$longitudecamera');

                        addressText = await placemarkFromCoordinates(
                            latitudecamera, longitudecamera);
                        print('addressText${addressText}');
                        LocationController.text = "";
                        if (addressText[0].name != "") {
                          LocationController.text =
                          "${LocationController.text} ${addressText[0].name}, ";
                        }
                        if (addressText[0].street != "") {
                          LocationController.text =
                          "${LocationController.text} ${addressText[0].street}, ";
                        }
                        if (addressText[0].subLocality != "") {
                          LocationController.text =
                          "${LocationController.text} ${addressText[0].subLocality}, ";
                        }
                        if (addressText[0].locality != "") {
                          LocationController.text =
                          "${LocationController.text} ${addressText[0].locality}, ";
                        }

                        if (addressText[0].subAdministrativeArea != "") {
                          print('pincode');
                          LocationController.text =
                          "${LocationController.text} ${addressText[0].subAdministrativeArea}, ";
                        }
                        if (addressText[0].postalCode != "") {
                          LocationController.text =
                          "${LocationController.text} ${addressText[0].postalCode}";
                        }
                      }
                      Deslat=currentLatLng.latitude;
                      Deslat=currentLatLng.longitude;
                    },
                    onCameraMove: ((value) async {
                      print("moved ");
                      latitudecamera = value.target.latitude;
                      longitudecamera = value.target.longitude;

                      print('movedlatitudecamera${latitudecamera}');
                      print('movedlongitudecamera${longitudecamera}');

                      setState(() {
                        cameramove = true;
                      });
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:58.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FloatingActionButton(
                              child: const Icon(Icons.map),
                              onPressed: (){
                                maptype=MapType.normal;
                                setState(() {

                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FloatingActionButton(
                              child: const Icon(Icons.satellite),
                              onPressed: (){
                                maptype=MapType.hybrid;
                                setState(() {

                                });
                              }),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              child: Icon(
                CupertinoIcons.map_pin_ellipse,
                color: Colors.black,
                size: 35,
              ),
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return Dialog(
                    backgroundColor: Colors.white,
                    child: TextField(
                      enabled: false,
                      readOnly: true,
                      controller: LocationController,
                      minLines: 2,
                      maxLines: 10,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)))),
                    ),
                  );
                });
              },
            ),


          ],
        ),
      ),
    );
  }

  Future<void> currentposition1() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      loading = false;
    });
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print('placemarks${placemarks}');
    print('${position}');
    print('la${position.latitude}');
    print('${position.longitude}');
    sourcelat=position.latitude;
    sourcelang=position.longitude;
    print('sourcelat:${sourcelat}');
    print('sourcelang:${sourcelang}');
  }



}