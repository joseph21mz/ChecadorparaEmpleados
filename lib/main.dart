import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:async'; // Asegúrate de importar esta librería



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checador para Empleados',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Checador para Empleados GasMaz, Cosisa, Tramasa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override

  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  String codigoEmpleado ='';
  TextEditingController _controller = TextEditingController(); // Declarar el controller
  Stream<DateTime> _clock() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  Future<String> registrarEntrada(codigoEmpleado) async {
    var url = Uri.parse('http://localhost:3000/api/registrarEntrada');
    var nombre ='';
    print("entrada $codigoEmpleado");
    // Datos que deseas enviar al servidor
    var data = {
      "iTipo": 1,
      "iGEEMCodigo": 8,
      "iGESUCodigo": 1,
      "iPEEMCodigo": codigoEmpleado,
      "iPEVATipo": 0,
      "iMant": 0
    };
     
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Datos enviados correctamente');
        print(response.body); // Si necesitas ver la respuesta del servidor
        var jsonResponse = json.decode(response.body);
        nombre = jsonResponse[0][0]['EMPLEADO_NOMBRE'];
        print(nombre);
      } else {
        print('Error al enviar datos: ${response.statusCode}');
        print(response.body); // Si necesitas ver la respuesta del servidor
      }
    } catch (error) {
      print('Error en la solicitud: $error');
    }
    return nombre; 
  }

  Future<String> registrarSalida(codigoEmpleado) async {
    var url = Uri.parse('http://localhost:3000/api/registrarSalida');
    var nombre ='';
    // Datos que deseas enviar al servidor
    var data = {
      "iTipo": 1,
      "iGEEMCodigo": 8,
      "iGESUCodigo": 1,
      "iPEEMCodigo": codigoEmpleado,
      "iPEVATipo": 0,
      "iMant": 0
    };

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Datos enviados correctamente');
        print(response.body); // Si necesitas ver la respuesta del servidor
        var jsonResponse = json.decode(response.body);
        nombre = jsonResponse[0][0]['EMPLEADO_NOMBRE'];
        print(nombre);
      } else {
        print('Error al enviar datos: ${response.statusCode}');
        print(response.body); // Si necesitas ver la respuesta del servidor
      }
    } catch (error) {
      print('Error en la solicitud: $error');
    }
    return nombre;
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(

          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hora actual:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              StreamBuilder<DateTime>(
                stream: _clock(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String formattedTime =
                        '${snapshot.data!.hour}:${snapshot.data!.minute}:${snapshot.data!.second}';
                    return Text(
                      formattedTime,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  if (codigoEmpleado.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Por favor, ingrese un número.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    String nombre = await registrarEntrada(codigoEmpleado);
                    print('ENTRO');
                    codigoEmpleado='';
                    if(nombre.isEmpty){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('ENTRADA'),
                            content: Text('El Número Ingresado no existe, favor de verificarlo'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Limpiar el contenido del TextField después de aceptar el diálogo
                                  _controller.clear();
                                },
                                child: Text('Aceptar'),

                              ),
                            ],
                          );
                        },
                      );

                    }else{
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('ENTRADA'),
                            content: Text('BIENVENIDO (A) $nombre'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Limpiar el contenido del TextField después de aceptar el diálogo
                                  _controller.clear();
                                },
                                child: Text('Aceptar'),

                              ),
                            ],
                          );
                        },
                      );
                    }

                  }
                },
                child: Text('ENTRADA'),
              ),

              SizedBox(height: 20), // Separación entre botones
              TextButton(
                 onPressed: ()  async {
                if (codigoEmpleado.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Por favor, ingrese un número.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _controller.clear();
                            },
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  String nombre = await registrarSalida(codigoEmpleado);
                  print('SALIO');
                  codigoEmpleado='';
                  if(nombre.isEmpty){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('SALIDA'),
                          content: Text('Número Ingresado no Existe, favor de verificarlo'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _controller.clear();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );

                  }else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('SALIDA'),
                          content: Text('QUE TE VAYA BIEN $nombre'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _controller.clear();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
                },
                child: Text('SALIDA'),
              ),
              TextField(
                controller: _controller, // Asignar el controlador al TextField
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    codigoEmpleado = value; // Actualiza el valor cada vez que cambia el TextField
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Ingrese su Código de Empleado',
                  border: OutlineInputBorder(),
                ),
              ),

            ],
          ),
        ),
      );
    }

}
