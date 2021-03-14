import '../models/database.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController{
  final CategoryModel categoryModel = CategoryModel();
  

  bool create(String name, String color, bool active, int type){
    categoryModel.create(name, color, active, type).then((value) => print(value));
    return true;
  }

  Future<List<Category>> getByType(int type) async{
    final categories = await categoryModel.getByType(type);
    return categories;
  }

  Future<Category> getById(int id) async{
    final category = await categoryModel.getById(id);
    return category;
  }

  Future<bool> edit(String name, String color, bool active, int type, int id) async{
    final result = await categoryModel.edit(name, color, active, type, id);
    return result;
  }
}