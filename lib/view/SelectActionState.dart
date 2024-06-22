import 'package:flutter/material.dart';
import 'package:parking/components/Button.dart';
import 'package:parking/components/Colors.dart';
import 'package:parking/view/ExitCarState.dart';
import 'package:parking/view/IncomeCarState.dart';
import 'package:parking/view/Perfil.dart';
import 'package:parking/view/ScreenLoginState.dart';
import 'package:parking/view/ViewParkingState.dart';
import 'package:parking/JSON/Users.dart'; // Make sure to import the Users model

class SelectActionState extends StatefulWidget {
  final Users usr; // Add the Users parameter

  const SelectActionState({super.key,  required this.usr}); // Make it required

  @override
  State<SelectActionState> createState() => _SelectActionStateState();
}

class _SelectActionStateState extends State<SelectActionState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: Icon(Icons.account_circle),
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: <Widget>[Text("Ver perfil")],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: <Widget>[Text("Cerrar sesión")],
                ),
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asset/fondo.png"),
                fit: BoxFit.cover
              )
            )
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Contenedor Parking 
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 5),
                          ),
                        ],
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: Text(
                        "Parking",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300,
                          color: ColorText,
                        ),
                      ),
                    ),
                    // Botones de acción
                    SizedBox(height: 40),
                    ButtonContent(label: "Entrada de carro", press: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeCarState(usr: widget.usr))); // Pass the user
                    }),
                    ButtonContent(label: "Salida de carro", press: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ExitCarState(usr: widget.usr)));
                    }),
                    ButtonContent(label: "Carros parqueados", press: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewParking(userId: widget.usr.userId)));
                    }),
                  ],
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}

// Acciones del botón de perfil
void _onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()));
      break;
    case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenLoginState()));
      break;
  }
}
