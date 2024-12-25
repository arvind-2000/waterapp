import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:waterapp/controller/bluetoothcontroller.dart';
import 'package:waterapp/usecase/calc.dart';
import 'package:waterapp/widgets/liquidindicatorpage.dart';

import '../widgets/roundcard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.isConnected, this.device, required this.sendMessage, this.value, required this.sendMessageController, required this.sendMessageHighController});
  final bool isConnected;
  final BluetoothDevice? device;
  final Function(String,String,Function(String) function) sendMessage;
  final String? value;  
  final TextEditingController sendMessageController;
  final TextEditingController sendMessageHighController;
  @override
  Widget build(BuildContext context) {

    return GetBuilder<BluetoothController>(
      builder: (bluectrl) {
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
                    const SizedBox(height: 100,),
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
                    RoundCard(child: ListTile(
                      leading: Icon(Icons.line_axis),
                        title: Text("Water Level",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                        subtitle: Text(checkLevels(bluectrl.high??0,bluectrl.low??0, double.tryParse(value??"0")??0)),
                    ),),
                        RoundCard(child: ListTile(
                  
                        title:  Text("Low ${bluectrl.low??""} cm",style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child:TextFormField(
                                decoration: InputDecoration(
                                  
                                  hintText: "Set Low",
                                  hintStyle: TextStyle(color: Colors.grey[600])
                                ),
                                onFieldSubmitted: (v){
                                     if(v.isNotEmpty && v.isNum ){
                                sendMessage("{\"low\":$v}",v,(data)async{
                                  print("in function call preference:$v ");
                               await   bluectrl.setValues("low", double.tryParse(data)??0);
                                });
                              }else{
                                if(!v.isNum){

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Must be a number")));
                                }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fields are empty.")));

                                }
                              }
                                },
                                controller: sendMessageController,
                              
                              ),
                            
                            ),
                            IconButton.outlined(onPressed: (){
                              if(sendMessageController.text.isNotEmpty && sendMessageController.text.isNum){
                                    sendMessage("{\"low\":${sendMessageController.text}}",sendMessageController.text,(data)async{
                                  await bluectrl.setValues("low", double.tryParse(data)??0);
                                });
                              }else{
                                if(!sendMessageController.text.isNum){

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Must be a number")));
                                }else{

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fields are empty.")));
                                }
                              }
                            }, icon: const Icon(Icons.send))
                          ],
                        ),
                    ),),
                        RoundCard(child: ListTile(
                  
                        title:  Text("High ${bluectrl.high??"0.0"} cm",style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child:TextFormField(
                                decoration: InputDecoration(
                                  
                                  hintText: "Set High",
                                  hintStyle: TextStyle(color: Colors.grey[600])
                                ),
                                onFieldSubmitted: (v){
                                     if(v.isNotEmpty && v.isNum ){
                                sendMessage("{\"high\":$v}",v,(data)async{
                                  print("in function call preference:$v ");
                               await   bluectrl.setValues("high", double.tryParse(data)??0);
                                });
                              }else{
                                if(!v.isNum){

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Must be a number")));
                                }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fields are empty.")));

                                }
                              }
                                },
                                controller: sendMessageHighController,
                              
                              ),
                            
                            ),
                            IconButton.outlined(onPressed: (){
                              if(sendMessageHighController.text.isNotEmpty && sendMessageHighController.text.isNum){
                                    sendMessage("{\"high\":${sendMessageHighController.text}}",sendMessageHighController.text,(data)async{
                                  await bluectrl.setValues("high", double.tryParse(data)??0);
                                });
                              }else{
                                if(!sendMessageHighController.text.isNum){

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Must be a number")));
                                }else{

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fields are empty.")));
                                }
                              }
                            }, icon: const Icon(Icons.send))
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
    );
  }
}