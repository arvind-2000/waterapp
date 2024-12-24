import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:waterapp/widgets/liquidindicatorpage.dart';

import '../widgets/roundcard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.isConnected, this.device, required this.sendMessage, this.value, required this.sendMessageController});
  final bool isConnected;
  final BluetoothDevice? device;
  final Function(String) sendMessage;
  final String? value;  
  final TextEditingController sendMessageController;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
          Colors.blue[800]!,
          Colors.blue[300]!,
          Colors.blue[900]!
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
          )
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                       
                // Card(
                  
                //   child:Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: isConnected? Text("Connected: ${device?.name??""}",):Text("Disconnected :${device?.name??""}"),
                //   )),
                SizedBox(height: 100,),
                Center(child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400
                  ),
                  child: SizedBox(
                    height: 300,
                    width:300,
                    child: Container(
                      margin: const EdgeInsets.all(32),
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       boxShadow: 
                       [
                         BoxShadow(
                           blurRadius: 10,
                           spreadRadius: 6,
                           blurStyle: BlurStyle.normal,
                           offset: const Offset(0, 0),
                           color: Colors.black.withOpacity(0.3)
                           
                         ),
                                   BoxShadow(
                           blurRadius: 10,
                           spreadRadius: 6,
                           blurStyle: BlurStyle.solid,
                           offset: const Offset(0, 0),
                           color: Colors.white.withOpacity(0.5)
                           
                         )
                       ]
                     ),
                      
                      child:  WaterIndicatorPage(value: double.tryParse(value??"0")??0,)),
                  ),
                )),
                  
                const RoundCard(child: ListTile(
                  leading: Icon(Icons.line_axis),
                    title: Text("Water Level",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    subtitle: Text("Normal"),
                ),),
                    RoundCard(child: ListTile(
              
                    title: Text("Send Values",style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              hintText: "Type Here",
                              hintStyle: TextStyle(color: Colors.grey[600])
                            ),
                            onFieldSubmitted: (v){
                                 if(v.isNotEmpty){
                            sendMessage(v);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Values ")));
                          }
                            },
                            controller: sendMessageController,
                          
                          ),
                        
                        ),
                        IconButton.outlined(onPressed: (){
                          if(sendMessageController.text.isNotEmpty){
                            sendMessage(sendMessageController.text);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Values ")));
                          }
                        }, icon: Icon(Icons.send))
                      ],
                    ),
                ),),
                          
                   
              ],
            ),
          ),
        ),
      ),
    );
  }
}