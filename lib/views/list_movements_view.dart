import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/database.dart';
import '../controllers/movement_controller.dart';

class ListMovements extends StatefulWidget {
  ListMovements({Key key}) : super(key: key);

  @override
  _ListMovementsState createState() => _ListMovementsState();
}

class _ListMovementsState extends State<ListMovements> {

  final _movementCtrl = MovementController();
  final moneyFmt = NumberFormat.simpleCurrency();
  DateTime _dateStart;
  DateTime _dateEnd;
  int _categoryId;
  List<MovementFull> _movements;


  @override
  void initState() {
    
    
    _dateStart = Get.arguments[1];
    _dateEnd = Get.arguments[2];
    _categoryId = Get.arguments[0];
    super.initState();
    _getMovements();
    
  }

  void _getMovements(){
    _movementCtrl.getMovementsByFilter(
      _dateStart, _dateEnd, [_categoryId], [true]
    ).then(( value ){
      setState(() {
        _movements = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      appBar: AppBar(
        title: Text("Movimientos"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _movementCtrl.getMovementsByFilter(_dateStart, _dateEnd, [_categoryId], [true] ),
        builder: ( context, snapshot){
          if( !snapshot.hasData || snapshot.data == null || snapshot.data.length == 0 )
            return Center(child:Text("NO HAY MOVIMIENTOS"));
          
          _movements = snapshot.data;

          return ListView(
            children: _movements.map((e) => _movementListItem(e)).toList(),
          );
        },
      )
    );
  }


  ListTile _movementListItem( MovementFull m ){
    return ListTile(
      leading: Icon(Icons.circle, color: Color(int.parse(m.category.color, radix: 16)),size: 30,),
      title: Text(
        m.movement.description,
        style: Get.textTheme.headline6,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text( 
              m.category.name,
              style: Get.textTheme.subtitle2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( 
                moneyFmt.format(m.movement.value),
                style: Get.textTheme.subtitle2,
              ),
              
              Text( 
                m.movement.dateMovement.toString().substring(0,10),
                style: Get.textTheme.subtitle2,
              ),
            ],
          )
        ],
      ),
      trailing: SizedBox(
        width: Get.width * 0.2,
        child: Row(
          children: [
            IconButton(
              icon: Icon( 
                Icons.edit,
                color: Colors.white,
                size: 30,
              ), 
              onPressed: (){
                Get.toNamed("/CreateEditMovement", arguments: [ true, m.movement.id ]);
              }
            ),
            IconButton(
              icon: Icon( 
                Icons.delete,
                color: Colors.white,
                size: 30,
              ), 
              onPressed: ()=>_confirmDeleteMovement( m.movement )
            ),

          ],
        ),
      ),
    );

  }

  void _logicDelete( Movement m ){
    _movementCtrl.edit(m.id, m.description, m.value, false, m.categoryId, m.dateMovement);
    Get.back();
    Future.delayed(Duration(milliseconds: 350), ()=>setState(() {}));
    
  }


  void _confirmDeleteMovement( Movement m ){
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
          onPressed: ()=>_logicDelete(m),
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




}