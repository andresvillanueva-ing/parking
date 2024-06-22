import 'package:flutter/material.dart';
import 'package:parking/JSON/Users.dart';
import 'package:parking/components/Button.dart';
import 'package:parking/components/Colors.dart';
import 'package:parking/components/TextField.dart';
import 'package:parking/database/Database_user.dart';
import 'package:parking/view/ScreenLoginState.dart';


class ScreenSignupState extends StatefulWidget {
  const ScreenSignupState({super.key});

  @override
  State<ScreenSignupState> createState() => _ScreenSignupStateState();
}

class _ScreenSignupStateState extends State<ScreenSignupState> {

  final FullName = TextEditingController();
  final Parking = TextEditingController();
  final Usuario = TextEditingController();
  final Password = TextEditingController();
  

  final db = DatabaseUsuario();

  signup() async{
    var res = await db.createUser(Users(fullName: FullName.text, parking: Parking.text, userName: Usuario.text, password: Password.text));
    if (res>0) {
      if (!mounted) return;
        _showConfirmationDialog(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/fondo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // contenido de arriba.
          // cuadro "Parking"
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //texto
                    Text(
                      "Registrarse",
                      style: TextStyle(
                        color: ColorText,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFieldContent(controller: FullName, hint: "Nombre Completo", icon: Icons.person),
                    TextFieldContent(controller: Parking, hint: "Nombre del parqueadero", icon: Icons.car_crash),
                    TextFieldContent(controller: Usuario, hint: "usuario", icon: Icons.account_circle),
                    TextFieldContent(controller: Password, hint: "contraseña", icon: Icons.lock, passwordVisible: true),

                    SizedBox(height: 60),
                    

                    ButtonContent(label: "Registrarse", press: () {signup();}),
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

Future<bool?> _showConfirmationDialog(BuildContext context ) async{
  return showDialog<bool>(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: Text("Registro de usuario"),
        content: Text("Su usuario ha sido registrado!!"),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ScreenLoginState()));
          }, child: Text("Aceptar")),
        ],
      );
    }
    );
}
