import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vend_app/pages/settings_page.dart';

// ignore: use_key_in_widget_constructors
class DashboardPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
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

  // void navigateToQrScan() {
  //   // Replace with your actual Business screen widget
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => QrScanPage()));
  // }

  void navigateToSettings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MySettingsPage()));
  }

  void navigateToUserLogin() {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  late final vendingMachineMarkers = <Marker>[
    buildPin(const LatLng(51.51868093513547, -0.12835376940892318)),
    buildPin(const LatLng(53.33360293799854, -6.284001062079881)),
  ];

  Marker buildPin(LatLng point) => Marker(
        point: point,
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tapped existing marker'),
              duration: Duration(seconds: 1),
              showCloseIcon: true,
            ),
          ),
          child: const Icon(Icons.location_pin, size: 60, color: Colors.blue),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              onPressed: () => navigateToUserLogin(),
              icon: const Icon(Icons.filter_list_rounded)),
        ],
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
                onTap: (_, p) =>
                    setState(() => vendingMachineMarkers.add(buildPin(p))),
                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
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
                MarkerLayer(markers: vendingMachineMarkers)
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
            icon: Icon(Icons.map),
            label: 'Dashboard',
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
