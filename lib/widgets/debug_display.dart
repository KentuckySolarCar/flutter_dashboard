import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:uksc_dashboard/models/base_model.dart';
import 'package:uksc_dashboard/models/battery.dart';
import 'package:uksc_dashboard/models/can_log.dart';
import 'package:uksc_dashboard/models/controls.dart';
import 'package:uksc_dashboard/models/cruise_control.dart';
import 'package:uksc_dashboard/models/errors.dart';
import 'package:uksc_dashboard/models/general.dart';
import 'package:uksc_dashboard/models/motors.dart';
import 'package:uksc_dashboard/models/status.dart';
import 'package:uksc_dashboard/models/timing.dart';
import 'package:uksc_dashboard/models/telemetry_status.dart';

class DebugDisplay extends StatelessWidget
{
  const DebugDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children:[
            Consumer<Speed>(
              builder: (context, speed, child) => DebugText(
                labelText: "Speed in MPH: ",
                dataText: speed.mph.toString(), //it is a double and I need it to be a string
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DebugText extends StatelessWidget
{
  final String labelText;
  final String dataText;

  const DebugText({
    Key? key,
    required this.labelText,
    required this.dataText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        labelText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      Text(
        dataText,
        style: TextStyle(
          fontSize: 20,
          fontWeight:FontWeight.normal,
          color: Colors.white,
        ),
      ),
    ],);
  }
}

