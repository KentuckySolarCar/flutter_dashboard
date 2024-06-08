import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/timing.dart';

//TODO lock decimal readout for laptime and real time
//TODO lock size of the widget itself
class TimeReadout extends StatelessWidget {
  const TimeReadout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height:300,
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeReadout(context, 'Current Time', (timing) => timing.unixTime, true),
            SizedBox(height: 3),
            _buildTimeReadout(context, 'Lap Timer', (timing) => timing.lapTime, false),
      
          ],
        ),
      ),
    );
  }

  Widget _buildTimeReadout(BuildContext context, String label, double Function(Timing) getValue, bool isUNIXtime) {
    Timing timing = Provider.of<Timing>(context);
    double value = getValue(timing);

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        Text(
          isUNIXtime ? _formatUnixTime(value) : _formatTime(value),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  String _formatTime(double value) {
  int minutes = (value % 3600) ~/ 60;
  int seconds = value.toInt() % 60;
  double milliseconds = value - value.toInt();

  String timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  if (milliseconds > 0) {
    String msString = (milliseconds * 1000).toStringAsFixed(0).padLeft(3, '0');
    timeString += '.${msString.substring(0, msString.length - 1)}'; // Trim last zero
  }

  return timeString;
  }




  String _formatUnixTime(double unixTime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime.toInt() * 1000);

    String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    return formattedTime;
  }
}


