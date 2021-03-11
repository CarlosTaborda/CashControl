import 'package:flutter/material.dart';
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
        body: Center(
          child: Text("Settings",style: TextStyle(color:Colors.white),),
        ),
      ),
    );
  }
}