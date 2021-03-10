import 'database.dart';

class CategoryModel{

  MyDatabase database;

  CategoryModel(){
    this.database = MyDatabase();
  }

  Future<bool> create() async{
    return true;
  }
}