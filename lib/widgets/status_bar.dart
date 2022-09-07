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
    return Material(child: Consumer<WebSocketStatus>(builder: (context, webSocketStatus, child) {
      Widget statusWidget;
      switch (webSocketStatus.status) {
        case Status.connected:
          statusWidget = Row(children: [
            const Icon(Icons.sync, size: 24, color: Colors.green),
            Text(' (${webSocketStatus.averageLatencyMs.toStringAsFixed(1)}ms)', style: Theme.of(context).textTheme.titleMedium)
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
            Text('Connecting...', style: Theme.of(context).textTheme.titleMedium),
          ]);
          break;
        case Status.disconnected:
          statusWidget = const Icon(Icons.sync_problem, size: 24, color: Colors.orange);
          break;
      }

      return SizedBox(
          height: 30,
          width: null,
          child: Container(margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4), child: statusWidget));
    }));
  }
}
