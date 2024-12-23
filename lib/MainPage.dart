import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:waterapp/SelectBondedDevicePage.dart';
import 'package:waterapp/homepages/homepage.dart';
import 'package:waterapp/homepages/settings.dart';
import 'package:waterapp/widgets/connectingpage.dart';
import './BackgroundCollectingTask.dart';
import './ChatPage.dart';

// import './helpers/LineChart.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}
class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}
class _MainPage extends State<MainPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;


  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  BluetoothDevice? device;

  @override
  void initState() {
    super.initState();
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }
  void changePair(bool value){
    setState(() {
      _autoAcceptPairingRequests = value;
    });
  }
  int index = 0;
  void changeIndex(int ins){
    setState(() {
      index = ins;
    });
  }
  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }



void connectDevice(BluetoothDevice device){
      setState(() {
        isConnecting = true;
        this.device  = device;
      });
      BluetoothConnection.toAddress(device.address).then((connections) {
      print('Connected to the device');
      connection = connections;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {

        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
            setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      print('Cannot connect, exception occured');
      print(error);
    }).timeout(Duration(seconds: 15,),onTimeout: (){
            setState(() {
        isConnecting = false;
        isDisconnecting = false;
           print('Disconnecter : Timeout');
      });

    });
}


  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        // setState(() {
        //   messages.add(_Message(clientID, text));
        // });

        // Future.delayed(Duration(milliseconds: 333)).then((_) {
        //   listScrollController.animateTo(
        //       listScrollController.position.maxScrollExtent,
        //       duration: Duration(milliseconds: 333),
        //       curve: Curves.easeOut);
        // });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }





  @override
  Widget build(BuildContext context) {

        return Scaffold(
          // appBar: AppBar(
          //   title: const Text('Flutter Bluetooth Serial'),
          // ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
           backgroundColor: const Color.fromARGB(255, 2, 44, 105),
           selectedItemColor: Colors.white,
           unselectedItemColor: Colors.white60,
            currentIndex: index,
            onTap: (v){
              changeIndex(v);
            },
            items:  const [
            BottomNavigationBarItem(
          
              icon: Icon(Icons.home),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list),label: "Devices"),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
          ]),
          body:index==0?isConnecting?const ConnectingPage():HomePage(isConnected:isConnected,device: device,) :index==1? SelectBondedDevicePage(checkAvailability: false,listenDatas: (dev){
   
            changeIndex(0);
          },):SettingsPage(bluetoothState:_bluetoothState, name: _name, address: _address, discoverableTimeoutSecondsLeft: _discoverableTimeoutSecondsLeft, discoverableTimeoutTimer: _discoverableTimeoutTimer, changePair: changePair, autoAcceptPairingRequests: _autoAcceptPairingRequests)
        );
  
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      await _collectingTask!.start();
    } catch (ex) {
      _collectingTask?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
