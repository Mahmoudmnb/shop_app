import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  LocationPermission? permission;
  LatLng? centerLetLong;
  Position? currentLocation;
  double? setCurrentLet;
  double? setCurrentLong;
  late GoogleMapController googleMapController;
//!mnb
  Future<LatLng> getUserLocation() async {
    permission = await Geolocator.requestPermission();
    currentLocation = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.high);
    centerLetLong =
        LatLng(currentLocation!.latitude, currentLocation!.longitude);
    setCurrentLet = currentLocation!.latitude;
    setCurrentLong = currentLocation!.longitude;
    log('userCurentLocation $centerLetLong');
    return centerLetLong!;
  }

  LatLng sourceLocation = const LatLng(36.2074, 37.1440);
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/images/location.png",
    ).then((icon) {
      sourceIcon = icon;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // getUserLocation();
    setCustomMarkerIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nurse Location",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Center(
        child: GoogleMap(
          onMapCreated: (controller) {
            googleMapController = controller;
          },
          onTap: (argument) {
            sourceLocation = argument;
            setState(() {});
          },
          initialCameraPosition:
              CameraPosition(target: sourceLocation, zoom: 18.5),
          mapType: MapType.normal,
          markers: {
            Marker(
              icon: sourceIcon,
              markerId: const MarkerId('source'),
              position: sourceLocation,
            ),
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).pop(sourceLocation);
      }),
    );
  }
}
