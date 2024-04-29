// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vend_app/auth.dart';
import 'package:vend_app/models/vending_machine.dart';
import 'package:vend_app/pages/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:vend_app/theme/theme.dart';
import 'package:vend_app/theme/theme_provider.dart';
import 'package:vend_app/widgets/marker_popup.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

// enables verification for forminput
final _formKey = GlobalKey<FormState>();

// holds machinetypes for dropdown
enum MachineTypes {
  beverages('Beverages'),
  bread('Bread'),
  snacks('Snacks'),
  extra('Extra');

  const MachineTypes(this.label);
  final String label;
}

// an extention on markers for vending machines
class VendingMachineMarker extends Marker {
  VendingMachineMarker({required this.vendingMachine})
      : super(
          point: LatLng(vendingMachine.latitude, vendingMachine.longitude),
          width: 40,
          height: 40,
          child: const Icon(Icons.location_pin, size: 60, color: vendAppBlue),
        );

  final VendingMachine vendingMachine;
}

class _DashboardPageState extends State<DashboardPage> {
  double _latitude = 0.0;
  double _longitude = 0.0;

  final User currentUser = Auth().currentUser!;

// gets vendingmachines from database
  CollectionReference vendingMachinesCollection =
      FirebaseFirestore.instance.collection('vendingMachines');

// stores the vendingmachinedata
  late var vendingMachines = <VendingMachine>[];

// enables closing popups when deleting vendingmachines
  final PopupController _popupLayerController = PopupController();

// enables building the vendingmachinemarkers on the map
  late var vendingMachineMarkers = vendingMachines
      .map(
        (vendingMachine) => buildPin(
          LatLng(vendingMachine.latitude, vendingMachine.longitude),
        ),
      )
      .toList();

// fetches the vendingmachines from database to display on map
  Future<void> fetchVendingMachines() async {
    vendingMachinesCollection.get().then(
      (querySnapshot) {
        for (var snapshot in querySnapshot.docs) {
          final data = snapshot.data();
          if (data != null) {
            final latitude = snapshot.get('latitude') as double;
            final longitude = snapshot.get('longitude') as double;
            final userId = snapshot.get('userId') as String;
            final machineType = snapshot.get('machineType') as String;
            final machineName = snapshot.get('machineName') as String;
            final id = snapshot.id;
            vendingMachines.add(VendingMachine(
                userId, latitude, longitude, machineType, machineName, id));
          } else {
            print(
                'Error: Missing data in vending machine document ${snapshot.id}');
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

// asks for and gets current location so map can find you
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MySettingsPage()));
  }



// enables a dark mode map
  Widget _darkModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(
        <double>[
          -0.2126,
          -0.7152,
          -0.0722,
          0,
          255,
          -0.2126,
          -0.7152,
          -0.0722,
          0,
          255,
          -0.2126,
          -0.7152,
          -0.0722,
          0,
          255,
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      child: tileWidget,
    );
  }

// enables deletion of vending machines
  void deleteVendingMachine(VendingMachine vendingMachine) => {
        vendingMachinesCollection.doc(vendingMachine.id).delete().then(
              (doc) => print("Document deleted"),
              onError: (e) => print("Error updating document $e"),
            ),
        setState(() => vendingMachines.removeWhere((currentVendingMachine) =>
            currentVendingMachine.id == vendingMachine.id)),
        _popupLayerController.hideAllPopups()
      };

// enables adding a vending machine with its properties to the database
  Future<String> addVendingMachine(LatLng point, machineName, machineType) {
    return vendingMachinesCollection
        .add({
          'userId': currentUser.uid,
          'longitude': point.longitude,
          'latitude': point.latitude,
          'machineName': machineName,
          'machineType': machineType
        })
        .then((value) => value.id)
        .catchError((error) => "Failed to add vending machine");
  }

// function to build pin on map
  Marker buildPin(LatLng point) => Marker(
        point: point,
        width: 60,
        height: 60,
        child: const Icon(Icons.location_pin, size: 60, color: vendAppBlue),
      );

// enables sending machinetype to database, it gets machinetype from the dropdown
  MachineTypes getMachineTypeFromString(String typeString) {
    for (final machineType in MachineTypes.values) {
      if (machineType.label == typeString) {
        return machineType;
      }
    }
    throw Exception('Invalid machine type string: $typeString');
  }

// displays a form which lets you input data to send to firestore database
  void _showVendingMachineDialog(LatLng point) {
    final nameController = TextEditingController();
    String selectedMachineType = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Vending Machine'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10), // Add some spacing between fields
                DropdownButtonFormField<MachineTypes>(
                  // Set initial value (optional)
                  value: selectedMachineType.isEmpty
                      ? null
                      : getMachineTypeFromString(selectedMachineType),
                  onChanged: (MachineTypes? value) {
                    if (value != null) {
                      selectedMachineType = value.label; // Update on change
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Machine Type',
                  ),
                  items: MachineTypes.values
                      .map<DropdownMenuItem<MachineTypes>>((MachineTypes type) {
                    return DropdownMenuItem<MachineTypes>(
                      value: type,
                      child: Text(type.label),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose a vending machine type';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.pop(context),
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Add vending machine logic here with form data
              final name = nameController.text;
              final machineType = selectedMachineType;

              // Call addVendingMachine with data from form
              if (_formKey.currentState!.validate()) {
                var id = await addVendingMachine(point, name, machineType);
                setState(() => vendingMachines.add(VendingMachine(
                    currentUser.uid,
                    point.latitude,
                    point.longitude,
                    machineType,
                    name,
                    id)));
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchVendingMachines();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
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
                onLongPress: (_, p) => {
                  _showVendingMachineDialog(
                    p,
                  ),
                },

                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                TileLayer(
                  tileBuilder:
                      themeProvider.isDarkMode ? _darkModeTileBuilder : null,
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
                MarkerLayer(
                  markers: vendingMachineMarkers,
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers: vendingMachines
                        .map((vendingMachine) => VendingMachineMarker(
                            vendingMachine: vendingMachine))
                        .toList(),
                    popupController: _popupLayerController,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, Marker marker) {
                        if (marker is VendingMachineMarker) {
                          return VendingMachineMarkerPopup(
                            vendingMachine: marker.vendingMachine,
                            onDelete: deleteVendingMachine,
                          );
                        }
                        return const Card(child: Text('Not a vending machine'));
                      },
                    ),
                  ),
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
        backgroundColor: Theme.of(context).colorScheme.background,
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
        selectedItemColor: vendAppBlue,
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
