import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vend_app/models/vending_machine.dart';

class VendingMachineMarkerPopup extends StatelessWidget {
  final VendingMachine vendingMachine;
  final Function onDelete;

  VendingMachineMarkerPopup(
      {super.key, required this.vendingMachine, required this.onDelete});

  final CollectionReference vendingMachinesCollection =
      FirebaseFirestore.instance.collection('vendingMachines');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              vendingMachine.machineName.toString(),
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vendingMachine.machineType,
                style: const TextStyle(fontSize: 16.0),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20.0),
                onPressed: () {
                  onDelete(vendingMachine);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
