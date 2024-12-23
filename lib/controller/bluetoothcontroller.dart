import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:waterapp/BackgroundCollectingTask.dart';

class BluetoothController extends GetxController{

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothState get bluetoothState=>_bluetoothState; 

  String address = "...";
  String name = "...";

  Timer? discoverableTimeoutTimer;
  int discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? collectingTask;

  bool autoAcceptPairingRequests = false;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBluetoothState();
    getBluetoothAddress();
    getBluetoothname();
    listenBluetoothState();
  }

void getBluetoothState(){
      FlutterBluetoothSerial.instance.state.then((state) {
        _bluetoothState = state;
        update();    
    });
}

void getBluetoothAddress(){
    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((addresses) {
        
          address = addresses!;
          update();
      });
    });
}

void getBluetoothname(){
    FlutterBluetoothSerial.instance.name.then((names) {
        name = names!;
      update();
    });
}

void listenBluetoothState(){
      FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
   
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        discoverableTimeoutTimer = null;
        discoverableTimeoutSecondsLeft = 0;
        update();
    });
}






}