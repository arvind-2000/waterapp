import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../DiscoveryPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.bluetoothState, required this.name, required this.address, required this.discoverableTimeoutSecondsLeft, required this.discoverableTimeoutTimer, required this.changePair, required this.autoAcceptPairingRequests});
  final BluetoothState bluetoothState; 
  final String name;
  final String address;   
  final int discoverableTimeoutSecondsLeft;
  final Timer? discoverableTimeoutTimer;
  final Function(bool) changePair;
  final bool autoAcceptPairingRequests;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
            child: ListView(
              children: <Widget>[
             
                const ListTile(title: Text('General')),
                SwitchListTile(
                  title: const Text('Enable Bluetooth'),
                  value: widget.bluetoothState.isEnabled,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveTrackColor: Colors.grey,
                  onChanged: (bool value) {
                    // Do the request and update with the true value then
                    future() async {
                      // async lambda seems to not working
                      if (value) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      } else {
                        await FlutterBluetoothSerial.instance.requestDisable();
                      }
                    }
                    future().then((_) {
                      setState(() {});
                    });
                  },
                ),
                ListTile(
                  title: const Text('Bluetooth status'),
                  subtitle: Text(widget.bluetoothState.toString()),
                  trailing: ElevatedButton(
                    child: const Text('Settings'),
                    onPressed: () {
                      FlutterBluetoothSerial.instance.openSettings();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Local adapter address'),
                  subtitle: Text(widget.address),
                ),
                ListTile(
                  title: const Text('Local adapter name'),
                  subtitle: Text(widget.name),
                  onLongPress: null,
                ),
                // ListTile(
                //   title: widget.discoverableTimeoutSecondsLeft == 0
                //       ? const Text("Discoverable")
                //       : Text(
                //           "Discoverable for ${widget.discoverableTimeoutSecondsLeft}s"),
                //   subtitle: const Text("PsychoX-Luna"),
                //   trailing: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Checkbox(
                //         value: widget.discoverableTimeoutSecondsLeft != 0,
                //         onChanged: null,
                //       ),
                //       const IconButton(
                //         icon: Icon(Icons.edit),
                //         onPressed: null,
                //       ),
                //       // IconButton(
                //       //   icon: const Icon(Icons.refresh),
                //       //   onPressed: () async {
                //       //     print('Discoverable requested');
                //       //     final int timeout = (await FlutterBluetoothSerial.instance
                //       //         .requestDiscoverable(60))!;
                //       //     if (timeout < 0) {
                //       //       print('Discoverable mode denied');
                //       //     } else {
                //       //       print(
                //       //           'Discoverable mode acquired for $timeout seconds');
                //       //     }
                //       //     setState(() {
                //       //       widget.discoverableTimeoutTimer?.cancel();
                //       //       widget.discoverableTimeoutSecondsLeft = timeout;
                //       //       _discoverableTimeoutTimer =
                //       //           Timer.periodic(const Duration(seconds: 1), (Timer timer) {
                //       //         setState(() {
                //       //           if (_discoverableTimeoutSecondsLeft < 0) {
                //       //             FlutterBluetoothSerial.instance.isDiscoverable
                //       //                 .then((isDiscoverable) {
                //       //               if (isDiscoverable ?? false) {
                //       //                 print(
                //       //                     "Discoverable after timeout... might be infinity timeout :F");
                //       //                 _discoverableTimeoutSecondsLeft += 1;
                //       //               }
                //       //             });
                //       //             timer.cancel();
                //       //             _discoverableTimeoutSecondsLeft = 0;
                //       //           } else {
                //       //             _discoverableTimeoutSecondsLeft -= 1;
                //       //           }
                //       //         });
                //       //       });
                //       //     });
                //       //   },
                //       // )
                //     ],
                //   ),
                // ),
                const Divider(),
                const ListTile(title: Text('Devices discovery and connection')),
                SwitchListTile(
                  title: const Text('Auto-try specific pin when pairing'),
                  subtitle: const Text('Pin 1234'),
                  value: widget.autoAcceptPairingRequests,
                   activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveTrackColor: Colors.grey,
                  onChanged: (bool value) {
                    widget.changePair(value);
                    if (value) {
                      FlutterBluetoothSerial.instance.setPairingRequestHandler(
                          (BluetoothPairingRequest request) {
                        print("Trying to auto-pair with Pin 1234");
                        if (request.pairingVariant == PairingVariant.Pin) {
                          return Future.value("1234");
                        }
                        return Future.value(null);
                      });
                    } else {
                      FlutterBluetoothSerial.instance
                          .setPairingRequestHandler(null);
                    }
                  },
                ),
                ListTile(
                  title: ElevatedButton(
                      child: const Text('Explore discovered devices'),
                      onPressed: () async {
                        final BluetoothDevice? selectedDevice =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const DiscoveryPage();
                            },
                          ),
                        );
        
                        if (selectedDevice != null) {
                          print('Discovery -> selected ' + selectedDevice.address);
                        } else {
                          print('Discovery -> no device selected');
                        }
                      }),
                ),
                // ListTile(
                //   title: ElevatedButton(
                //     child: const Text('Connect to paired device to chat'),
                //     onPressed: () async {
                //       final BluetoothDevice? selectedDevice =
                //           await Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) {
                //             return const SelectBondedDevicePage(checkAvailability: false);
                //           },
                //         ),
                //       );
        
                //       // if (selectedDevice != null) {
                //       //   print('Connect -> selected ' + selectedDevice.address);
                //       //   widget.startChat(selectedDevice);
                //       // } else {
                //       //   print('Connect -> no device selected');
                //       // }
                //     },
                //   ),
                // ),
                // const Divider(),
                // const ListTile(title: Text('Multiple connections example')),
                // ListTile(
                //   title: ElevatedButton(
                //     child: ((_collectingTask?.inProgress ?? false)
                //         ? const Text('Disconnect and stop background collecting')
                //         : const Text('Connect to start background collecting')),
                //     onPressed: () async {
                //       if (_collectingTask?.inProgress ?? false) {
                //         await _collectingTask!.cancel();
                //         setState(() {
                //           /* Update for `_collectingTask.inProgress` */
                //         });
                //       } else {
                //         final BluetoothDevice? selectedDevice =
                //             await Navigator.of(context).push(
                //           MaterialPageRoute(
                //             builder: (context) {
                //               return const SelectBondedDevicePage(
                //                   checkAvailability: false);
                //             },
                //           ),
                //         );
        
                //         if (selectedDevice != null) {
                //           await _startBackgroundTask(context, selectedDevice);
                //           setState(() {
                //             /* Update for `_collectingTask.inProgress` */
                //           });
                //         }
                //       }
                //     },
                //   ),
                // ),
                // ListTile(
                //   title: ElevatedButton(
                //     child: const Text('View background collected data'),
                //     onPressed: (_collectingTask != null)
                //         ? () {
                //             Navigator.of(context).push(
                //               MaterialPageRoute(
                //                 builder: (context) {
                //                   return ScopedModel<BackgroundCollectingTask>(
                //                     model: _collectingTask!,
                //                     child: BackgroundCollectedPage(),
                //                   );
                //                 },
                //               ),
                //             );
                //           }
                //         : null,
                //   ),
                // ),
              ],
            ),
          );
  }
}