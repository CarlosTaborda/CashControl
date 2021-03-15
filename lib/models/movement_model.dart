import 'database.dart';

class MovementModel{

  final db = MyDatabase();

  Future<int> create( String description, int categoryId, double value, DateTime dateMovement, bool active ) async  {
    int insertId = await db.into(db.movements).insert(Movement(
      id: null, 
      description: description, 
      categoryId: categoryId, 
      value: value, 
      dateMovement: dateMovement, 
      active: active
    ));

    return insertId;
  }
}