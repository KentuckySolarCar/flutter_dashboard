import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/websocket.dart';
import 'package:uksc_dashboard/constants.dart';

/// Represents a status bar, displaying essential information such as connection status, time, etc.
///
/// This widget is meant to be used as an [AppBar] for the [Scaffold] of a dashboard. Can be passed
/// a list of [Widget]s to display on the status bar.
class StatusBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? children;

  const StatusBar({Key? key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return Material(
        // no elevation default :(
        elevation: appBarTheme.elevation ?? statusBarElevation,
        color: appBarTheme.backgroundColor,
        shadowColor: appBarTheme.shadowColor,
        surfaceTintColor: appBarTheme.surfaceTintColor,
        shape: appBarTheme.shape,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ConnectionStatus(),
            const Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: Clock(),
            )),
            ...?children,
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(statusBarHeight);
}

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return SizedBox(
            height: statusBarHeight,
            width: 70,
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                child: Text(
                    '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center)));
      },
    );
  }
}

/// Widget that displays the websocket connection status in a friendly manner
class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketStatus>(builder: (context, webSocketStatus, child) {
      Widget statusWidget;
      switch (webSocketStatus.status) {
        case Status.connected:
          statusWidget = Row(children: [
            const Icon(Icons.sync, size: 24, color: Colors.green),
            Text('(${webSocketStatus.averageLatencyMs.toStringAsFixed(1)}ms)',
                style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center)
          ]);
          break;
        case Status.connecting:
          statusWidget = Row(children: [
            const Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 0.0, 10.0, 0.0),
                    child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3,
                        )))),
            Text('Connecting...', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          ]);
          break;
        case Status.disconnected:
          statusWidget = const Icon(Icons.sync_problem, size: 24, color: Colors.orange);
          break;
      }

      return SizedBox(
          height: statusBarHeight,
          width: null,
          child: Container(margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4), child: statusWidget));
    });
  }
}
