import 'package:flutter_dashboard/models/speed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A basic dashboard displaying simple stuff such as the speed.
///
/// Primarily meant for development and testing
class BasicDashboard extends StatelessWidget {
  const BasicDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<SpeedModel>(
            builder: (context, speed, child) {
              return Text('${speed.mph.toStringAsFixed(2)} MPH');
            },
          ),
        ],
      ),
    );
  }
}
