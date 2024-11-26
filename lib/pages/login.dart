import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:casaproy/pages/services/firebase_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  List<List<String>> usuariosdb = []; 

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  Future<void> fetchUsuarios() async {
    try {
      var usuarios = await getUsuarios();
      setState(() {
        usuariosdb = usuarios.map<List<String>>((doc) {
          return [doc['name'], doc['password']];
        }).toList();
      });
    } catch (e) {
      print("Error al cargar usuarios: $e");
    }
  }

  void login(BuildContext context) {
    String username = userController.text;
    String password = passController.text;

    bool isValid = usuariosdb.any((user) =>
        user[0] == username.trim() && user[1] == password.trim());

    if (isValid) {
      context.push('/house');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Usuario o contraseña incorrectos"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xffDFF2EB),
              Color(0xffB9E5E8),
              Color(0xff7AB2D3),
              Color(0xff4A628A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.cottage,
                  size: 100,
                  color: Color(0xff001F3F),
                ),
                const SizedBox(height: 60),
                const Text(
                  'BIENVENIDO USUARIO!',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xff001F3F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Inicie sesión para controlar su casa inteligente',
                  style: TextStyle(fontSize: 18, color: Color(0xff3A6D8C)),
                ),
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: userController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Usuario',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: passController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Contraseña',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                  child: GestureDetector(
                    onTap: () => login(context),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff133E87),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
