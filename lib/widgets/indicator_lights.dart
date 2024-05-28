import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/status.dart';
import 'package:uksc_dashboard/models/cruise_control.dart';

class StateIconIndicator extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final bool isActive;

  const StateIconIndicator({
    Key? key,
    required this.activeColor,
    required this.inactiveColor,
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
  }) : super(key: key);

  @override
  _StateIconIndicatorState createState() => _StateIconIndicatorState();
}

class _StateIconIndicatorState extends State<StateIconIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: widget.isActive ? widget.activeColor : widget.inactiveColor,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(5),
      child: Center(
        child: Icon(
          widget.isActive ? widget.activeIcon : widget.inactiveIcon,
          color: Colors.white,
          size: 45,
        ),
      ),
    );
  }
}

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
            color: Colors.white,
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
            activeText: "FR",
            inactiveText: "RV",
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
            inactiveText: "T",
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
        // Error indicator
        Consumer<Status>(
          builder: (context, status, child) => StateIconIndicator(
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
            isActive: false,
            activeIcon: Icons.error,
            inactiveIcon: Icons.error_outline,
          ),
        ),
      ],
    );
  }
}
