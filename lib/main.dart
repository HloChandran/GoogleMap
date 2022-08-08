import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

import 'CreateAccount.dart';
import 'DataBase.dart';
import 'Dbhelp.dart';
import 'Login.dart';

var currentLatLng;
List<Map<String, dynamic>> _journals = [];

void _refreshJournals() async {
  final data = await SQLHelper.getItems();
  _journals = data;

}

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
      callbackDispatcher,

      isInDebugMode: true
  );
  // Periodic task registration
  Workmanager().registerPeriodicTask(
      "2",
      "simplePeriodicTask",
      frequency: Duration(minutes: 15), );


  runApp(
      const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    currentLatLng = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
    await placemarkFromCoordinates(currentLatLng.latitude, currentLatLng.longitude);
    print('placemarks${placemarks}');
    print('${currentLatLng}');
    print('la${currentLatLng.latitude}');
    print('${currentLatLng.longitude}');
    await _addItem(currentLatLng);

    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip,currentLatLng);
    return Future.value(true);
  });
}
Future _showNotificationWithDefaultSound(flip,currentLatLng) async {

  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );
  await flip.show(0, '${currentLatLng}',
      'Your are one step away to connect with ${currentLatLng}',
      platformChannelSpecifics, payload: 'Default_Sound'
  );

}
Future<void> _addItem(currentLatLng) async {
  double lat=currentLatLng.latitude;
  double lang=currentLatLng.longitude;
  await SQLHelper.locationitem(
      lat.toString(),lang.toString(),'${lat.toString()},${lang.toString()}');


}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }


}

