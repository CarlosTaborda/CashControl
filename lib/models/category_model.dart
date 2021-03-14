import 'package:flutter/material.dart';

import 'database.dart';

class CategoryModel{

  MyDatabase db;

  CategoryModel(){
    this.db = MyDatabase();
  }

  Future<int> create(String name, String color, bool active, int type) {
    return db.into(db.categories).insert(
      Category( 
        id: null,
        name: name, 
        color: color, 
        active:active, 
        type: type )
    );

  }

  Future<List<Category>> getByType( int type ) async {
    final categories = await (db.select(db.categories)..where((tbl) => tbl.type.equals(type))).get();
    return categories;
  }

  Future<Category> getById( int id ) async{
    final category = await ( db.select(db.categories)..where((tbl) => tbl.id.equals(id))..limit(1) ).get();
    return category[0];
  }

  Future<bool> edit(String name, String color, bool active, int type, int id)async{
    bool result = await db.update(db.categories).replace(Category(
      id: id,
      name: name,
      color: color,
      type: type,
      active: active
    ));
    return result;
  }
}