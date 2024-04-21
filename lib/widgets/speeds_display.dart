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
          Consumer<Speed>(
            builder: (context, speed, child) {
              Color textColor;
              double opacity = 1.0;

              if (speed.mph > 50) {
                // Calculate opacity based on how much above 50 MPH
                opacity = (speed.mph - 50) / 50;
                textColor = Color.fromRGBO(255, (255 * (1 - opacity)).toInt(), 0, 1);
              } else {
                textColor = Colors.white;
              }

              String displaySpeed = speed.mph.abs() < 10
                  ? speed.mph.abs().toStringAsFixed(1)
                  : speed.mph.abs().toStringAsFixed(0);

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white),
                ),
                padding: const EdgeInsets.all(10),
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
                        color: textColor.withOpacity(opacity),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 5), // Add some spacing between the speed displays
          Consumer<CruiseControl>(
            builder: (context, cruiseControl, child) {
              Color textColor;
              double opacity = 1.0;
              String displayCCSpeed = '0';

              if (!cruiseControl.enabled) {
                textColor = Colors.grey;
                displayCCSpeed = 'N/A';
              } else {
                // Cruise control is enabled, get setPoint from cruiseControl
                // Assuming the setPoint is of type double
                displayCCSpeed = cruiseControl.setPoint.toStringAsFixed(0);
                // Calculate opacity and text color based on setPoint value
                if (cruiseControl.setPoint > 50) {
                  opacity = (cruiseControl.setPoint - 50) / 50;
                  textColor = Color.fromRGBO(255, (255 * (1 - opacity)).toInt(), 0, 1);
                } else {
                  textColor = Colors.white;
                }
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white),
                ),
                padding: const EdgeInsets.all(10),
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
                        color: textColor.withOpacity(opacity),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
