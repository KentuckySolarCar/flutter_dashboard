import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/battery.dart';

class BatteryDisplay extends StatelessWidget {
  const BatteryDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
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
              _buildBatteryInfo(context, 'State of Charge', (battery) => battery.stateOfCharge),
              _buildBatteryInfo(context, 'Aux Pack Voltage', (battery) => battery.stateOfCharge),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBatteryInfo(context, 'Total Current', (battery) => battery.stateOfCharge),
              _buildBatteryInfo(context, 'Motor Current', (battery) => battery.stateOfCharge),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryInfo(BuildContext context, String label, double Function(Battery) getValue) {
    Battery battery = Provider.of<Battery>(context);
    double value = getValue(battery);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.all(10),
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
            value.toStringAsFixed(2),
            style: TextStyle(
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
