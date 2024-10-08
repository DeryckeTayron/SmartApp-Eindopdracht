import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vend_app/models/vending_machine.dart';

class VendingMachineInfoPage extends StatefulWidget {
  final String scanResult;

  const VendingMachineInfoPage({super.key, required this.scanResult});

  @override
  State<VendingMachineInfoPage> createState() => _VendingMachineInfoPageState();
}

class _VendingMachineInfoPageState extends State<VendingMachineInfoPage> {
  CollectionReference vendingMachinesCollection =
      FirebaseFirestore.instance.collection('vendingMachines');

  Future<VendingMachine> fetchVendingMachines() async {
    return vendingMachinesCollection.doc(widget.scanResult).get().then(
      (snapshot) {
        final data = snapshot.data();
        if (data != null) {
          final latitude = snapshot.get('latitude') as double;
          final longitude = snapshot.get('longitude') as double;
          final userId = snapshot.get('userId') as String;
          final machineType = snapshot.get('machineType') as String;
          final machineName = snapshot.get('machineName') as String;
          final accountName = snapshot.get('accountName') as String;
          final id = snapshot.id;
          return VendingMachine(userId, latitude, longitude, machineType,
              machineName, accountName, id);
        } else {
          throw Exception(
              'No vending machine found with ID: ${widget.scanResult}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vending Machine Info'),
      ),
      body: Center(
        child: FutureBuilder<VendingMachine>(
          future: fetchVendingMachines(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final vendingMachine = snapshot.data!;
              return Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center content vertically
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      // Use Center widget for both horizontal & vertical centering
                      child: Text(
                        vendingMachine.machineName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign
                            .center, // OR use textAlign for horizontal centering only
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Add space after machine name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      // Use Center widget for both horizontal & vertical centering
                      child: Text(
                        "Inside of this vending machine, you can find ${vendingMachine.machineType}",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign
                            .center, // OR use textAlign for horizontal centering only
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      height: 150, // Adjust height as needed
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(vendingMachine.latitude,
                              vendingMachine.longitude),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              // Check if vendingMachine has location data
                              Marker(
                                point: LatLng(vendingMachine.latitude,
                                    vendingMachine.longitude),
                                child: const Icon(Icons.location_pin),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'You did not scan a valid QR-code. Please try again.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
