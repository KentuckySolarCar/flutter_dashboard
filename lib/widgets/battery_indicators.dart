import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/battery.dart';

//TODO fix typecasting thing that is an issue wtih pack voltage in particular
//TODO fix the weird box size and stuff
class BatteryDisplay extends StatelessWidget {
  const BatteryDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Battery Pack',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBatteryInfo(context, 'State of Charge %', (battery) => battery.stateOfCharge.toStringAsFixed(2)),
              _buildBatteryInfo(context, 'Pack Voltage', (battery) => battery.packVoltage),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBatteryInfo(context, 'Total Current', (battery) => battery.packCurrent.toStringAsFixed(2)),
              _buildBatteryInfo(context, 'Motor Current', (battery) => battery.controllerCurrent.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryInfo(BuildContext context, String label, String Function(Battery) getValue) {
  Battery battery = Provider.of<Battery>(context);
  String value = getValue(battery);

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.white),
    ),
    height: 60,
    width: 135,
    padding: EdgeInsets.all(2),
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8), // Semi-transparent white text
          ),
        ),
        SizedBox(height: 5),
        Text(
          double.tryParse(value)?.toStringAsFixed(2) ?? 'N/A', // Ensure value has 2 decimal points
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

}
