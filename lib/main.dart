import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/*
theme: ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
  )
)
*/

// minha chave site hgbrasil 15fcf390
const String urlHg = 'https://api.hgbrasil.com/finance?key=15fcf390';

void main() async {
  runApp(MaterialApp(
    title: 'IGS_Conversor de Moedas',
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.amber)))),
  ));
}

Future<Map> getData() async {
  // Map<String, dynamic> param = {
  //  'Access-Control-Allow-Origin': '*',
  //  'Access-Control-Allow-Credentials': true};
  //try {
    Response retorno = await Dio().get(urlHg,);
        // options: Options(
        //   contentType: 'multipart/form-data',
        //   responseType: ResponseType.json,
        //   headers: param
        // ));
    print('retornado = $retorno ');
    //print(retorno.data);
    return retorno.data;
    //http.Response retorno = await http.get(urlHg);
    //return json.decode(retorno.data);
  // } catch (err) {
  //   print(" >>>> response RECEBIDO: $err");
  //   Map<String, dynamic> mapa = {'erro': 'bye'};
  //   return mapa;
  // }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll() {
    realController.text = "";
    euroController.text = "";
    dolarController.text = "";
  }

  void _realMudou(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarMudou(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroMudou(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "\$ IGS => Meu Conversor Web \$",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );

              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar dados :(",
                      style: TextStyle(color: Colors.amber),
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber),
                        novoTextField(
                            "Reais", "R\$", realController, _realMudou),
                        Divider(),
                        novoTextField(
                            "Dolar", "US\$", dolarController, _dolarMudou),
                        Divider(),
                        novoTextField("Euro", "€", euroController, _euroMudou),
                        Divider(
                          height: 20,
                        ),
                        novoTextinho("Cotação Atual:"),
                        Divider(),
                        novoTextinho("Dólar: R\$: $dolar"),
                        novoTextinho("Euro: R\$: $euro"),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget novoTextinho(String textinho) {
  return Text(
    textinho,
    style: TextStyle(
        color: Colors.white, fontSize: 20.0, fontStyle: FontStyle.italic),
  );
}

Widget novoTextField(
    String label, String prefixo, TextEditingController cont, Function f) {
  return TextField(
    controller: cont,
    onChanged: f,
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: "$prefixo ",
      prefixStyle: TextStyle(color: Colors.amber, fontSize: 25.0),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
    ),
  );
}
