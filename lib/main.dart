import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterapp/controller/bluetoothcontroller.dart';
import 'package:waterapp/theme.dart';

import './MainPage.dart';

void main() {
    Get.put(BluetoothController());
  runApp(ExampleApplication());


}

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Water Sense", theme: darkTheme, home: MainPage());
  }
}
