import 'package:flutter/material.dart';
import 'package:args/args.dart';
import 'package:provider/provider.dart';

import 'package:uksc_dashboard/constants.dart';
import 'package:uksc_dashboard/websocket.dart';
import 'package:uksc_dashboard/dashboards/basic.dart';

void main(List<String> args) {
  // argument setup
  final parser = ArgParser();
  parser.addOption('dashboard',
      abbr: 'd', help: 'Dashboard to display', allowed: ['1', '2', 'basic'], defaultsTo: defaultDashboard);
  parser.addOption('host', abbr: 'h', help: 'Webserver IP address', defaultsTo: defaultHost);
  parser.addOption('port', abbr: 'p', help: 'Webserver port', defaultsTo: defaultPort.toString());
  final userArgs = parser.parse(args);

  final webSocketManager =
      WebSocketManager(Uri(scheme: 'wss', host: userArgs['host'], port: int.tryParse(userArgs['port']) ?? defaultPort));

  // don't be clever, I know a lot of this code is shared. Read up on how const works in dart and you'll understand why
  // I'm doing this. Specifically, const BaseApp(dashboard: BasicDashboard()) is able to be compiled because the
  // dashboard is also const. If you try to split the only thing that changes (dashboard) in to a separate variable,
  // you will no longer be able to instantiate BaseApp, since it is a const class requiring a const dashboard, and it is
  // impossible to tell at compile time what it should be. The current way basically compiles each possible way, and
  // then switches between them at runtime.
  switch (userArgs['dashboard']) {
    case '1':
      runApp(MultiProvider(
        providers: webSocketManager.providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
      break;
    case '2':
      runApp(MultiProvider(
        providers: webSocketManager.providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
      break;
    case 'basic':
    default:
      runApp(MultiProvider(
        providers: webSocketManager.providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
  }
}

class BaseApp extends StatelessWidget {
  final Widget dashboard;

  const BaseApp({Key? key, required this.dashboard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      home: dashboard,
    );
  }
}
