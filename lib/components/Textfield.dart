import 'package:flutter/material.dart';

class TextFieldContent extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool passwordVisible;

  const TextFieldContent({super.key, required this.controller, required this.hint, required this.icon, this.passwordVisible = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: size.width *.9,
      height: 55,
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: passwordVisible,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            hintText: hint,
            icon: Icon(icon),
            filled: true,
            fillColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}