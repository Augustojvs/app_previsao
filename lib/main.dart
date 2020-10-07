import 'dart:convert';

import 'package:app_previsao/componentes/componentes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController txtCity = TextEditingController();
  GlobalKey<FormState> cForm = GlobalKey<FormState>();
  String temperatura="Temperatura: ";
  String descricao="Descrição: ";
  String cidade="Cidade: ";
  String velocidadeVento="Velocidade do vento: ";
  String humidade="Humidade do ar: ";
  String consulta="Consultado em: ";
  String valueTemp = "";
  String valueDesc = "";
  String valueCity = "";
  String valueVel = "";
  String valueHum = "";
  String valueConsulta = "";

  Function validaCidade = ((value){
    if(value.isEmpty){
      return "Cidade inválida";
    }
    return null;
  });

  clicouBotao() async{
    if(!cForm.currentState.validate())
      return;
    String url = "https://api.hgbrasil.com/weather?key=1f4f5971&city_name=${txtCity.text}";
    Response resposta = await get(url);
    Map data = json.decode(resposta.body);
    // print(data["results"]["forecast"]);
    setState(() {
      valueTemp = '${data["results"]["temp"]}ºC';
      valueDesc = data["results"]["description"];
      valueCity = data["results"]["city"];
      valueVel = data["results"]["wind_speedy"];
      valueHum = '${data["results"]["humidity"]}%';
      valueConsulta = data["results"]["date"] +' às '+ data["results"]["time"];
      // List lista = data["results"]["forecast"];
      // for (int i = 0; i < lista.length; i++){
      //   // print();
      //   String dia = lista[i]['weekday'];
      //   String max = lista[i]['max'];
      //   String min = lista[i]['min'];
      //   String desc = lista[i]['description'];
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: cForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top:20),
                child: Image.asset(
                  "assets/imgs/logo.jpg",
                  fit: BoxFit.contain,
                ),
              ),
              Componentes.caixaDeTexto("Cidade", "Digite o nome de uma cidade", txtCity, validaCidade),
              Container(
                alignment: Alignment.center,
                height: 100,
                child:  IconButton(
                  onPressed: clicouBotao,
                  icon: FaIcon(FontAwesomeIcons.search, size: 50,color: Colors.blue,),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Componentes.rotulo(temperatura + valueTemp),
                    Componentes.rotulo(descricao + valueDesc),
                    Componentes.rotulo(cidade + valueCity),
                    Componentes.rotulo(velocidadeVento + valueVel),
                    Componentes.rotulo(humidade + valueHum),
                    Componentes.rotulo(consulta + valueConsulta),
                  ],
                ),
              ),
              // DataTable(
              //   columns: [
              //     DataColumn(label: Text('Dia')),
              //     DataColumn(label: Text('Max')),
              //     DataColumn(label: Text('Min')),
              //     DataColumn(label: Text('Descrição')),
              //   ],
              //   rows: [
              //       DataRow(cells: [
              //         DataCell(Text('teste1')),
              //         DataCell(Text('teste2')),
              //         DataCell(Text('teste3')),
              //         DataCell(Text('teste4')),
              //       ]),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}