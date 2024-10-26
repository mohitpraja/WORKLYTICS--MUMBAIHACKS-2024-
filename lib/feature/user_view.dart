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
import 'package:worklytics/core/fonts.dart';
import 'package:worklytics/core/globals.dart';

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

  final double geofenceLatitude =
      19.0708066; // Replace with your geofence center latitude
  final double geofenceLongitude =
      72.8760758; // Replace with your geofence center longitude
  final double geofenceRadius = 5.0; //
  bool isWithinGeofence = false; // Track if inside geofence
  String geofenceStatus = "Outside Geofence";

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
                      _getCurrentLocation();
                      setState(() {
                        clickMeLoad = true;
                      });
                    },
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: clickMeLoad == false
                        ? const Text(
                            "Click Me",
                            style: TextStyle(color: Colors.white),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                            color: white,
                          ))),
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

                Text(
                  geofenceStatus,
                  style: TextStyle(
                    fontSize: 24,
                    color: isWithinGeofence ? Colors.green : Colors.red,
                  ),
                ),

                // ignore: avoid_unnecessary_containers
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black12,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_outsideDuration.inMinutes} minutes',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${_insideDuration.inMinutes} minutes',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                        ),
                      ),
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

  DateTime? _enterTime; // Time when entering geofence
  DateTime? _exitTime; // Time when exiting geofence
  Duration _insideDuration = Duration.zero; // Accumulated inside time
  Duration _outsideDuration = Duration.zero; // Accumulated outside time

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
          distanceFilter: 10,
          pauseLocationUpdatesAutomatically: true,
          showBackgroundLocationIndicator: false,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 10,
        );
      }

      // Check if listener is active
      if (_locationSubscription == null) {
        await locationPoint.getLocation();

        _locationSubscription = locationPoint.onLocationChanged
            .listen((loc.LocationData currentLocation) {
          log('get _getCurrentLocation');
          final latitude = currentLocation.latitude;
          final longitude = currentLocation.longitude;

          if (latitude != null && longitude != null) {
            double distanceInMeters = Geolocator.distanceBetween(
              latitude,
              longitude,
              geofenceLatitude,
              geofenceLongitude,
            );

            bool isInside = distanceInMeters <= geofenceRadius;

            // Update timings only if geofence status changes
            if (isInside != isWithinGeofence) {
              setState(() {
                isWithinGeofence = isInside;
                geofenceStatus =
                    isInside ? "Inside Geofence" : "Outside Geofence";

                if (isInside) {
                  // Entered geofence: record entry time and calculate outside duration
                  _enterTime = DateTime.now();
                  if (_exitTime != null) {
                    _outsideDuration += _enterTime!.difference(_exitTime!);
                    _exitTime = null;
                  }
                } else {
                  // Exited geofence: record exit time and calculate inside duration
                  _exitTime = DateTime.now();
                  if (_enterTime != null) {
                    _insideDuration += _exitTime!.difference(_enterTime!);
                    _enterTime = null;
                  }
                }

                print("Time Inside Geofence: ${distanceInMeters} meeter");
                print("Time Inside Geofence: ${geofenceRadius} radius");
                print(
                    "Time Inside Geofence: ${_insideDuration.inMinutes} minutes");
                print(
                    "Time Outside Geofence: ${_outsideDuration.inMinutes} minutes");
              });
            }

            // Optionally fetch the address
            _getAddressFromLatLng(latitude, longitude);
          }
        });
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
