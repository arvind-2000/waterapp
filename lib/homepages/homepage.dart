import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:waterapp/widgets/liquidindicatorpage.dart';

import '../widgets/roundcard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.isConnected, this.device});
  final bool isConnected;
  final BluetoothDevice? device;
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  16.0,vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton.filled(onPressed: (){}, icon: const Icon(Icons.person),
                          
                          ),
                          
                          const SizedBox(width: 20,),
                          Text("Water Sense",style: Theme.of(context).textTheme.headlineMedium,),
                        ],
                      ),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.settings,color: Colors.white,))
                            
                  ],),
                ),
                Card(
                  
                  child:Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isConnected? Text("Connected: ${device?.name??""}",):Text("Disconnected :${device?.name??""}"),
                  )),
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
                      
                      child: const WaterIndicatorPage(value: 0.5,)),
                  ),
                )),
                  
                RoundCard(child: ListTile(
                  leading: Icon(Icons.line_axis),
                    title: Text("Water Level",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    subtitle: Text("Normal"),
                ),),

                          
                RoundCard(
                  sidecolor: Colors.yellow,
                  child: ListTile(
                  leading: Icon(Icons.line_axis),
                    title: Text("Hourly",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                    subtitle: SizedBox(height: 300,),
                ),),
                          
                RoundCard(child: ListTile(
                  leading: Icon(Icons.line_axis),
                    title: Text("Daily",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                     subtitle: SizedBox(height: 300,),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}