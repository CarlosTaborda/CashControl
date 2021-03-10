import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuApp extends StatefulWidget {
  MenuApp({Key key}) : super(key: key);

  @override
  _MenuAppState createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp> {

  int _menuIndex;
  Color _color;

  @override
  void initState( ) {

    super.initState();
    _color = Colors.teal[900];
    _menuIndex=Get.arguments==null?0:Get.arguments;
  }

  @override
  Widget build(BuildContext context) {

    

    return Container(
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(40), topRight: Radius.circular(40)
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 40)
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)
        ),
        child: BottomNavigationBar( 
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment_outlined),
              label: this._menuIndex==0?"Resumen":"",
              backgroundColor: _color,
              activeIcon: Icon(Icons.assessment),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: this._menuIndex==1?"Categoría":"",
              activeIcon: Icon(Icons.category),
              backgroundColor: _color
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete_outline),
              label: this._menuIndex==2?"Papelera":"",
              activeIcon: Icon(Icons.delete),
              backgroundColor: _color
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: this._menuIndex==3?"Configuración":"",
              activeIcon: Icon(Icons.settings),
              backgroundColor: _color
            )
          ],
          onTap: _onTab,
          currentIndex: _menuIndex,
        ),
      ),
    );
  }

  void _onTab( int index){
    
    setState(() {
      
      this._menuIndex = index;

      if( index == 0 )
        Get.toNamed("/",arguments: index);

      if( index == 1 )
        Get.toNamed("/Categories",arguments: index);

      if( index == 2 )
        Get.toNamed("/Trash",arguments: index);

      if( index == 3 )
        Get.toNamed("/Settings",arguments: index);

    });
    
  }
}