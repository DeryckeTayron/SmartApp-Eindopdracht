import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      // Use Center widget for both horizontal & vertical centering
                      child: Text(
                        "This vending machine is called ${vendingMachine.machineName}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign
                            .center, // OR use textAlign for horizontal centering only
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Add space after machine name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                ],
              );
            } else if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(24.0),
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
