import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking/JSON/Parking.dart';
import 'package:parking/JSON/Users.dart';
import 'package:parking/components/Button.dart';
import 'package:parking/components/Colors.dart';
import 'package:parking/components/Textfield.dart';
import 'package:parking/view/Perfil.dart';
import 'package:parking/view/ScreenLoginState.dart';
import 'package:parking/view/SelectActionState.dart';

import '../database/Database_user.dart';

class IncomeCarState extends StatefulWidget {
  final Users usr; // Marked as required to ensure we have user information
  IncomeCarState({super.key, required this.usr});

  @override
  State<IncomeCarState> createState() => _IncomeCarStateState();
}

class _IncomeCarStateState extends State<IncomeCarState> {
  final placa = TextEditingController();
  final propietario = TextEditingController();
  final modelo = TextEditingController();
  final color = TextEditingController();
  File? _image;

  final db = DatabaseUsuario();

  Future<void> Parquear() async {
  if (placa.text.isEmpty || propietario.text.isEmpty || modelo.text.isEmpty || color.text.isEmpty || _image == null) {
    _showErrorSnackBar('Por favor, revisa que los campos estén llenos');
    return;
  }

  try {
    Uint8List imageBytes = await _image!.readAsBytes();
    String base64Image = base64Encode(imageBytes); // Convertir a base64

    var res = await db.createParking(
      Parking(
        placa: placa.text,
        propietario: propietario.text,
        modelo: modelo.text,
        color: color.text,
        imagen: base64Image, // Usar la cadena base64
      ),
      widget.usr.userId,
    );

    if (res > 0) {
      if (!mounted) return;
      _showConfirmationDialog(context, widget.usr);
    }
  } catch (e) {
    print("Error al procesar la imagen: $e");
    _showErrorSnackBar('Error al procesar la imagen');
  }
}


 Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print("Imagen seleccionada: ${_image!.path}");
    } else {
      print('No image selected.');
    }
  });
}

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _NameParking(),
                    SizedBox(height: 20),
                    TextFieldContent(
                      controller: placa,
                      hint: "Placa del vehículo",
                      icon: Icons.abc,
                    ),
                    TextFieldContent(
                      controller: propietario,
                      hint: "Propietario del vehículo",
                      icon: Icons.person,
                    ),
                    TextFieldContent(
                      controller: modelo,
                      hint: "Modelo del vehículo",
                      icon: Icons.ac_unit,
                    ),
                    TextFieldContent(
                      controller: color,
                      hint: "Color del vehículo",
                      icon: Icons.color_lens,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _image == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.grey,
                            )
                          : Image.file(
                              _image!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(height: 40),
                    ButtonContent(
                      label: "Guardar",
                      press: () {
                        Parquear();
                      },
                    ),
                    Text(
                      "Verifique que toda la información sea correcta",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NameParking extends StatelessWidget {
  _NameParking();

  @override
  Widget build(BuildContext context) {
    return Container(
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
        "PARKING",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w300,
          color: ColorText,
        ),
      ),
    );
  }
}

Future<bool?> _showConfirmationDialog(BuildContext context, Users usr) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Ingreso de vehículo"),
        content: Text("Vehículo registrado"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SelectActionState(usr: usr)),
              );
            },
            child: Text("Aceptar"),
          ),
        ],
      );
    },
  );
}

void _onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil()),
      );
      break;
    case 1:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScreenLoginState()),
      );
      break;
  }
}
