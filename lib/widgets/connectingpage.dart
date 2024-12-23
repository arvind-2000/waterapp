import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lottie/lottie.dart';

import 'roundcard.dart';

class ConnectingPage extends StatelessWidget {
  const ConnectingPage({super.key, this.device});
  final BluetoothDevice? device;
  @override
  Widget build(BuildContext context) {
    return Center(
          child: RoundCard(
            isGradient: true,
            
             child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      Text("Connecting to : ${device?.name??""}"),
                      SizedBox(height: 20,),
                      Lottie.asset('assets/bluetoothloading.json',fit: BoxFit.contain),
                    ],
                  ))),
        );
  }
}