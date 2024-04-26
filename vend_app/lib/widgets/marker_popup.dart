import 'package:flutter/material.dart';
import 'package:vend_app/models/vending_machine.dart';

class VendingMachineMarkerPopup extends StatelessWidget {
  const VendingMachineMarkerPopup({super.key, required this.vendingMachine});
  final VendingMachine vendingMachine;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(vendingMachine.longitude.toString()),
          ],
        ),
      ),
    );
  }
}
