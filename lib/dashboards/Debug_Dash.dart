import 'package:flutter/material.dart';
import 'package:uksc_dashboard/widgets/debug_display.dart';

class DebugDashboard extends StatelessWidget{
  const DebugDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [DebugDisplay()],
        ),
      ),
    );
  }
}