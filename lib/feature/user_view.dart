// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worklytics/core/colors.dart';
import 'package:worklytics/core/fonts.dart';
import 'package:worklytics/core/globals.dart';
import 'package:worklytics/core/regula.dart';
import 'package:worklytics/feature/admin_view.dart';

import 'login.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final picker = ImagePicker();

  final TextEditingController remarkController = TextEditingController();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  final loc.Location locationPoint = loc.Location();

  String _currentAddress = '';
  late String img64;
  bool showError = true;
  bool clickMeLoad = false;
  bool locLoad = false;

  late StreamSubscription<Position> positionStreamSubscription;

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  void ac() {
    locLoad = false;
  }

  void initPlatformState() async {
    requestLocationPermission();
    setState(() {
      clickMeLoad = false;
    });
    await _getCurrentLocation();
  }

  /// request location permission at runtime.
  void requestLocationPermission() async {
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => Get.to(() => const AdminView()),
          child: Text(
            "Worklytics",
            style: TextStyle(color: white),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));

                SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.clear();
              },
              icon: Icon(
                CupertinoIcons.power,
                color: white,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.person,
                size: 45,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(
                onPressed: () async {
                  setState(() {
                    clickMeLoad = true;
                  });
                  _getCurrentLocation();
                  await openCamera().then(
                    (value) {
                      setState(() {
                        clickMeLoad = false;
                      });
                    },
                  );
                },
                color: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: clickMeLoad == false
                    ? const Text(
                        "Click Me",
                        style: TextStyle(color: Colors.white),
                      )
                    : SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: white,
                        ),
                      )),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black12,
                  )),
              child: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  locLoad
                      ? const CircularProgressIndicator()
                      : Text(
                          'You are at: '.toUpperCase() +
                              _currentAddress.toUpperCase(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.5,
                            fontFamily: FF.alata,
                            color: Colors.black54,
                          )),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        locLoad = true;
                      });
                      _getCurrentLocation();
                    },
                    label: const Text(
                      'Refresh Location',
                    ),
                    icon: const Icon(Icons.refresh_rounded,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(
          Icons.add_task,
          color: primaryColor,
        ),
      ),
    );
  }

  Future openCamera() async {
    File? image34;
    image34 = await RegulaFaceRecognition.openCamera();
    FirebaseStorage fs = FirebaseStorage.instance;
    Reference rootReference = fs.ref();
    Reference pictureFolderRef = rootReference
        .child("pictures")
        .child(formattedDate)
        .child(DateTime.now().toString());
    // Reference pictureFolderRef = rootReference.child("pictures").child("image");
    pictureFolderRef
        .putFile(File(image34!.path))
        .whenComplete(() {})
        .then((storageTask) async {
      // String showTime = DateFormat.jms().format(now);
      String link = await storageTask.ref.getDownloadURL();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    'Attendance Mark Successfully!!',
                    style: TextStyle(color: Colors.white),
                  )));
      // await ShowList.add({
      //   'email': userEmail,
      //   'name': nameLogin,
      //   'Date': formattedDate,
      //   'Time': showTime,
      //   'phone': phone,
      //   'address': area,
      //   'delivery': deliveryOption,
      //   'remark': remarkController.text,
      //   'DateInSec': DateTime.now().toLocal().microsecondsSinceEpoch,
      //   'web': false,
      //   // 'image': img64,
      //   'imageLink': link,
      // }).then((value) => {
      //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: const Text(
      //           'Attendance Mark Successfully!!',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         action: SnackBarAction(
      //           label: 'Check Now !',
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => AttendanceList()),
      //             );
      //           },
      //         ),
      //       )),
      //     });
      // setState(() {
      //   clickMeLoad = false;
      // });
    });
    // todo --- You have to hit your Api Over Here
  }

  Future<bool> checkPermissionOfLocation() async {
    loc.Location location = loc.Location();
    bool sts = false;

    final status = await Permission.locationWhenInUse.status;

    if (status == PermissionStatus.granted) {
      if (await location.requestService()) {
        sts = true;
      }
    } else if (status == PermissionStatus.denied) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text(
                    "You have to give location permission from setting"),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      openAppSettings();
                    },
                  )
                ],
              ));

      sts = false;
    }
    return sts;
  }

  Future<void> _getCurrentLocation() async {
    if (kIsWeb) {
      getWebLocation();
    } else {
      LocationSettings locationSettings;

      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 40),
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.fitness,
          distanceFilter: 100,
          pauseLocationUpdatesAutomatically: true,
          showBackgroundLocationIndicator: false,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 10,
        );
      }

      // If the listener is already active, do not start a new one
      if (_locationSubscription == null) {
        await locationPoint.getLocation();

        _locationSubscription = locationPoint.onLocationChanged.listen(
          (loc.LocationData currentLocation) {
            log('get _getCurrentLocation');
            final latitude = currentLocation.latitude;
            final longitude = currentLocation.longitude;

            if (latitude != null && longitude != null) {
              _getAddressFromLatLng(latitude, longitude);
            }
          },
        );
      }
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    if (kIsWeb) {
      getWebLocation();
    } else {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];
        _currentAddress =
            "${place.thoroughfare} ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";

        // Updating the UI or internal state
        setState(() {
          area = _currentAddress;
          locLoad = false;
        });
      } catch (e) {
        setState(() {
          locLoad = false;
        });
        log("Error fetching location: $e");
      }
    }
  }

  // Method to stop the location updates
  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future noInternetPop() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("You Are Not Connected To Internet"),
              content: const Text("Check Connection Setting"),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // onSurface: appColorTimeINMaster,
                      // onPrimary: appColorTimeINMaster,
                      // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      clickMeLoad = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close me!',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ));
  }

  getWebLocation() {
    const geo.LocationSettings locationS =
        geo.LocationSettings(distanceFilter: 50);
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationS)
            .listen((Position? position) {
      _currentAddress = '${position!.latitude},${position.longitude}';
    });
    setState(() {
      area = _currentAddress;
      locLoad = false;
    });
  }
}
