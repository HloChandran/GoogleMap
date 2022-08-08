import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_01_08_2022/MapScreen.dart';

class polyline extends StatefulWidget {
  polyline({Key? key, required this.desl, required this.deslong}) : super(key: key);
  double desl;
  double deslong;
  @override
  State<polyline> createState() => _polylineState();
}

class _polylineState extends State<polyline> {

  late var sourcelat;
  late var sourcelang;

  late Position position;

  late GoogleMapController mapController;

  double _originLatitude = 10.936842, _originLongitude =76.9777738;
  double _destLatitude = 10.9199161, _destLongitude = 76.982964;

//  late double _originLatitude,_originLongitude,_destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBvR07aFM-1ddGVgt392lRnUge3weT6nUY";
  @override
  void initState() {
    currentposition1();
    /*_originLatitude=MapScreenState.sourcelat;
    _originLongitude=MapScreenState.sourcelang;
    _destLatitude=MapScreenState.Deslat;
    _destLongitude=MapScreenState.Deslang;*/
    // print('_originLatitude${_originLatitude}');
    // print('_originLongitude${_originLongitude}');
     print('desl${widget.desl}');
    print('deslong${widget.deslong}');

    print('initsate');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Line'),),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.desl,widget.deslong), zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          )),
    );
  }
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;


  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color:Colors.black,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }
  _getPolyline() async {

    print('_getPolyline' );

    print(widget.desl );
    print(widget.deslong );
    // print(_originLatitude, );
    // // print(_originLongitude, );
    // print(_destLatitude, );
    // print(_destLongitude, );
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
     /*   PointLatLng(widget.sol,widget.solang),
       PointLatLng(widget.desl,widget.deslong),*/
        PointLatLng(sourcelat,sourcelang),
        PointLatLng(widget.desl,widget.deslong),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "")]);
    if (result.points.isNotEmpty) {
      print('if', );

      result.points.forEach((PointLatLng point) {
        print(point.latitude);
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState((){});
    }else{
      print('else', );

    }
    _addPolyLine(polylineCoordinates);
    setState((){});


  }

  Future<void> currentposition1() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print('polyplacemarks${placemarks}');
    print('${position}');
    print('la${position.latitude}');
    print('${position.longitude}');
    sourcelat=position.latitude;
    sourcelang=position.longitude;
    print('sourcelat:${sourcelat}');
    print('sourcelang:${sourcelang}');

    _addMarker(LatLng(sourcelat,sourcelang), "origin",
        BitmapDescriptor.defaultMarker);
    _addMarker(LatLng(widget.desl,widget.deslong), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }


}
