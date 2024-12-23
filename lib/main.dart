import 'package:flutter/material.dart';
import 'package:waterapp/theme.dart';

import './MainPage.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      home: MainPage());
  }
}
