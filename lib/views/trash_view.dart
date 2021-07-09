import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controllers/movement_controller.dart';
import '../models/database.dart';
import 'appbar_view.dart';

class TrashView extends StatefulWidget {


  @override
  _TrashViewState createState() => _TrashViewState();
}

class _TrashViewState extends State<TrashView> {
  final _mvtsCtrl = MovementController();
  final _moneyFmt      = NumberFormat.simpleCurrency();

  
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
        
        if( snapshot.data.length ==0  )
          return Center( child: Text("NO HAY ELEMENTOS", style: TextStyle(color: Colors.white),));


        return ListView(
          children: snapshot.data.map<ListTile>(( mf ){
            print(mf.category);
            return ListTile(
              leading: Icon( Icons.circle, color: Color(int.parse( mf.category.color, radix:16 ) )),
              title: Row(
                children:[
                  Expanded(
                    flex: 6,
                    child: Text(mf.category.name, style: TextStyle(color:Colors.white))
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: ()=>_alertRestore(mf.movement), 
                      icon: Icon(Icons.restore, color: Colors.white70,)
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: ()=>_alertDelete(mf.movement.id), 
                      icon: Icon(Icons.delete, color: Colors.white70)
                    )
                  ),
                
                  
                ]
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(mf.movement.description, style: TextStyle(color:Colors.white)),
                  Text(_moneyFmt.format( mf.movement.value ), style: TextStyle(color:Colors.white))
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _alertDelete( int movementId ){
    Get.defaultDialog(
      title: "Confirmar",
      middleText: "Desear borrar este movimiento de la lista?",
      confirm: Container(
        height: 40,
        width: 95,
        padding: EdgeInsets.symmetric( vertical: 8, horizontal: 10 ),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)
          ),
          onPressed: (){
            _mvtsCtrl.delete(movementId);
            Get.back();
            Future.delayed(Duration(milliseconds: 300), (){
              setState(() {});
            });
          },
          child: Text( "Eliminar", style: TextStyle(
            color: Colors.white, 
            fontSize: 16, fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
      ),
      cancel: Container(
        height: 40,
        width: 90,
        padding: EdgeInsets.symmetric( vertical: 8, horizontal: 10 ),
        child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)

            ),
              onPressed: ()=>Get.back(),
            child: Text( "Cancelar", style: TextStyle(
              color: Colors.red, 
              fontSize: 16, 
              fontWeight: FontWeight.bold,          
            ),
            textAlign: TextAlign.center, 
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color:Colors.red) 
        ),
      )

    ).then((value){
      setState(() {
        
      });
    });
  }


  void _alertRestore( Movement m){
    Get.defaultDialog(
      title: "Confirmar",
      middleText: "Restaurar este movimiento?",
      confirm: Container(
        height: 40,
        width: 95,
        padding: EdgeInsets.symmetric( vertical: 8, horizontal: 10 ),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)
          ),
          onPressed: (){
            _mvtsCtrl.edit(m.id, m.description, m.value, true, m.categoryId, m.dateMovement);
            Get.back();
            Future.delayed(Duration(milliseconds: 300), (){
              setState(() {});
            });
          },
          child: Text( "Restaurar", style: TextStyle(
            color: Colors.white, 
            fontSize: 16, fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
      ),
      cancel: Container(
        height: 40,
        width: 90,
        padding: EdgeInsets.symmetric( vertical: 8, horizontal: 10 ),
        child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)

            ),
              onPressed: ()=>Get.back(),
            child: Text( "Cancelar", style: TextStyle(
              color: Colors.red, 
              fontSize: 16, 
              fontWeight: FontWeight.bold,          
            ),
            textAlign: TextAlign.center, 
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color:Colors.red) 
        ),
      )

    ).then((value){
      setState(() {
        
      });
    });
  }
}