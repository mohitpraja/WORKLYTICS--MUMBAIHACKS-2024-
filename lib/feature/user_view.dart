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
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worklytics/core/colors.dart';
import 'package:worklytics/core/globals.dart';

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
    remarkController.clear();

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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(
              "Worklytics",
              style: TextStyle(color: white),
            ),
            actions: <Widget>[
              GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                  },
                  child: Center(
                    child: Icon(
                      CupertinoIcons.power,
                      color: white,
                    ),
                  )),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Stack(children: const [
                      CircleAvatar(
                        radius: 35,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      )
                    ]),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // primary: appColorTimeINMaster,
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          _getCurrentLocation();
                          setState(() {
                            clickMeLoad = true;
                          });
                        },
                        child: clickMeLoad == false
                            ? const Text(
                                "Click Me",
                                style: TextStyle(color: Colors.white),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                color: white,
                              ))),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  width: 350,
                  height: 120,
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
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Text(
                              'You are at: '.toUpperCase() +
                                  _currentAddress.toUpperCase(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              )),
                      // Text('Fake Location: $_isMockLocation'),
                      // Text(' $_latitude , $_longitude'),
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
        ));
  }

  Future getImage() async {
    XFile? image34;
    image34 = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);
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
        log('get _getAddressFromLatLng');

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

  Future remarkPop(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select an option'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      title: const Text('Day'),
                      value: 'Day',
                      groupValue: deliveryOption,
                      onChanged: (value) {
                        setState(() {
                          deliveryOption = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('Night'),
                      value: 'Night',
                      groupValue: deliveryOption,
                      onChanged: (value) {
                        setState(() {
                          deliveryOption = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('Extra'),
                      value: 'Extra',
                      groupValue: deliveryOption,
                      onChanged: (value) {
                        setState(() {
                          deliveryOption = value.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: remarkController,
                      decoration: const InputDecoration(
                        hintText: 'Enter text here',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () async {
                    // Handle submit action here
                    setState(() {
                      clickMeLoad = false;
                    });

                    Navigator.of(context).pop();
                    // await getImage();
                  },
                ),
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    // Handle submit action here
                    Navigator.of(context).pop();
                    await getImage();
                  },
                ),
              ],
            );
          },
        );
      },
    );
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