import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
// import 'package:mysql1/mysql1.dart';
import 'dart:async';

// import 'package:mysql_client/mysql_client.dart';

// import 'package:mysql1/mysql1.dart'; // Asegúrate de importar esta librería


String _host = '';

Future main() async {


  await dotenv.load();

  _host = dotenv.get('HOST');

  // String foo = dotenv.get('VAR_NAME');

  // // Or with fallback.
  // String bar = dotenv.get('MISSING_VAR_NAME', fallback: 'sane-default');

  // // This would return null.
  // String? baz = dotenv.maybeGet('MISSING_VAR_NAME', fallback: null);



  runApp(const MyApp());
}


// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final TextEditingController _controller = TextEditingController(); // Declarar el controller
  Stream<DateTime> _clock() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  Future<String> registrarEntrada(codigoEmpleado) async {
    // var url = Uri.parse('http://localhost:3000/api/registrarEntrada');
    var nombre ='';
    // print("entrada $codigoEmpleado");
    // // Datos que deseas enviar al servidor
    // var data = {
    //   "iTipo": 1,
    //   "iGEEMCodigo": 8,
    //   "iGESUCodigo": 1,
    //   "iPEEMCodigo": codigoEmpleado,
    //   "iPEVATipo": 0,
    //   "iMant": 0
    // };
     
    try {
      var response = await http.post(
        Uri.parse('http://facturacionpemex.dyndns.org/api/registrarentrada'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'PEEMCodigo': codigoEmpleado.toString(),
        },
      );

      if (response.statusCode == 201) {
        print('Datos enviados correctamente');
        print(response.body); // Si necesitas ver la respuesta del servidor
        var jsonResponse = json.decode(response.body);
        nombre = jsonResponse['EMPLEADO_NOMBRE'];
        // nombre = jsonResponse[0]['PEEMNombre'];
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
    // var url = Uri.parse('http://localhost:3000/api/registrarSalida');
    var nombre ='';
    // // Datos que deseas enviar al servidor
    // var data = {
    //   "iTipo": 1,
    //   "iGEEMCodigo": 8,
    //   "iGESUCodigo": 1,
    //   "iPEEMCodigo": codigoEmpleado,
    //   "iPEVATipo": 0,
    //   "iMant": 0
    // };

    try {
      // var response = await http.post(
      //   url,
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(data),
      // );

      var response = await http.post(
        Uri.parse('http://facturacionpemex.dyndns.org/api/registrarsalida'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'PEEMCodigo': codigoEmpleado.toString(),
        },
      );

      if (response.statusCode == 201) {
        print('Datos enviados correctamente');
        print(response.body); // Si necesitas ver la respuesta del servidor
        var jsonResponse = json.decode(response.body);
        nombre = jsonResponse['EMPLEADO_NOMBRE'];
        // nombre = jsonResponse[0]['PEEMNombre'];
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
          child: 
          Container(

            padding: const EdgeInsets.all(20),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // Text('Nombre del host: ${dotenv.get('HOST')}'),
              const Text(
                'Hora actual:',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<DateTime>(
                stream: _clock(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    String hora ='${snapshot.data!.hour}';
                    if( snapshot.data!.hour<10){
                      hora = '0${snapshot.data!.hour}';
                    }
                    String minuto ='${snapshot.data!.minute}';
                    if( snapshot.data!.minute<10){
                      minuto = '0${snapshot.data!.minute}';
                    }
                    String segundo ='${snapshot.data!.second}';
                    if( snapshot.data!.second<10){
                      segundo = '0${snapshot.data!.second}';
                    }
                    String formattedTime = '$hora:$minuto:$segundo';
                    return Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (codigoEmpleado.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Por favor, ingrese un número.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
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
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ENTRADA'),
                            content: const Text('El Número Ingresado no existe, favor de verificarlo'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Limpiar el contenido del TextField después de aceptar el diálogo
                                  _controller.clear();
                                },
                                child: const Text('Aceptar'),

                              ),
                            ],
                          );
                        },
                      );

                    }else{
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ENTRADA'),
                            content: Text('BIENVENIDO (A) $nombre'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Limpiar el contenido del TextField después de aceptar el diálogo
                                  _controller.clear();
                                },
                                child: const Text('Aceptar'),

                              ),
                            ],
                          );
                        },
                      );
                    }

                  }
                },
                child: const Text('ENTRADA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),

              const SizedBox(height: 20), // Separación entre botones
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: ()  async {
                    if (codigoEmpleado.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Por favor, ingrese un número.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _controller.clear();
                                },
                                child: const Text('Aceptar'),
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
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('SALIDA'),
                              content: const Text('Número Ingresado no Existe, favor de verificarlo'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _controller.clear();
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );

                      }else{
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('SALIDA'),
                              content: Text('QUE TE VAYA BIEN $nombre'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _controller.clear();
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text('  SALIDA  ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),

              ),

              const SizedBox(height: 20), // Separación entre botones
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
                decoration: const InputDecoration(
                  hintText: 'Ingrese su Código de Empleado',
                  border: OutlineInputBorder(),
                ),
              ),

            ],
          ),
        
            
          )
        
        ),
      );
    }

}
