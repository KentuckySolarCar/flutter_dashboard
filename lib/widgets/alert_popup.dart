class AlertListener extends StatelessWidget {
  final Widget child;
  const AlertListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertModel>(
      builder: (context, alertModel, _) {
        final alert = alertModel.latestAlert;

        if (alert != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'ALERT from ${alert.snitch}, Code: ${alert.alertCode}, Mod: ${alert.module}, Arg1: ${alert.arg1}',
                  style: const TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 4),
              ),
            );

            alertModel.clearAlert(); // Only show once
          });
        }

        return child;
      },
    );
  }
}
