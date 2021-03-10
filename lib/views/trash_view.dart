import 'package:flutter/material.dart';
import 'appbar_view.dart';

class TrashView extends StatefulWidget {


  @override
  _TrashViewState createState() => _TrashViewState();
}

class _TrashViewState extends State<TrashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuApp(),
      body: Scaffold(
        body: Text("trash"),
      ),
    );
  }
}