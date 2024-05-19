import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:uksc_dashboard/models/cruise_control.dart';

class SpeedDisplay extends StatelessWidget {
  const SpeedDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSpeedDisplay(context),
          const SizedBox(height: 5),
          _buildCCSpeedDisplay(context),
        ],
      ),
    );
  }

  Widget _buildSpeedDisplay(BuildContext context) {
    return Consumer<Speed>(
      builder: (context, speed, child) {
        Color textColor = speed.mph > 50
            ? Color.fromRGBO(255, (255 * (1 - (speed.mph - 50) / 50)).toInt(), 0, 1)
            : Colors.white;

        String displaySpeed = speed.mph.abs() < 10
            ? speed.mph.abs().toStringAsFixed(1)
            : speed.mph.abs().toStringAsFixed(0);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.all(10),
          width: 120,
          child: Column(
            children: [
              const Text(
                'Speed MPH',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                displaySpeed,
                style: TextStyle(
                  fontSize: 40,
                  color: textColor.withOpacity(speed.mph > 50 ? (speed.mph - 50) / 50 : 1.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCCSpeedDisplay(BuildContext context) {
    return Consumer<CruiseControl>(
      builder: (context, cruiseControl, child) {

        String displayCCSpeed = cruiseControl.enabled ? cruiseControl.setPoint.toStringAsFixed(0) : 'N/A';

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 2),
          ),
          padding: const EdgeInsets.all(10),
          width: 120,
          child: Column(
            children: [
              const Text(
                'CC Speed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                displayCCSpeed,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
