import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/websocket.dart';

/// A basic widget that simply displays the speed, nice and big.
///
/// The speed also changes colors at different thresholds. This is meant as a template to help show how widgets can be implemented.
class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<WebSocketStatus>(builder: (context, webSocketStatus, child) {
        Text statusText;
        Icon statusIcon;
        switch (webSocketStatus.status) {
          case Status.connected:
            statusText = const Text(' Connected', style: TextStyle(fontSize: 22, color: Colors.green));
            statusIcon = const Icon(Icons.sync, size: 28, color: Colors.green);
            break;
          case Status.connecting:
            statusText = const Text(' Connecting', style: TextStyle(fontSize: 22));
            statusIcon = const Icon(Icons.sync_disabled, size: 28);
            break;
          case Status.disconnected:
            statusText = const Text(' Disconnected', style: TextStyle(fontSize: 22, color: Colors.orange));
            statusIcon = const Icon(Icons.sync_problem, size: 28, color: Colors.orange);
            break;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            statusIcon,
            statusText,
            if (webSocketStatus.status == Status.connected)
              Text(' (${webSocketStatus.latencyMs}ms)', style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        );
      }),
    );
  }
}
