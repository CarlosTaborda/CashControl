
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/movement_controller.dart';
import '../models/database.dart';
import 'appbar_view.dart';



class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final movementsCtrl = MovementController() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/CreateEditMovement", arguments: [false]).then((value){
            setState(()=>null);
          });
        },
        child: Icon( Icons.add ),
        backgroundColor: Color(0xff93a889),
      ),
      body:Center( child: Text("RESUMEN", style: TextStyle( color:Colors.white ),), ),
      bottomNavigationBar: MenuApp(),
    );
  }
}



class CreateEditMovement extends StatefulWidget {

  final bool edit;
  CreateEditMovement({Key key, this.edit:false}) : super(key: key);

  @override
  _CreateEditMovementState createState() => _CreateEditMovementState(edit);
}

class _CreateEditMovementState extends State<CreateEditMovement> with SingleTickerProviderStateMixin {

  bool _edit;
  TabController _tabController;
  final _descriptionCtrl = TextEditingController();
  final _valueCtrl       = TextEditingController();
  String _color          = "";
  final _formKey         = GlobalKey<FormState>();
  DateTime _dateMovement = DateTime.now();
  final _movementCtrl    = MovementController();

  _CreateEditMovementState( this._edit );

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_edit ? "Editar Movimiento" : "Nuevo Movimiento"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: _form()
      )
    );
  }


  Widget _form(){
    return Form(
        key: _formKey,
        child : ListView(
          children: [
            SizedBox(height: Get.height*0.05,),
            _descriptionTextInput(),
            SizedBox(height:10),
            _valueTextInput(),
            SizedBox(height:10),
            _selectDateInput(),
            SizedBox(height:10),
            PreferredSize(
              preferredSize: Size(Get.width/2, 20),
              child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: Get.width/2,
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.all(2),
                  indicator: BoxDecoration(
                    
                    border: Border(
                      bottom: BorderSide(style: BorderStyle.solid,width: 5, color: Color(0xFF7993a0) ),
                      
                    )
                  ),
                  tabs:[
                    Tab(text:"GASTOS"), 
                    Tab(text:"INGRESOS"),
                  ],
                  indicatorColor: Color(0xFF7993A0),            
                ),
              ),
            )
            ),
            Container(
              width: Get.width,
              height: 200,
              child: TabBarView(
              controller: _tabController,

              children: [
                _listCategories(0),
                _listCategories(1)
              ]
            ),
            )
            
          ]
        ),
      );
  }


  Widget _listCategories( int type ){
    return FutureBuilder(
      future: _movementCtrl.getByTypeAndState(type, true),
      builder: ( BuildContext context, AsyncSnapshot<List<Category>> snapshot ){

        if( snapshot.hasData ){
          return ListView(
            children: snapshot.data.map(
              (c) => ListTile(
                leading: Icon(_color==c.color? Icons.check : Icons.circle, size: 50, color: Color( int.parse(c.color, radix: 16) ),),
                onTap: (){
                  setState(() {
                    _color = c.color;
                  });
                },
                title: Container(
                    width: Get.width*0.5,
                    child: Text(c.name,style: TextStyle(color:Colors.white,),
                  ),
                ),
              ) 
            
            ).toList(),
          );
        }

        return Center( child: Text("NO HAY CATEGORIAS", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold)));
      }
    );
  }


  TextFormField _descriptionTextInput(){
    return TextFormField(
      controller: _descriptionCtrl,
      decoration: InputDecoration(
        labelText: "DESCRIPCIÓN",
        labelStyle: TextStyle(
          color: Color(0xff091008)
        )

      ),
    );
  }

  TextFormField _valueTextInput(){
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
      controller: _valueCtrl,
      decoration: InputDecoration(
        
        labelText: "VALOR",
        labelStyle: TextStyle(
          color: Color(0xff091008)
        )

      ),
    );
  }


  ElevatedButton _selectDateInput(){
    return ElevatedButton(
      onPressed: ()=>_showDatePicker(), 
      child: Text(
        DateTime.now().toString().substring(0,10)
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[900])
      ),
    );
  }


  void _showDatePicker() async {
    final DateTime picked = await showDatePicker(
      locale: Locale("es"),
      context: Get.context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

  

    if( picked != null && picked != _dateMovement ){
      setState(() {
        _dateMovement = picked;
      });
    }
  }
}

