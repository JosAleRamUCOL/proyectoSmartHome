import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Cocina extends StatefulWidget {
  const Cocina({super.key});

  @override
  State<Cocina> createState() => _CocinaState();
}

class _CocinaState extends State<Cocina> {
  bool lightState = false;

  bool windowState = false;
  bool stoveState = false;

  final String esp32Url = 'http://192.168.137.47';

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
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: body(),
    );
  }

  Widget body() {
    return Container(
      color: Colors.red[50],
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red,
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
                      'location': 'kitchen',
                      'state': value ? 'on' : 'off',
                       'ledStart': '6',
                      'ledCount': '7',
                      'action': 'luz',
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.window),
                    title: Text(windowState ? "Cerrar Ventana" : "Abrir Ventana"),
                    onTap: () {
                      setState(() {
                        windowState = !windowState;
                      });
                      sendRequest('control', {
                      'location': 'kitchen',
                      'state': windowState ? 'on' : 'off',
                      'action': 'servo',
                      
                    });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.soup_kitchen),
                    title: Text(stoveState ? "Estufa Encendida" : "Estufa Apagada"),
                    trailing: Switch(
                      value: stoveState, 
                      onChanged: (value){
                        setState(() {
                          stoveState = value;
                        });
                        sendRequest('control', {
                          'location': 'kitchen',
                          'state': stoveState ? 'on' : 'off',
                          'action' : 'ledS',
                        });
                      }
                    ),
                   
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
