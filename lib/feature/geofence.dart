import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoFenceScreen extends StatefulWidget {
  @override
  _GeoFenceScreenState createState() => _GeoFenceScreenState();
}

class _GeoFenceScreenState extends State<GeoFenceScreen> {
  final double geofenceLatitude =
      19.0708066; // Replace with your geofence center latitude
  final double geofenceLongitude =
      72.8760758; // Replace with your geofence center longitude
  final double geofenceRadius = 1500.0; // Radius in meters

  bool isWithinGeofence = false; // Track if inside geofence
  String geofenceStatus = "Outside Geofence";

  @override
  void initState() {
    super.initState();
    _startGeofencing();
  }

  void _startGeofencing() {
    Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 100,
    )).listen((Position position) {
      _checkGeofence(position);
    });
  }

  void _checkGeofence(Position position) {
    double distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      geofenceLatitude,
      geofenceLongitude,
    );
    print("geofenceRadius");
    print(distanceInMeters);
    print(geofenceRadius);
    bool isInside = distanceInMeters <= geofenceRadius;

    // Update state only if status changes
    if (isInside != isWithinGeofence) {
      setState(() {
        print("isInside-value");
        print(isInside);
        print(isWithinGeofence);
        isWithinGeofence = isInside;
        geofenceStatus = isInside ? "Inside Geofence" : "Outside Geofence";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Geofence Example")),
      body: Center(
        child: Text(
          geofenceStatus,
          style: TextStyle(
            fontSize: 24,
            color: isWithinGeofence ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
