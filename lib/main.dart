import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_view.dart';
import 'views/views.dart';

void main() {
  runApp(
    GetMaterialApp(
      home:HomeView(),
      getPages: views,
      theme: new ThemeData(scaffoldBackgroundColor: Color(0xFF090a0a)),
    )
  );
}
