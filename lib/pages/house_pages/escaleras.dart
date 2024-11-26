import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Escaleras extends StatefulWidget {
  const Escaleras({super.key});

  @override
  State<Escaleras> createState() => _EscalerasState();
}

class _EscalerasState extends State<Escaleras> {
  bool lightState = false;
final String esp32Url = 'http://192.168.137.47';  
 // Reemplaza con la IP de tu ESP32

  // Método para enviar la solicitud al ESP32
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
        backgroundColor: Colors.grey,
      ),
      backgroundColor: Colors.grey,
      body: body(),
    );
  }

  Widget body() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("CASA IOT", style: GoogleFonts.oswald(color: Colors.white, fontSize: 30)),
                  Text("Bienvenido", style: GoogleFonts.oswald(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
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
                      'location': 'stairs',
                      'state': value ? 'on' : 'off',
                      'ledStart': '2',
                      'ledCount': '3',
                      'action': 'luz',
                    });
                  },
                ),
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
