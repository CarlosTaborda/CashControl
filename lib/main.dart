import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_view.dart';
import 'views/views.dart';

void main() {
  runApp(
    GetMaterialApp(
      home:HomeView(),
      getPages: views,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF091008),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xff93a889), 
          filled: true,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide( color: Colors.green))
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Color( 0xFF1f2f22),
          //color: Colors.white          
        ),  
      ),
      defaultTransition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    )
  );
}
