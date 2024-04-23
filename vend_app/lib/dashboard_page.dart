import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vend_app/settings.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _latitude = 0.0;
  double _longitude = 0.0;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, please enable location in your settings.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void navigateToHome() {
    // Replace with your actual Home screen widget
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }

  // void navigateToQrScan() {
  //   // Replace with your actual Business screen widget
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => QrScanPage()));
  // }

  void navigateToSettings() {
    // Replace with your actual Settings screen widget
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MySettingsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: FutureBuilder<Position>(
        future: getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Update variables with retrieved data to use for my location on map
            _latitude = snapshot.data!.latitude;
            _longitude = snapshot.data!.longitude;

            return FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                //use my variables to center the map on my location
                initialCenter: LatLng(_latitude, _longitude),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      //use my variables to put a marker on myself
                      point: LatLng(_latitude, _longitude),
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.red,
                        size: 30,
                      ),
                      rotate: true,
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error getting location: ${snapshot.error}'));
          }

          // Show a loading indicator while waiting for location data
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR-Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.blue,
        onTap: (index) {
          switch (index) {
            case 0:
              navigateToHome();
              break;
            case 1:
              // navigateToQrScan();
              break;
            case 2:
              navigateToSettings();
              break;
          }
        },
      ),
    );
  }
}
