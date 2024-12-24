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
          child: SizedBox(
               height: 500,
               width: 500,
               child: Column(
                 children: [
                   Text("Connecting: ${device?.name??""}",style: TextStyle(color: Colors.white,fontSize: 20),),
                   SizedBox(height: 20,),
                   Lottie.asset('assets/bluetoothloading.json',width: 300,height: 300,fit: BoxFit.contain),
                 ],
               )),
        );
  }
}