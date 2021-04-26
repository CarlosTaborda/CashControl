import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/database.dart';
import '../controllers/movement_controller.dart';

class CreateEditMovement extends StatefulWidget {


  CreateEditMovement({Key key}) : super(key: key);

  @override
  _CreateEditMovementState createState() => _CreateEditMovementState();
}

class _CreateEditMovementState extends State<CreateEditMovement> with SingleTickerProviderStateMixin {

  bool _edit;
  TabController _tabController;
  int _categoryId;
  int _movementId;
  final _descriptionCtrl = TextEditingController();
  final _valueCtrl       = TextEditingController();
  String _color          = "";
  final _formKey         = GlobalKey<FormState>();
  DateTime _dateMovement = DateTime.now();
  final _movementCtrl    = MovementController();
  Movement _movement;

  //_CreateEditMovementState( this._edit );

  @override
  void initState() {
    super.initState();

    _edit       = false;
    _movementId = 0;

    if( Get.arguments[0] ){

      _edit       = Get.arguments[0];
      _movementId = Get.arguments[1];
      _movementCtrl.getById(_movementId).then((mv){

        _movement             = mv;
        _descriptionCtrl.text = mv.description;
        _valueCtrl.text       = mv.value.toString();
        _dateMovement         = mv.dateMovement;
        _categoryId           = mv.categoryId;

      });

    }
      
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
      child : FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 300),()=> true),
        builder: (context, snapshot) {

          if( !snapshot.hasData )
            return Center( child: CircularProgressIndicator(backgroundColor: Colors.green[900]) );
          
          return ListView(
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
                height: 120,
                child: TabBarView(
                  controller: _tabController,

                  children: [
                    _listCategories(0),
                    _listCategories(1)
                  ]
                ),
              ),
              ElevatedButton(onPressed: _edit? editMovement : createMovement, child: Text(_edit? "EDITAR":"CREAR"))
              
            ]
          );
        },
      )
    );
  }

  void createMovement(){
    setState(() {
      print( "createMovement( ${_descriptionCtrl.text}, $_categoryId, ${_valueCtrl.text}, ${_dateMovement.toString()} )" );
      _movementCtrl.create(_descriptionCtrl.text, _categoryId, double.parse( _valueCtrl.text ), _dateMovement, true).then((value) => Get.back());
    });
  }

  void editMovement(){
    print( "editMovement( ${_descriptionCtrl.text}, $_categoryId, ${_valueCtrl.text}, ${_dateMovement.toString()} )" );
    _movementCtrl.edit(_movementId, _descriptionCtrl.text, double.parse( _valueCtrl.text ), true, _categoryId, _dateMovement).then((value) => Get.back());
  }


  Widget _listCategories( int type ){
    return FutureBuilder(
      future: Future.wait([
        _movementCtrl.getByTypeAndState(type, true),
        Future.delayed(Duration(milliseconds: 500), ()=>true)
      ]),
      builder: ( BuildContext context,  snapshot ){

        if( snapshot.hasData && snapshot.data[0].length > 0){
          List<Category> categories= snapshot.data[0];

          return ListView(
            children: categories.map(
              (Category c) => ListTile(
                leading: Icon((_color==c.color || _categoryId == c.id)? Icons.check : Icons.circle, size: 50, color: Color( int.parse(c.color, radix: 16) ),),
                onTap: (){
                  setState(() {
                    _color = c.color;
                    _categoryId = c.id;
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