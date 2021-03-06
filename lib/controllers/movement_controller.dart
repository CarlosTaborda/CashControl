import 'package:get/get.dart';
import '../models/database.dart';
import '../models/movement_model.dart';
import '../models/category_model.dart';

class MovementController extends GetxController{

  final movementMdl = MovementModel();
  final categoryMdl = CategoryModel();


  Future<int> create(
    String description, int categoryId, double value, 
    DateTime dateMovement, bool active) async {

    final insertId = await movementMdl.create(description, categoryId, value, dateMovement, active);
    return insertId;
    
  }

  Future<List<Category>> getByTypeAndState( int type, bool state ) async {
    final categories = await categoryMdl.getByTypeAndState(type, state);

    return categories;
  }

  Future<List<MovementFull>> getMovements(DateTime dateStart, DateTime dateEnd) async{


    final movements = await movementMdl.getMovements(dateStart, dateEnd);
    return movements;
  }


  Future<List<MovementFull>> getMovementsDisabled() async{

    final movements = await movementMdl.getMovementsDisabled();
    return movements;
  }

  Future<List<MovementFull>> getMovementsByFilter(
        DateTime dateStart, DateTime dateEnd, 
        List<int> categoriesId, List<bool> states) async{
    final movements = await movementMdl.getMovementsByFilter(dateStart, dateEnd, categoriesId, states);
    return movements;
  }


  Future<Movement> getById( int id ) async {
    final movement = await movementMdl.getById(id);
    return movement;
  }

  Future<bool> edit(int id, String description, double value, bool active, 
                      int categoryId, DateTime dateMovement ) async{

    return await movementMdl.edit(id, description, value, active, categoryId, dateMovement);

  }


  Future<bool> delete(int id ) async{

    return await movementMdl.delete(id);

  }



  
}