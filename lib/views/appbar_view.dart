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
          topLeft: Radius.circular(30), topRight: Radius.circular(30)
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 40)
        ]
      ),
      child: ClipRRect(
        
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23), topRight: Radius.circular(23)
        ),
        child: BottomAppBar( 
          color: Color(0xFF3e563e),
          shape: CircularNotchedRectangle(),
          notchMargin: 6,
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
      {"name":"Resumen", "icon": Icons.assessment_outlined, "icon_2": Icons.assessment,"space":false},
      {"name":"Categoría", "icon": Icons.category_outlined, "icon_2": Icons.category,"space":false},
      {"space":true},
      {"name":"Papelera", "icon": Icons.delete_outline, "icon_2": Icons.delete,"space":false},
      {"name":"Configuración", "icon": Icons.settings_outlined, "icon_2": Icons.settings,"space":false},
    ];

    List<TextButton> buttomItems = [];
    for( int i=0; i< items.length; i++ ){

      if( !items[i]["space"] )
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
      else
        buttomItems.add(TextButton(child:SizedBox(width: 50,), onPressed: ()=>null,));
    }

    return buttomItems;
  }

  void _onTab( int index){
    
    setState(() {
      
      this._menuIndex = index;

      if( index == 0 )
        Get.offAndToNamed("/",arguments: index);

      if( index == 1 )
        Get.offAndToNamed("/Categories",arguments: index);

      if( index == 3 )
        Get.offAndToNamed("/Trash",arguments: index);

      if( index == 4 )
        Get.offAndToNamed("/Settings",arguments: index);

    });
    
  }
}

