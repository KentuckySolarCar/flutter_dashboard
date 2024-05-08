import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/timing.dart';

class TimeReadout extends StatelessWidget {
  const TimeReadout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeReadout(context, 'Current Time', (timing) => timing.unixTime, true),
          SizedBox(height: 3),
          _buildTimeReadout(context, 'Lap Timer', (timing) => timing.lapTime, false),

        ],
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
          isUNIXtime? _formatUnixTime(value) : _formatTime(value),
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
    // Convert seconds to hours, minutes, seconds
    int hours = value ~/ 3600;
    int minutes = (value % 3600) ~/ 60;
    int seconds = value.toInt() % 60;
    int milliseconds = ((value * 1000) % 1000).toInt();

    String timeString = '$hours:$minutes:${seconds.toString().padLeft(2, '0')}';
  
    if (milliseconds > 0) {
      timeString += '.${milliseconds.toString().padLeft(2, '0')}';
    }

    return timeString;
  }

  String _formatUnixTime(double unixTime) {
    // Create a DateTime object from the Unix time
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime.toInt() * 1000);
  
    // Format the DateTime object to 24-hour time
    String formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    return formattedTime;
  }


}