import 'package:flutter/material.dart';
import '../controllers/movement_controller.dart';
import '../models/database.dart';
import 'appbar_view.dart';

class TrashView extends StatefulWidget {


  @override
  _TrashViewState createState() => _TrashViewState();
}

class _TrashViewState extends State<TrashView> {
  final _mvtsCtrl = MovementController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuApp(),
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Papelera"),
        ),
        body: _listMovementsDisabled(),
      ),
    );
  }


  Widget _listMovementsDisabled(){

    return FutureBuilder(
      future: _mvtsCtrl.getMovementsDisabled(),
      builder: (context, snapshot){
        if( !snapshot.hasData)
          return Center( child: CircularProgressIndicator());
        
        return ListView(
          children: snapshot.data.map(( mf ){
            return ListTile(
              title: Text(mf.category.name),
            );
          }).toList(),
        );
      },
    );
  }
}