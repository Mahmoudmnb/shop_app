import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/featurs/main_page/featurs/check_out/screens/add_another_address.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  LocationPermission? permission;
  LatLng? centerLetLong;
  Position? currentLocation;
  LatLng? sourceLocation;

  late GoogleMapController googleMapController;
//!mnb
  Future<void> getUserLocation() async {
    permission = await Geolocator.requestPermission();
    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    centerLetLong =
        LatLng(currentLocation!.latitude, currentLocation!.longitude);
    sourceLocation = centerLetLong!;
    setState(() {});
    log('userCurentLocation $centerLetLong');
  }

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
    getUserLocation();
    setCustomMarkerIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: sourceLocation == null
            ? const CircularProgressIndicator()
            : GoogleMap(
                onMapCreated: (controller) {
                  googleMapController = controller;
                },
                onTap: (argument) {
                  sourceLocation = argument;
                  setState(() {});
                },
                initialCameraPosition:
                    CameraPosition(target: sourceLocation!, zoom: 18.5),
                mapType: MapType.normal,
                markers: {
                  Marker(
                    icon: sourceIcon,
                    markerId: const MarkerId('source'),
                    position: sourceLocation!,
                  ),
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            sourceLocation!.latitude,
            sourceLocation!.longitude,
          );
          log(placemarks.toString());
          Map<String, dynamic> data = {
            'sourceLocation': sourceLocation,
            'placeMark': placemarks[0]
          };
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AddNewAddress(data: data)));
          }
        } catch (err) {
          log(err.toString());
        }
      }),
    );
  }
}
