
import 'package:flutter/material.dart';
import 'package:parking/view/ScreenLoginState.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  get child => null;

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking App',
      home: ScreenLoginState()
    );
  }
}