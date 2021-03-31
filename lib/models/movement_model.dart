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

  Future<List<MovementFull>> getMovements(DateTime dateStart, DateTime dateEnd) async {
    final movements = await db.getMovementsByDate(dateStart, dateEnd);
    return movements;
  }

  Future<List<MovementFull>> getMovementsByFilter(DateTime dateStart, 
            DateTime dateEnd, List<int> categoriesId, List<bool> isActive) async {
              
    final movements = await db.getMovementsByFilter(dateStart, dateEnd, categoriesId, isActive);
    return movements;
  }


  Future<bool> edit( int id, String description, double value, bool active, 
                      int categoryId, DateTime dateMovement ) async {
    final response = await db.update(db.movements).replace(
      Movement(
        id: id, description: description, categoryId: categoryId, 
        value: value, dateMovement: dateMovement, active: active
      )
    );

    return response;
  }

  Future<bool> delete( int id)async{
    final response = await (db.delete(db.movements)..where((tbl) => tbl.id.equals(id))).go();

    return response>0;
  }
}