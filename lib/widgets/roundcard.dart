import 'package:flutter/material.dart';

class RoundCard extends StatelessWidget {
  const RoundCard({super.key, this.margin, this.padding, required this.child, this.color, this.isGradient=false});
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget child;
  final Color? color;
  final bool isGradient;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: margin??const EdgeInsets.all(16),
      padding: padding??const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        gradient:isGradient?LinearGradient(colors: [
          Colors.grey[700]!,
          Colors.grey[900]!,
     
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
        ):null,
        borderRadius: BorderRadius.circular(8)
      ),
        child: child,
    );
  }
}