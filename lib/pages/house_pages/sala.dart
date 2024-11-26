import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Sala extends StatefulWidget {
  const Sala({super.key});

  @override
  State<Sala> createState() => _SalaState();
}

class _SalaState extends State<Sala> {
  bool lightState = false;
  bool lightExState = false;
  bool doorState = false;
  bool tvState = false;
  bool alarmState = false;
  bool windowState = false;

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
        backgroundColor: Colors.brown,
      ),
      backgroundColor: Colors.brown,
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
                  color: Colors.brown,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(100),
                  )),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "CASA IOT",
                      style:
                          GoogleFonts.oswald(color: Colors.white, fontSize: 30),
                    ),
                    Text(
                      "Bienvenido",
                      style:
                          GoogleFonts.oswald(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
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
                          'location': 'livingroom',
                          'state': value ? 'on' : 'off',
                          'ledStart': '8',
                          'ledCount': '9',
                          'action': 'luzinterior',
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: Icon(Icons.door_front_door),
                    title: Text(doorState ? "Cerrar Puerta" : "Abrir Puerta"),
                    onTap: () {
                      setState(() {
                        doorState = !doorState;
                      });
                      sendRequest('control', {
                        'location': 'livingroom',
                        'state': doorState ? 'on' : 'off',
                        'action': 'puerta',
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: Icon(Icons.window),
                    title:
                        Text(windowState ? "Cerrar Ventana" : "Abrir Ventana"),
                    onTap: () {
                      setState(() {
                        windowState = !windowState;
                      });
                      sendRequest('control', {
                        'location': 'livingroom',
                        'state': windowState ? 'on' : 'off',
                        'action': 'servo_sala',
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: Icon(Icons.tv),
                    title: Text(tvState
                        ? "Televisión Encendida"
                        : "Televisión Apagada"),
                    trailing: Switch(
                        value: tvState,
                        onChanged: (value) {
                          setState(() {
                            tvState = value;
                          });
                          sendRequest('control', {
                            'location': 'livingroom',
                            'state': tvState ? 'on' : 'off',
                            'action': 'tv',
                          });

                          // sendRequest('servo?state=${value ? "on" : "off"}');
                        }),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: Icon(Icons.light),
                    title: Text(lightExState
                        ? "Luz Exterior Encendida"
                        : "Luz Exterior Apagada"),
                    trailing: Switch(
                      value: lightExState,
                      onChanged: (value) {
                        setState(() {
                          lightExState = value;
                        });
                        sendRequest('control', {
                          'location': 'livingroom',
                          'state': value ? 'on' : 'off',
                          'ledStart': '10',
                          'ledCount': '11',
                          'action': 'luzexterior',
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(
                        alarmState ? "Alarma Encendida" : "Alarma Apagada"),
                    trailing: Switch(
                        value: alarmState,
                        onChanged: (value) {
                          setState(() {
                            alarmState = value;
                          });
                          sendRequest('control', {
                        'location': 'livingroom',
                        'state': alarmState ? 'on' : 'off',
                        'action': 'alarma',
                        });
                        },
                    ),
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
