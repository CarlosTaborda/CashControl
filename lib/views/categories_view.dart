import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../wigets/switch.dart';
import '../controllers/category_controller.dart';
import '../models/database.dart';
import 'appbar_view.dart';

class CategoriesView extends StatefulWidget {
  
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {


  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            child: Text(
              "Categoría",
            ),
            height: 30,
          ),
          leading: Container(),
          bottom: PreferredSize(
            preferredSize: Size(Get.width/2, 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: Get.width/2,
                child: TabBar(
                  labelPadding: EdgeInsets.all(2),
                  indicator: BoxDecoration(
                    
                    border: Border(
                      bottom: BorderSide(style: BorderStyle.solid,width: 5, color: Color(0xFF7993a0) ),
                      
                    )
                  ),
                  tabs:[
                    Tab(text:"INGRESOS"), 
                    Tab(text:"GASTOS"),
                  ],
                  indicatorColor: Color(0xFF7993A0),            
                ),
              ),
            )
          ),
        ),
        bottomNavigationBar: MenuApp(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed("/CreateEditCategory", arguments: [false]).then((value){
              setState(()=>null);
            });
          },
          child: Icon( Icons.add ),
          backgroundColor: Color(0xff93a889),
        ),
        extendBody: true,
        body: TabBarView(
          children:[
            ListCategories(type: 1),
            ListCategories(type: 0),
            
          ] 
        ),
        
      )
      
    );
  }
}


class ListCategories extends StatefulWidget {

  final int type;
  ListCategories({Key key, this.type}) : super(key: key);

  @override
  _ListCategoriesState createState() => _ListCategoriesState(type);
}

class _ListCategoriesState extends State<ListCategories> {

  final categoryCtrl = CategoryController();
  final _type;
  _ListCategoriesState(this._type);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: categoryCtrl.getByType(_type),
      builder: (context, AsyncSnapshot<List<Category>> snapshot) {
        if (!snapshot.hasData )
          return Center(child: Text("NO HAY CATEGORIAS", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold)));
        else{

          if( snapshot.data.length == 0 ){
            return Center(child: Text("NO HAY CATEGORIAS",style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),),);
            
          }
          else{
            return ListView(
              children: snapshot.data.map((e) =>  ListTile(
                  leading: Icon(Icons.circle, size: 40, color: Color( int.parse(e.color, radix: 16) ),),
                  title: Container(
                    width: Get.width*0.5,
                    child: Text(e.name,style: TextStyle(color:Colors.white,),
                  ),
                  ),
                  trailing: SizedBox(
                      width: Get.width*0.3,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 35,
                          child:TextButton(
                            onPressed: ()=>_goToEdit( e.id ), 
                            child: Icon( Icons.edit, color: Color(0xffced9df),)
                          )
                        ),
                        SizedBox(
                          width: 35,
                          child:TextButton(
                            onPressed: ()=>_confirmDeleteCategory( e.id ), 
                            child: Icon( Icons.delete, color: Color(0xffced9df),)
                          )
                        ),

                      ]
                    ),
                  ),
                ),
              ).toList(),
            );
          }

        }
      },
    );
  }

  void _goToEdit( int id ){
    Get.toNamed("/CreateEditCategory", arguments: [true, id]).then((value){
      setState(() {
        
      });
    });
  }

  void _confirmDeleteCategory( int id){
    Get.defaultDialog(
      title: "Confirmar",
      middleText: "Desear borrar esta categoría, se borraran todos los movimientos asociados",
      confirm: Container(
        height: 40,
        width: 95,
        padding: EdgeInsets.symmetric( vertical: 8, horizontal: 10 ),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)
          ),
          onPressed: ()=>_deleteCategory(id),
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

  void _deleteCategory( int id ){
    categoryCtrl.delete(id).then((value){
      Get.back();
    });
  }
}




class CreateEditCategory extends StatefulWidget {

  @override
  _CreateEditCategoryState createState() => _CreateEditCategoryState();
}

class _CreateEditCategoryState extends State<CreateEditCategory> {


  final _categoryController = CategoryController();
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  bool _edit;
  int _categoryId;
  String _name="";
  String _color="";
  bool   _state=true;
  int    _type=1;

  @override
  void initState() {
    super.initState();
    final _args = Get.arguments;

    _edit = _args[0];
    if( _edit ){
      _categoryId = _args[1];
      _getInfoCategory( _categoryId );
    }
      

  }

  void _getInfoCategory( int id ){
    _categoryController.getById(id).then((c){
      setState(() {
        _name=c.name;
        _nameCtrl.text = _name;
        _color=c.color;
        _type=c.type;
        _state=c.active;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_edit == true?"Editar Categoría":"Crear Categoría"),
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: Get.height*0.08,),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: "NOMBRE",
                  labelStyle: TextStyle(
                    color: Color(0xff091008)
                  )

                ),
              ),
              SizedBox(height: 15,),
              Text("COLOR",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),),
              SizedBox(height: 15,),
              Container(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buttonsCategoryColors(),
                ),
              ),
              SizedBox(height: 15,),
              if( ! _edit  )
                MySwitch(
                  initValue: _type==1,
                  inputTitle: "INGRESO",
                  iconInput: Icons.arrow_downward,
                  iconOutput: Icons.arrow_upward,
                  outputTitle: "GASTO",
                  incomeColor: Colors.green,
                  outColor: Colors.red,
                  onChange: ( value){
                    setState(() {
                      value == true ? _type = 1: _type=0;
                    });
                  }
                )
              else
                MySwitch(
                  initValue: _state,
                  inputTitle: "ACTIVO",
                  iconInput: Icons.check,
                  iconOutput: Icons.close,
                  outputTitle: "INACTIVO",
                  incomeColor: Colors.green,
                  outColor: Colors.red,
                  onChange: ( value){
                    setState(() {
                      _state = value;
                    });
                  }
                )
              ,
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: _edit? _editCategory : _insertCategory, 
                child: Text(_edit?"EDITAR":"CREAR", style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xff3e563e))
                ),
              )
              
            ],
          )
        ),
      ),
    );
  }

  void _insertCategory(){
    setState(() {
      
      _name = _nameCtrl.text;
      _categoryController.create(_name, _color, true, _type).then((value){
      Get.back();
    });
    });
  }

  void _editCategory(){
    setState(() {
      _name = _nameCtrl.text;
      print("_editCategory($_name , $_color, true, $_type, $_categoryId)");
      _categoryController.edit(_name, _color, _state, _type, _categoryId).then((value) => Get.back());
    });
  }


  List<Container> _buttonsCategoryColors(){
    List<String> colors=[
      "FF97d67f","FFffc125","ffff0040","ff61b3ff","ffb7a1ff","ff2b5454","ffffffff",
      "ff31dede","ffc13ebf","ffc92020","fff4ec3d","ffe97a42","ff143fb0"
    ];

    List<Container> buttons = [];
    for(String c in colors){
      buttons.add(
        Container(
          decoration: new BoxDecoration(
            color: Color( int.parse( c, radix: 16 ) ),
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.white,
              width: 2.5,
            ),
          ),
          child:TextButton(
            onPressed: (){
              setState(() {
                _color = c;
              });
            }, 
            child: Center(child: _color == c? Icon(Icons.check,size: 30,color: Colors.white) : Container(),)
          )
        )
      );
    }

    return buttons;
  }
}