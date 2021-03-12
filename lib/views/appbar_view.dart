import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuApp extends StatefulWidget {
  MenuApp({Key key}) : super(key: key);

  @override
  _MenuAppState createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp> {

  int _menuIndex;

  @override
  void initState( ) {

    super.initState();
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
        child: BottomAppBar( 
          color: Color(0xFF3e563e),
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _itemsMenu()
            ),
          ),
          ),
      ),
    );
  }


  List<TextButton> _itemsMenu(){
    final items = [
      {"name":"Resumen", "icon": Icons.assessment_outlined, "icon_2": Icons.assessment},
      {"name":"Categoría", "icon": Icons.category_outlined, "icon_2": Icons.category},
      {"name":"Papelera", "icon": Icons.delete_outline, "icon_2": Icons.delete},
      {"name":"Configuración", "icon": Icons.settings_outlined, "icon_2": Icons.settings},
    ];

    List<TextButton> buttomItems = [];
    for( int i=0; i< items.length; i++ ){
      buttomItems.add(
        TextButton(
          onPressed: ()=>_onTab( i ), 
          child: Column(
            children: [
              Icon( 
                _menuIndex== i? items[i]["icon_2"] : items[i]["icon"],
                color: Color(0xffced9df),
              ),
              Text( _menuIndex== i? items[i]["name"] : "", style: TextStyle(color: Color(0xffced9df)), )
            ],
          )
        )
      );
    }

    return buttomItems;
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

