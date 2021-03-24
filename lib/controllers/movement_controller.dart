import '../models/database.dart';
import '../models/movement_model.dart';
import '../models/category_model.dart';

class MovementController{

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
    print(dateStart);
    print(dateEnd);

    final movements = await movementMdl.getMovements(dateStart, dateEnd);
    return movements;
  }
  
}