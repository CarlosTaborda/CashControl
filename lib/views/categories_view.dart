import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../wigets/switch.dart';
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
                    Tab(text:"GASTOS"), 
                    Tab(text:"INGRESOS"),
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
            Get.toNamed("/CreateEditCategory", arguments: [false]);
          },
          child: Icon( Icons.add ),
          backgroundColor: Color(0xff93a889),
        ),
        extendBody: true,
        body: TabBarView(
          children:[
            Center(child: Text("Listar", style: TextStyle(color: Colors.white),)),
            ListCategories(),
          ] 
        ),
        
      )
      
    );
  }
}


class ListCategories extends StatefulWidget {
  ListCategories({Key key}) : super(key: key);

  @override
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  @override
  Widget build(BuildContext context) {
    return Center(
       child: Text(
         "Listado de Categorias",
         style: TextStyle(color: Colors.white),
       ),
    );
  }
}




class CreateEditCategory extends StatefulWidget {

  @override
  _CreateEditCategoryState createState() => _CreateEditCategoryState();
}

class _CreateEditCategoryState extends State<CreateEditCategory> {

  final _formKey = GlobalKey<FormState>();
  bool _edit;
  int _categoryId;

  @override
  void initState() {
    super.initState();
    final _args = Get.arguments;

    _edit = _args[0];
    if( _edit )
      _categoryId = _args[1];

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
              TextFormField(

                decoration: InputDecoration(
                  labelText: "Nombre",
                  alignLabelWithHint: true,
                ),
              ),
              MySwitch(
                initValue: true,
                inputTitle: "INGRESO",
                outputTitle: "EGRESO",

                onChange: (estado)=>print(estado),
              ),
              
            ],
          )
        ),
      ),
    );
  }
}