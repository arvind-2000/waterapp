import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterapp/SelectBondedDevicePage.dart';
import 'package:waterapp/controller/bluetoothcontroller.dart';
import 'package:waterapp/homepages/bluetoothconnectpage.dart';
import 'package:waterapp/homepages/disconnectedPage.dart';
import 'package:waterapp/homepages/homepage.dart';
import 'package:waterapp/homepages/settings.dart';
import 'package:waterapp/widgets/connectingpage.dart';
import './ChatPage.dart';
import 'widgets/roundcard.dart';

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
  String? bluetoothserveraddres;
  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  bool _autoAcceptPairingRequests = false;

  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingHighController = TextEditingController();
  bool isConnecting = false;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;
  BluetoothDevice? device;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool canPop = false;
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
    checkBluetooth();

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

  void changePair(bool value) {
    setState(() {
      _autoAcceptPairingRequests = value;
    });
  }

  int index = 0;
  void changeIndex(int ins) {
    if (_key.currentState!.hasDrawer && _key.currentState!.isDrawerOpen) {
      _key.currentState!.closeDrawer();
    }
    setState(() {
      index = ins;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    connection = null;
    super.dispose();
  }

  void connectDevice(String bluetoothaddress) {
   
    setState(() {
      isConnecting = true;
      // this.device = device;
    });
    BluetoothConnection.toAddress(bluetoothaddress).then((connections) {
      print('Connected to the device');
      connection = connections;
       Get.find<BluetoothController>().setBluetoothAddress(bluetoothaddress);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: const Text(
            "Failed to Connect",
            style: TextStyle(color: Colors.white),
          )));
      print('Cannot connect, exception occured');
      print(error);
    }).timeout(
        const Duration(
          seconds: 15,
        ), onTimeout: () {
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
        if(messages.length>10){
          messages.removeAt(0);
        }
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

  void _sendMessage(String text,String val,Function(String) savePreference) async {
    text = text.trim();
    textEditingController.clear();
    textEditingHighController.clear();
    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await connection!.output.allSent;
        savePreference(val);
      ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Message Sent")));
      } catch (e) {
        // Ignore error, but notify state
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to send message")));
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (d,v){
        if(index==0){
          setState(() {
            canPop = true;
          }
          
          );
          
        }else{
          changeIndex(0);
        }
      },
      child: GetBuilder<BluetoothController>(
        builder: (bluectrl) {
          return Scaffold(
              key: _key,
              drawer: Drawer(
                backgroundColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue[300]!, Colors.blue[900]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset("assets/logosplash.png"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Water Sense",
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  )
                                ],
                              ),
                            )),
                        Expanded(
                          child: Column(
                            children: [
                              RoundCard(
                                margin:
                                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                padding: EdgeInsets.zero,
                                isGradient: true,
                                sidecolor: index == 0 ? Colors.white : null,
                                // color: index==0?Colors.red:null,
                                child: ListTile(
                                  onTap: () {
                                    changeIndex(0);
                                  },
                                  leading: Icon(
                                    Icons.home_filled,
                                    color: index == 0 ? Colors.blue : null,
                                  ),
                                  title: Text(
                                    "Home",
                                    style: TextStyle(
                                      color: index == 0 ? Colors.blue : null,
                                    ),
                                  ),
                                ),
                              ),
                              RoundCard(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                padding: EdgeInsets.zero,
                                isGradient: true,
                                sidecolor: index == 1 ? Colors.white : null,
                                // color: index==0?Colors.red:null,
                                child: ListTile(
                                  onTap: () {
                                    changeIndex(1);
                                  },
                                  leading: Icon(
                                    Icons.devices_fold,
                                    color: index == 1 ? Colors.blue : null,
                                  ),
                                  title: Text(
                                    "Devices",
                                    style: TextStyle(
                                      color: index == 1 ? Colors.blue : null,
                                    ),
                                  ),
                                ),
                              ),
                              RoundCard(
                                margin:
                                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                padding: EdgeInsets.zero,
                                isGradient: true,
                                sidecolor: index == 2 ? Colors.white : null,
                                // color: index==0?Colors.red:null,
                                child: ListTile(
                                  onTap: () {
                                    changeIndex(2);
                                  },
                                  leading: Icon(
                                    Icons.settings,
                                    color: index == 2 ? Colors.blue : null,
                                  ),
                                  title: Text(
                                    "Settings",
                                    style: TextStyle(
                                      color: index == 2 ? Colors.blue : null,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              RoundCard(
                                margin:
                                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                padding: EdgeInsets.zero,
                                isGradient: true,
          
                                // color: index==0?Colors.red:null,
                                child: ListTile(
                                  onTap: () {},
                                  leading: Icon(Icons.android),
                                  title: Text("App Version"),
                                  subtitle: const Text("1.0.0"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "W  A  T  E  R    S  E  N  S  E",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // bottomNavigationBar: _bluetoothState.isEnabled
              //     ? BottomNavigationBar(
              //         elevation: 0,
              //         backgroundColor: const Color.fromARGB(255, 2, 44, 105),
              //         selectedItemColor: Colors.white,
              //         unselectedItemColor: Colors.white60,
              //         currentIndex: index,
              //         onTap: (v) {
              //           changeIndex(v);
              //         },
              //         items: const [
              //             BottomNavigationBarItem(
              //                 icon: Icon(Icons.home), label: "Home"),
              //             BottomNavigationBarItem(
              //                 icon: Icon(Icons.list), label: "Devices"),
          
              //           ])
              //     : null,
              body: Container(
                height: MediaQuery.sizeOf(context).height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.blue[800]!,
                  Colors.blue[300]!,
                  Colors.blue[900]!
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (_key.currentState!.hasDrawer &&
                                        _key.currentState!.isDrawerOpen) {
                                      _key.currentState!.closeDrawer();
                                    } else {
                                      _key.currentState!.openDrawer();
                                    }
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset("assets/logosplash.png"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "Water Sense",
                                  style: TextStyle(color: Colors.white, fontSize: 24),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  changeIndex(2);
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: !_bluetoothState.isEnabled
                            ? BluetoothConnectPage(
                                bluetoothState: _bluetoothState,
                                changePair: changePair)
                            : index == 0
                                ? isConnecting
                                    ? ConnectingPage(
                                        device: device,
                                      )
                                    : 
                                    isConnected &&
                                            connection != null &&
                                            connection!.isConnected
                                        ?
                                        
                                         HomePage(
                                            sendMessageController:
                                                textEditingController,
                                                sendMessageHighController: textEditingHighController,
                                            value:messages.isEmpty?"0": messages.last.text,
                                      
                                            isConnected: isConnected,
                                            device: device,
                                            sendMessage: (v,val,func) {
                                              _sendMessage(v,val,func);
                                            
                                            })
                                        : DisconnectedPage(
                                          connectDevice: (v){
                                            connectDevice(v);
                                          },
                                          bluetoothAddress: bluetoothserveraddres,
                                            isConnected: isConnected,
                                            onConnect: () {
                                              changeIndex(1);
                                            })
                                : index == 1
                                    ? SelectBondedDevicePage(
                                        checkAvailability: false,
                                        listenDatas: (dev) {
                                          connectDevice(dev.address);
                                          changeIndex(0);
                                        },
                                      )
                                    : SettingsPage(
                                        bluetoothState: _bluetoothState,
                                        name: _name,
                                        address: _address,
                                        discoverableTimeoutSecondsLeft:
                                            _discoverableTimeoutSecondsLeft,
                                        discoverableTimeoutTimer:
                                            _discoverableTimeoutTimer,
                                        changePair: changePair,
                                        autoAcceptPairingRequests:
                                            _autoAcceptPairingRequests),
                      ),
                    ],
                  ),
                ),
              ));
        }
      ),
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


  void checkBluetooth() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addresses = prefs.getString("bluetooth");
    
    setState(() {
      bluetoothserveraddres = addresses;
    });
    print("Address: ${addresses??"null"}");
    if(addresses!=null){
      print("in initstate homepage: In auto connectiong bluetooth");
      connectDevice(addresses);
    }
  }
}
