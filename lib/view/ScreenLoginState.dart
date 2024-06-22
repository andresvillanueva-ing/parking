import 'package:flutter/material.dart';
import 'package:parking/JSON/Users.dart';
import 'package:parking/components/Button.dart';
import 'package:parking/components/Colors.dart';
import 'package:parking/components/TextField.dart';
import 'package:parking/database/Database_user.dart';
import 'package:parking/view/ScreenSignupState.dart';
import 'package:parking/view/SelectActionState.dart';


class ScreenLoginState extends StatefulWidget {
  const ScreenLoginState({super.key});

  @override
  State<ScreenLoginState> createState() => _ScreenLoginStateState();
}

class _ScreenLoginStateState extends State<ScreenLoginState> {
  final users = TextEditingController();
  final Password = TextEditingController();
  bool isCheckd = false;
  bool isLoginTrue = false;

  final db = DatabaseUsuario();

  Login() async {
    // Obtener el objeto Users completo de la base de datos usando el nombre de usuario
    Users? userDetails = await db.getUser(users.text);

    if (userDetails != null) {
      // Autenticar al usuario usando el objeto Users recuperado de la base de datos
      var res = await db.autenticar(userDetails);

      if (res == true) {
        // El usuario fue autenticado correctamente, navega a la pantalla de perfil
        if (!mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => SelectActionState(usr:  userDetails,))));
      } else {
        // La autenticación falló
        _showSnackbar('Usuario o contraseña incorrectos');
      }
    } else {
      // El usuario no fue encontrado en la base de datos
      _showSnackbar('Usuario o contraseña incorrectos');
    }
  }


  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void cleanTextField(){
    users.clear();
    Password.clear();
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 20.0),
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

                      SizedBox(height: 20),

                      //texto
                      Text(
                        "Inicia sesion",
                        style: TextStyle(
                            color: ColorText,
                            fontSize: 34,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 40),

                      TextFieldContent(
                          controller: users,
                          hint: "usuario",
                          icon: Icons.account_circle),
                      TextFieldContent(
                        controller: Password,
                        hint: "contraseña",
                        icon: Icons.lock,
                        passwordVisible: true,
                      ),
                      
                      SizedBox(height: 60),
                      ListTile(
                        horizontalTitleGap: 2,
                        title: Text("Remember me"),
                        leading: Checkbox(
                            activeColor: ColorPrimary,
                            value: isCheckd,
                            onChanged: (value) {
                              setState(() {
                                isCheckd = !isCheckd;
                              });
                            }),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.0),
                        child: ButtonContent(
                            label: "Iniciar Session", press: () {Login(); cleanTextField();}),
                      ),
                      TextButton(
                          child: Text("¿Olvidaste la contraseña?"),
                          onPressed: () {}),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                           "¿No cuentas con un usuario?",
                            style: TextStyle(color: Colors.grey),
                             ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ScreenSignupState()));
                            },
                            child: Text("SIGN UP")),
                ],
              ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



