import 'package:flutter/material.dart';

class RoundCard extends StatelessWidget {
  const RoundCard({super.key, this.margin, this.padding, required this.child, this.color, this.isGradient=false, this.sidecolor});
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget child;
  final Color? color;
  final bool isGradient;
  final Color? sidecolor;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: margin??const EdgeInsets.all(16),
      padding: padding??const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient:isGradient?LinearGradient(colors: [
          Colors.white,
          Colors.blue[100]!,
     
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
        ):null,
        borderRadius: BorderRadius.circular(8)
      ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.blue.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color:sidecolor?.withOpacity(0.4)?? Colors.blue.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 60
                  )
                ]
              ),
            )),
            child,
          ],
        ),
    );
  }
}