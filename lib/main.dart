import 'package:flutter/material.dart';
import 'package:args/args.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart';
import 'package:provider/provider.dart';
import 'package:cole_dashboard/models/speed.dart';
import 'package:cole_dashboard/models/cruise_control.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('dashboard',
      abbr: 'd',
      help: 'Dashboard to display',
      defaultsTo: '1',
      allowed: ['1', '2']);
  parser.addOption('host',
      abbr: 'h', help: 'Webserver IP address', defaultsTo: '127.0.0.1');
  parser.addOption('port',
      abbr: 'p', help: 'Webserver port', defaultsTo: '1337');
  var results = parser.parse(args);

  switch (results['dashboard']) {
    case '1':
      runApp(BaseApp(dashboard: dashboard));
      break;
    case '2':
    // TODO launch a different dashboard
      runApp(BaseApp(dashboard: dashboard));
      break;
  }
}

class BaseApp extends StatelessWidget {
  const BaseApp({Key? key, required this.dashboard}) : super(key: key);

  final Widget dashboard;

  @override
  Widget build(BuildContext context) {
    // TODO set up websocket stuff with context

    return MultiProvider(
      // set up providers for values
      providers: [
        Provider<SpeedModel>(create: (context) => SpeedModel()),
        Provider<CruiseControl>(create: (context) => CruiseControl())
      ],
      child: MaterialApp(
        title: 'Gato Del Sol 7',
        home: dashboard,
      ),
    );
  }
}
