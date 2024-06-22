import 'package:flutter/material.dart';
import 'package:parking/components/Colors.dart';

class ButtonContent extends StatelessWidget {
  final String label;
  final VoidCallback press;
  const ButtonContent({super.key, required this.label, required this.press});

  @override
  Widget build(BuildContext context) {

    // Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // width: size.width *.9,
      width: 200,
      height: 55,
      decoration: BoxDecoration(
        color: ColorPrimary,
        borderRadius: BorderRadius.circular(50)
      ),

      child: TextButton(
        onPressed: press,
        child:Text(label, 
        style: TextStyle(color: Colors.white),
        ),

      ),
    );
  }
}