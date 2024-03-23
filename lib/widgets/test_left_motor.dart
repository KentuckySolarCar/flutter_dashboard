import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/motors.dart';

// Basic widget for the motor temperature to try and learn writing these and test if it works

class MotorTemp extends StatelessWidget {
  const MotorTemp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Material(
      child: Consumer<LeftMotor>(builder: (context, temp, child) {
        return Text('${temp.leftMotorTemp.toStringAsFixed(0)} Volts',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
            ));
      }
    ),
    );
  }
}