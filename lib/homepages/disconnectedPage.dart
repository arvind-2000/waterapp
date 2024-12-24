import 'package:flutter/material.dart';

import '../widgets/roundcard.dart';

class DisconnectedPage extends StatelessWidget {
  const DisconnectedPage({super.key, required this.isConnected, required this.onConnect});
  final bool isConnected;
  final VoidCallback onConnect;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RoundCard(
        child: ListTile(
          
          leading: Icon(Icons.device_hub),
          
          title: Text("No Device Connected"),
          subtitle: Text("Press to Connect"),
          trailing:IconButton(onPressed: onConnect, icon: Icon(Icons.arrow_forward_ios)),
        ),
      ),
    );
  }
}