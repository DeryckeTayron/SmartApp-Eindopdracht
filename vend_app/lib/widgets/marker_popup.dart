import 'package:flutter/material.dart';
import 'package:vend_app/models/vending_machine.dart';

class VendingMachineMarkerPopup extends StatelessWidget {
  final VendingMachine vendingMachine;

  const VendingMachineMarkerPopup({super.key, required this.vendingMachine});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Text(
            vendingMachine.machineName.toString(),
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Type: ',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                vendingMachine.machineType,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
