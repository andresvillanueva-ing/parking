import 'package:flutter/material.dart';
import 'package:parking/JSON/Users.dart';
import 'package:parking/components/Button.dart';
import 'package:parking/components/Colors.dart';
import 'package:parking/components/Textfield.dart';
import 'package:parking/database/Database_user.dart';
import 'package:parking/view/Perfil.dart';




class UpdateProfileScreen extends StatefulWidget {
  final Users? profile;
  UpdateProfileScreen({super.key, this.profile});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  String _password = "";
  final db = DatabaseUsuario();
  
  @override
  void initState() {
    super.initState();
    _LoadProfile();
    // No incluí la contraseña para no mostrarla en el campo de texto
  }
  
  _LoadProfile()async{
    
    final profile = await db.getUser(widget.profile!.userName);
    setState((){
      fullNameController.text = profile?.fullName ?? "";
      emailController.text = profile?.parking?? "";
      userNameController.text = profile?.userName ?? "";
    });
  }
  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Actualizar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Texto(),
              SizedBox(height: 20),
              TextFieldContent(
                hint: 'Nombre Completo',
                icon: Icons.person,
                controller: fullNameController,
              ),
              SizedBox(height: 10),
              TextFieldContent(
                hint: 'Nombre del Parqueadero',
                icon: Icons.email,
                controller: emailController,
              ),
              SizedBox(height: 10),
              TextFieldContent(
                hint: 'Nombre de Usuario',
                icon: Icons.account_circle,
                controller: userNameController,
              ),
              
              SizedBox(height: 20),
              ButtonContent(
                label: 'Actualizar',
                press: () {
                   showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("Introduzca su contraseña"),
                          content: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "password",
                              icon: Icon(Icons.lock),
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Cancelar"),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                onPressed: (){
                                  if (_password == widget.profile!.password) {
                                    _updateProfile();
                                  }else{
                                    SnackBar(
                                      content: Text("Contraseña incorrecta"),
                                      backgroundColor: Colors.red,
                                      );
                                  }
                                }, 
                                child: Text("Actualizar"),
                                )
                            ],
                        );
                      }
                      );
                                    
                },
              ),

              ButtonContent(label: "Cancelar", press: (){
                Navigator.pop(context);
              })
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    final DatabaseUsuario db = DatabaseUsuario();
    
    final updatedProfile = Users(
      userId: widget.profile!.userId,
      fullName: fullNameController.text,
      parking: emailController.text,
      userName: userNameController.text,
      password: widget.profile!.password,
    );
    await db.updateUser(updatedProfile);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  Perfil(profile: updatedProfile,))); // Regresar a la pantalla anterior después de actualizar
  }
}


class _Texto extends StatelessWidget {
  _Texto();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Actualizar los datos", style: TextStyle(color: ColorPrimary, fontSize: 35),),
    );
  }
}
