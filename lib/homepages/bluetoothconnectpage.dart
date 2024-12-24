import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../widgets/roundcard.dart';

class BluetoothConnectPage extends StatelessWidget {
  const BluetoothConnectPage({super.key, required this.bluetoothState, required this.changePair});

  final BluetoothState bluetoothState;
  final Function(bool) changePair;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: RoundCard(
        child: ListTile(
          
          leading: Icon(Icons.device_hub),
          
          title: Text("Bluetooth Off"),
          subtitle: Text("Switch to turn On"),
          trailing:Switch(
            activeColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Colors.grey,
            value: bluetoothState.isEnabled, onChanged: (v)async{
                       if (v) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      } else {
                        await FlutterBluetoothSerial.instance.requestDisable();
                      }
          }),
        ),
      ),
    );
  }
}