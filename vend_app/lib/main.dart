import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: StartupScreen());
  }
}

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Add a delay of 3 seconds (3000 milliseconds)
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the dashboard page after the delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Change the background color if needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/vendapp_logo.svg',
              semanticsLabel: 'Vendapp Logo',
            ),
            const SizedBox(
                height: 20), // Add some space between the icon and the text
            const Text(
              'Vendapp',
              style: TextStyle(
                fontSize: 24, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  LatLng _initialLocation =
      const LatLng(51.509364, -0.128928); // Default initial location (London)

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  void getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _initialLocation,
          zoom: 13.0,
        ),
        children: [],
      ),
    );
  }
}
