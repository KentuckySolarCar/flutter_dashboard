import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/telemetry_status.dart';

/// The preferred height of the status bar
const statusBarHeight = 35.0;

/// The elevation of the statusBar
// TODO: would prefer not to use this at all
const statusBarElevation = 1.0;

/// The spacing between provided children to be placed in the status bar
const statusBarChildrenSpacing = 10.0;

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
        elevation: appBarTheme.elevation ?? 0.0,
        color: appBarTheme.backgroundColor,
        shadowColor: appBarTheme.shadowColor,
        surfaceTintColor: appBarTheme.surfaceTintColor,
        shape: appBarTheme.shape,
        child: Row(
          children: [
            const ConnectionStatus(),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: Wrap(spacing: statusBarChildrenSpacing, children: [...?children]),
            )),
            const Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: Clock(),
            )),
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(statusBarHeight);
}

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);

  // TODO: display time zone, allow user to change timezone when clicked... and/or maybe we can use the GPS data to automatically set the default timezone
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return SizedBox(
            height: double.infinity,
            width: 70,
            child: Align(
                alignment: Alignment.center,
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
    return Consumer<TelemetryStatus>(builder: (context, webSocketStatus, child) {
      Widget statusIcon;
      Widget statusText;
      switch (webSocketStatus.status) {
        case Status.connected:
          statusIcon = const Icon(Icons.sync, size: 24, color: Colors.green);
          statusText = Text('${webSocketStatus.averageLatencyMs.toStringAsFixed(1)}ms',
              style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center);

          break;
        case Status.connecting:
          // padding object here is a workaround for https://github.com/flutter/flutter/issues/3282
          statusIcon = const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3,
                  )));
          statusText =
              Text('Connecting...', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center);
          break;
        case Status.disconnected:
          statusIcon = const Icon(Icons.sync_problem, size: 24, color: Colors.orange);
          statusText =
              Text('Disconnected', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center);
          break;
      }

      return Row(
        children: [
          statusIcon,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: statusText,
          )
        ],
      );
    });
  }
}
