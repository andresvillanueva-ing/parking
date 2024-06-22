import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:parking/JSON/Parking.dart';
import 'package:parking/components/Colors.dart';
import 'package:parking/database/Database_user.dart';
import 'package:parking/view/Perfil.dart';
import 'package:parking/view/ScreenLoginState.dart';

class ViewParking extends StatefulWidget {
  final int userId;
  const ViewParking({super.key, required this.userId});

  @override
  State<ViewParking> createState() => _ViewParkingState();
}

class _ViewParkingState extends State<ViewParking> {
  final db = DatabaseUsuario();
  List<Parking> parkingData = [];

  @override
  void initState() {
    super.initState();
    _fetchParkingData();
  }

  void salida(int index) async {
    Parking prk = parkingData[index];
    await db.deleteParking(prk.placa, widget.userId);
    setState(() {
      parkingData.removeAt(index); // Elimina el elemento de la lista en el índice dado
    });
  }

  Future<void> _showConfirmationDialog(BuildContext context, int index) async {
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
                salida(index);
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

  Future<void> _fetchParkingData() async {
    List<Parking> data = await db.getParkingData(widget.userId);
    setState(() {
      parkingData = data;
    });
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NameParking(),
                SizedBox(height: 40),
                SingleChildScrollView(
                  child: Container(
                    width: 350,
                    height: 600,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.transparent.withOpacity(0.5),
                    ),
                    child: _buildParkingList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
Widget _buildParkingList() {
  if (parkingData.isEmpty) {
    
    return Center(child: CircularProgressIndicator());
  }
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Borde redondeado
      color: Colors.transparent, // Fondo transparente
    ),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: parkingData.length,
      itemBuilder: (context, index) {
        Parking parking = parkingData[index];
        Uint8List? imageBytes;
        bool validImage = true;

        try {
          if (parking.imagen != null && parking.imagen!.isNotEmpty) {
            imageBytes = base64Decode(parking.imagen!);
          } else {
            validImage = false;
          }
        } catch (e) {
          validImage = false;
          print("Error al decodificar la imagen: $e");
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo del contenedor
              borderRadius: BorderRadius.circular(10), // Borde redondeado del contenedor
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Cambia la posición de la sombra
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                validImage
                    ? Image.memory(
                        imageBytes!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                        child: Icon(Icons.error, color: Colors.white),
                      ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Placa: ${parking.placa}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Propietario: ${parking.propietario}'),
                      Text('Modelo: ${parking.modelo}'),
                      Text('Color: ${parking.color}'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showConfirmationDialog(context, index);
                  },
                  child: Text(
                    "Salida",
                    style: TextStyle(color: ColorText),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
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
        "Parking",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w300,
          color: ColorText,
        ),
      ),
    );
  }
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
