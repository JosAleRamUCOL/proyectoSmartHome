import 'package:go_router/go_router.dart';  
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Cuarto extends StatefulWidget {
  const Cuarto({super.key});

  @override
  State<Cuarto> createState() => _CuartoState();
}

class _CuartoState extends State<Cuarto> {
  bool lightState = false;
  bool fanState = false;
  bool alarm = false;
  double temperatura = 00.0;
  double humedad = 00.0;
  final String esp32Url = 'http://192.168.137.47'; // Cambia a la IP de tu ESP32

 Future<void> sendRequest(String endpoint, Map<String, String> params) async {
  final queryString = Uri(queryParameters: params).query;
  final url = Uri.parse('$esp32Url/$endpoint?$queryString');
  print('Enviando solicitud a: $url');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('Solicitud exitosa. Respuesta: ${response.body}');
    } else {
      print('Error en la respuesta del servidor: Código ${response.statusCode}');
    }
  } catch (e) {
    print('Error al conectar con el ESP32: $e');
  }
}

  


  
Future<void> fetchSensorData() async {
  try {
    final response = await http.get(Uri.parse('$esp32Url/sensors'));
    print('Respuesta del servidor: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperatura = data['temperature'] ?? 0.0;
        humedad = data['humidity'] ?? 0.0;
      });
    } else {
      print('Error en el servidor: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al obtener datos de sensores: $e');
  }
}
  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.green,
      body: body(),
    );
  }

  Widget body() {
    return Container(
      color: Colors.greenAccent[100],
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green,
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
                      'location': 'room',
                      'state': value ? 'on' : 'off',
                      'ledStart': '0',
                      'ledCount': '1',
                      'action' : 'luz',
                    });
                  },
                ),
              ),
            ),
          ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: Icon(Icons.heat_pump_outlined),
                    title: Text(fanState ? "Ventilador Encendido" : "Ventilador Apagado"),
                    trailing: Switch(
                      value: fanState,
                      onChanged: (value) {
                    setState(() {
                      fanState = value;
                    });
                    sendRequest('control', {
                      'location': 'room',
                      'state': fanState ? 'on' : 'off',
                      'action': 'fan',
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
                    leading: Icon(Icons.timer),
                    title: Text("Establecer Alarma"),
                    onTap: (){
                      context.go('/clock');
                     /* sendRequest('control', {
                        'location' : 'room',
                        'state' : alarm ? 'on'  : 'off',
                        'action' : 'alarma',

                      });*/
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: Icon(Icons.thermostat),
                    title: Text("Temperatura: $temperatura°C / Humedad: $humedad%"),
                    onTap: fetchSensorData,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
