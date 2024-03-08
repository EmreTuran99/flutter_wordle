
import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
  
  final double width;
  const HorizontalSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width,
    );
  }
}