import 'package:flutter/material.dart';
import 'appbar_view.dart';

class CategoriesView extends StatefulWidget {
  
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MenuApp(),
      body: Scaffold(
        body: Text("Categories"),
      ),
    );
  }
}