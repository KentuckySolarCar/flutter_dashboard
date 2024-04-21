import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/status.dart';
import 'package:uksc_dashboard/models/cruise_control.dart';

class StateIndicator extends StatelessWidget {
  final Color activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;
  final double textSize;
  final bool isActive;

  const StateIndicator({
    Key? key,
    required this.activeColor,
    required this.inactiveColor,
    required this.isActive,
    required this.activeText,
    required this.inactiveText,
    required this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(5),
      child: Center(
        child: Text(
          isActive ? activeText : inactiveText,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: textSize,
          ),
        ),
      ),
    );
  }
}


class IndicatorLightsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Forward Reverse
        Consumer<Status>(
          builder: (context, status, child) => StateIndicator(
            activeColor: Colors.green,
            inactiveColor: Colors.red,
            isActive: status.forwardReverse,
            activeText: "F",
            inactiveText: "R",
            textSize: 40,
          ),
        ),
        // Triggers Pedals
        Consumer<Status>(
          builder: (context, status, child) => StateIndicator(
            activeColor: Colors.grey[600]!,
            inactiveColor: Colors.grey[600]!,
            isActive: status.wheelPedal,
            activeText: "P",
            inactiveText: "W",
            textSize: 40,
          ),
        ),
        // Cruise control on off
        Consumer<CruiseControl>(
          builder: (context, status, child) => StateIndicator(
            activeColor: Colors.lightGreen,
            inactiveColor: Colors.grey[800]!,
            isActive: status.enabled,
            activeText: "CC",
            inactiveText: "CC",
            textSize: 35,
          ),
        ),
        // Add more StateIndicators as needed
      ],
    );
  }
}