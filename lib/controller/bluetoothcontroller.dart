import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BluetoothController extends GetxController{

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothState get bluetoothState=>_bluetoothState; 

  String? address;
  String name = "...";
  List<BluetoothDevice> devices = [];
  Timer? discoverableTimeoutTimer;
  int discoverableTimeoutSecondsLeft = 0;


  bool autoAcceptPairingRequests = false;
  double? high;
  double? low;
String? bluetoothserveraddress;
  String label = "Normal";
  @override
  void onInit() async{
    super.onInit();
    await getPreferences();
    await getBluetoothServerAddress();

  }

Future<void> getPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("low")){
  low =  prefs.getDouble("low");

  }
  if(prefs.containsKey("high")){

  high = prefs.getDouble("high");
  }
  update();
}

void getDevices(){
      FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
     
        devices = bondedDevices;
    });
    update();
}

Future<void> setValues(String key,double value)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("Set values in sharedpreferences :$value");
  prefs.setDouble(key, value);
  getPreferences();
}

Future<void> setBluetoothAddress(String address)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("Set address bluetooth in sharedpreferences :$address");
  prefs.setString("bluetooth", address);
  getBluetoothServerAddress();
}

Future<void> getBluetoothServerAddress()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("bluetooth")){
  bluetoothserveraddress = prefs.getString("bluetooth");
  print("in controller sharedpreferences: $bluetoothserveraddress");
  }
  update();
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
    getBluetoothname();

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