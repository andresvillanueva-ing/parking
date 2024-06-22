import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:parking/JSON/Parking.dart';
import 'package:parking/JSON/Users.dart';
import 'package:parking/components/Button.dart';
import 'package:parking/components/Colors.dart';
import 'package:parking/view/Perfil.dart';
import 'package:parking/view/ScreenLoginState.dart';
import '../database/Database_user.dart';

class ExitCarState extends StatefulWidget {
  final Users usr;
  ExitCarState({Key? key, required this.usr}) : super(key: key);

  @override
  State<ExitCarState> createState() => _ExitCarStateState();
}

class _ExitCarStateState extends State<ExitCarState> {
  final placaController = TextEditingController();
  Parking? foundCar;
  final db = DatabaseUsuario();

  searchCar() async {
    var car = await db.getParking(placaController.text, widget.usr.userId);
    if (car != null) {
      setState(() {
        foundCar = car;
      });
    } else {
      _showConfirmationDialog(context, "No se encontró el vehículo.");
    }
  }

  salida() async {
    if (foundCar != null) {
      await db.deleteParking(foundCar!.placa, widget.usr.userId);
      setState(() {
        foundCar = null;
      });
    }
  }

  Future<void> _showConfirmationDialog2(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de que desea eliminar el carro de la base de datos?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Sí'),
              onPressed: () {
                salida();
                Navigator.of(context).pop(); // Cierra el diálogo de confirmación
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de confirmación
              },
            ),
          ],
        );
      },
    );
  }

  void cleanText() {
    placaController.clear();
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
                    TextField(
                      controller: placaController,
                      decoration: InputDecoration(
                        labelText: "Introduzca la placa del vehículo",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ButtonContent(label: "Buscar", press: () {
                      searchCar();
                      cleanText();
                    }),
                    SizedBox(height: 20),
                    foundCar != null
                        ? Column(
                            children: [
                              _buildCarImage(foundCar?.imagen),
                              ListTile(
                                leading: const Icon(Icons.person),
                                subtitle: const Text("Propietario"),
                                title: Text("${foundCar!.propietario}"),
                              ),
                              ListTile(
                                leading: const Icon(Icons.ac_unit),
                                subtitle: const Text("Modelo"),
                                title: Text("${foundCar!.modelo}"),
                              ),
                              ListTile(
                                leading: const Icon(Icons.color_lens),
                                subtitle: const Text("Color"),
                                title: Text("${foundCar!.color}"),
                              ),
                              ButtonContent(
                                label: "Salida",
                                press: () {
                                  _showConfirmationDialog2(context);
                                  cleanText();
                                },
                              ),
                            ],
                          )
                        : Text("Salida de autos."),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

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

  Widget _buildCarImage(String? base64Image) {
    if (base64Image == null || base64Image.isEmpty) {
      return Text("No hay imagen disponible");
    }

    try {
      Uint8List imageBytes = base64Decode(base64Image);
      return Image.memory(
        imageBytes,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print("Error al decodificar la imagen: $e");
      return Text("Error al mostrar la imagen");
    }
  }
}

class _NameParking extends StatelessWidget {
  const _NameParking();

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

Future<void> _showConfirmationDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Información"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Aceptar"),
          ),
        ],
      );
    },
  );
}
