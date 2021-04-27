import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'appbar_view.dart';

class SettingsView extends StatefulWidget {


  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuApp(),
      body: Scaffold(
        appBar: AppBar(
          title: Text("Configuración"),
        ),
        body: Center(
          child: Container(
            width: Get.width *0.9,
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  Widget _getBody(){
    return ListView(
      children: [
        SizedBox(height: Get.height*0.35,),
        Text("En algun momento hare una sección de settings pero no tengo ni idea de que poner",style: TextStyle(color:Colors.white),),
        Center(
          child: IconButton(
            icon: Icon(Icons.power_settings_new_sharp),
            color: Colors.white70,
            iconSize: 50,
            onPressed: ()=>SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
        ),
        Center(child: Text("SALIR", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),),)
      ],
    );
  }
}