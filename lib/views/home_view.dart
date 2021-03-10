import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/home_controller.dart';
import 'appbar_view.dart';

class HomeView extends StatelessWidget {

  final HomeController homeCtrl = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuApp(),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(onPressed: ()=>homeCtrl.test(), child: Text("test db")),
            
          ],
        ),
      ),
    );
  }
}