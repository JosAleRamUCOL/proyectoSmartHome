import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Bath extends StatefulWidget {
  const Bath({super.key});

  @override
  State<Bath> createState() => _BathState();
}

class _BathState extends State<Bath> {
  bool lightState = false;
  bool windowState = false;
  bool flush = false;

  final String esp32Url =
      'http://192.168.137.47'; // Reemplaza con la IP de tu ESP32

  Future<void> sendRequest(String endpoint, Map<String, String> params) async {
    final queryString = Uri(queryParameters: params).query;
    final url = Uri.parse('$esp32Url/$endpoint?$queryString');
    try { 
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Solicitud exitosa: $url');
      } else {
        print('Error en la respuesta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectar con el ESP32: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue,
      body: body(),
    );
  }

  Widget body() {
    return Container(
      color: Colors.blue[100],
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("CASA IOT",
                      style: GoogleFonts.oswald(
                          color: Colors.white, fontSize: 30)),
                  Text("Bienvenido",
                      style: GoogleFonts.oswald(
                          color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                      leading: Icon(Icons.light),
                      title: Text(lightState ? "Luz Encendida" : "Luz Apagada"),
                      trailing: Switch(
                        value: lightState,
                        onChanged: (value) {
                          setState(() {
                            lightState = value;
                          });
                          sendRequest('control', {
                            'location': 'bath',
                            'state': value ? 'on' : 'off',
                            'ledStart': '4',
                            'ledCount': '5',
                            'action': 'luz',
                            
                          });
                        },
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.window),
                    title:
                        Text(windowState ? "Abrir Ventana" : "Cerrar Ventana"),
                    onTap: () {
                      setState(() {
                        windowState = !windowState;
                      });
                      sendRequest('control', {
                        'location': 'bath',
                        'state': windowState ? 'on' : 'off',
                        'action': 'servo',
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.wc),
                    title: Text(flush ? "Inodoro Activado" : "Vaciar Inodoro"),
                    onTap: () {
                      setState(() {
                        flush = !flush;
                      });
                      sendRequest('control', {
                        'location': 'bath',
                        'state': flush ? 'on' : 'off',
                        'action': 'ledS',
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
