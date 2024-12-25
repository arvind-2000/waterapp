import 'package:flutter/material.dart';

import '../widgets/roundcard.dart';

class DisconnectedPage extends StatelessWidget {
  const DisconnectedPage({super.key, required this.isConnected, required this.onConnect, this.bluetoothAddress, required this.connectDevice});
  final bool isConnected;
  final VoidCallback onConnect;
  final Function(String) connectDevice;
  final String? bluetoothAddress;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
              bluetoothAddress!=null?RoundCard(
                isGradient: true,
                
            child: ListTile(
              
              leading: const Icon(Icons.developer_board),
              
              title: const Text("Recently Connected"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$bluetoothAddress"),
                  const SizedBox(height: 10,),
                  const Text("Connect Again")
                ],
              ),
              trailing:IconButton(onPressed: (){
                connectDevice(bluetoothAddress??"");
              }, icon: const Icon(Icons.link_rounded)),
            ),
          ):const SizedBox(),
        
          RoundCard(
            sidecolor: Colors.white,
            child: ListTile(
              
              leading: const Icon(Icons.device_hub),
              
              title: const Text("No Device Connected"),
              subtitle: const Text("Press to Connect"),
              trailing:IconButton(onPressed: onConnect, icon: const Icon(Icons.arrow_forward_ios)),
            ),
          ),
        ],
      ),
    );
  }
}