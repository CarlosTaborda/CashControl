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

    _menuIndex=Get.arguments;
  }

  @override
  Widget build(BuildContext context) {

    _color = Colors.teal[900];

    return BottomNavigationBar(
      items: [
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
      backgroundColor: Colors.teal[900],
      currentIndex: this._menuIndex,
      selectedItemColor: Colors.white,
      onTap: _onTab,
      type: BottomNavigationBarType.shifting,

    
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