import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json&key=SUA-CHAVE=db089e24";
void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.blue, primaryColor: Colors.white)));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final bitcoinController = TextEditingController();

  double dollar;
  double euro;
  double bitcoin;

  void _realChanged(String text) {
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    bitcoinController.text = (real/bitcoin).toStringAsFixed(5);
  }

  void _dollarChanged(String text) {
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar/euro).toStringAsFixed(2);
    bitcoinController.text = (dollar * this.dollar/bitcoin).toStringAsFixed(5);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro/dollar).toStringAsFixed(2);
    bitcoinController.text = (euro * this.euro/bitcoin).toStringAsFixed(5);
  }

  void _bitcoinChanged(String text) {
    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin/euro).toStringAsFixed(2);
    dollarController.text = (bitcoin * this.bitcoin/dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conver\$or \$",style: TextStyle(fontSize: 30.0),),
          backgroundColor: Colors.blue,
          centerTitle: true,
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
                      style: TextStyle(color: Colors.blue, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao Carregando Dados :(",
                        style: TextStyle(color: Colors.blue, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dollar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin =
                        snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.blue),
                          buildTextField(
                              "Real", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField(
                              "Dólar", "U\$", dollarController, _dollarChanged),
                          Divider(),
                          buildTextField(
                              "Euro", "€", euroController, _euroChanged),
                          Divider(),
                          buildTextField("Bitcoin", "฿", bitcoinController,
                              _bitcoinChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.blue, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
