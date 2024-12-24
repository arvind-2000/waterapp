import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
class WaterIndicatorPage extends StatelessWidget {
  const WaterIndicatorPage({super.key, this.showIndicatorLevel =false, required this.value});
  final bool showIndicatorLevel;
  final double value;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,s) {
        return Stack(
          children: [
            Positioned.fill(
              child: LiquidCircularProgressIndicator(
                
                value:value<=0?0:value>100?1:value*0.01,
                valueColor:AlwaysStoppedAnimation(Colors.blue[500]!),
                backgroundColor: Colors.blue[100],
              
              ),
            ),
        
          showIndicatorLevel? Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 3,
                  margin: const EdgeInsets.only(left: 32),
                             height: double.infinity,
                  color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(
                  
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(width: 5,height: 0.5,color: Colors.white,),
                            const SizedBox(width: 10,),
                            const Text("100"),
                          ],
                        ),
                        SizedBox(height: s.maxHeight/20,),
                        const Text("80"),
                           SizedBox(height: s.maxHeight/20,),
                        const Text("60"),
                           SizedBox(height: s.maxHeight/10,),
                        const Text("50"),
                           SizedBox(height: s.maxHeight/10,),
                        const Text("40"),
                           SizedBox(height: s.maxHeight/20,),
                       
                        const Text("20"),
                           SizedBox(height: s.maxHeight/20,),
                        const Text("0"),
                     
                      ],
                    ),
                  )
                ],
              )):const SizedBox(),
        
               Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
              child: Text("$value cm",style: const TextStyle(color: Colors.white,fontSize: 40),
              ),
            ))
        
          ],
        );
      }
    );
  }
}