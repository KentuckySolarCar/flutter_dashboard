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

  final webSocketManager = WebSocketManager(
      Uri(scheme: 'wss', host: userArgs['host'], port: int.tryParse(userArgs['port']) ?? defaultPort),
      testing: true);

  final providers = [
    // expose the websocket manager. This won't ever call notifyListeners(), but allows us to access it from anywhere
    ChangeNotifierProvider.value(value: webSocketManager),
    ChangeNotifierProvider.value(value: webSocketManager.webSocketStatus),
    ...webSocketManager.carModels.map((e) => e.provider),
  ];

  switch (userArgs['dashboard']) {
    case '1':
      runApp(MultiProvider(
        providers: providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
      break;
    case '2':
      runApp(MultiProvider(
        providers: providers,
        child: const BaseApp(dashboard: BasicDashboard()),
      ));
      break;
    case 'basic':
    default:
      runApp(MultiProvider(
        providers: providers,
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
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
