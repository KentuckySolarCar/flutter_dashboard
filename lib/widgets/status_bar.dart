import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/websocket.dart';

class StatusBar extends StatelessWidget {
  final List<Widget>? children;
  const StatusBar({Key? key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const ConnectionStatus(),
        ...?children,
      ],
    );
  }
}

/// Widget that displays the websocket connection status in a friendly manner
class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<WebSocketStatus>(builder: (context, webSocketStatus, child) {
        Text statusText;
        Widget statusIcon;
        switch (webSocketStatus.status) {
          case Status.connected:
            statusText = Text('Connected', style: Theme.of(context).textTheme.titleLarge);
            statusIcon = const Icon(Icons.sync, size: 24, color: Colors.green);
            break;
          case Status.connecting:
            statusText = Text('Connecting...', style: Theme.of(context).textTheme.titleLarge);
            statusIcon = const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(value: null)));
            break;
          case Status.disconnected:
            statusText = Text('Disconnected', style: Theme.of(context).textTheme.titleLarge);
            statusIcon = const Icon(Icons.sync_problem, size: 24, color: Colors.orange);
            break;
        }

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(margin: const EdgeInsets.symmetric(horizontal: 8.0), child: statusIcon),
                statusText,
                if (webSocketStatus.status == Status.connected)
                  Text(' (${webSocketStatus.latencyMs}ms)', style: Theme.of(context).textTheme.titleMedium),
              ],
            ));
      }),
    );
  }
}
