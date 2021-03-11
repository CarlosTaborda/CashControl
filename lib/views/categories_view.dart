import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              "Categorias",
              style: TextStyle(color: Colors.white, ),
            ),
            height: 15,
          ),
          leading: Container(),
          centerTitle: true,
          backgroundColor: Color( 0xFF1f2f22),
          bottom: PreferredSize(
            preferredSize: Size(Get.width/2, 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: Get.width/2,
                child: TabBar(
                  labelPadding: EdgeInsets.all(2),
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
        body: TabBarView(
          children:[
            Center(child: Text("Listar", style: TextStyle(color: Colors.white),)),
            CrearCategoria(),
          ] 
        ),
        
      )
      
    );
  }
}


class CrearCategoria extends StatefulWidget {

  @override
  _CrearCategoriaState createState() => _CrearCategoriaState();
}

class _CrearCategoriaState extends State<CrearCategoria> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField()
          ],
        )
      )
   
    );
  }
}