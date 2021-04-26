import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'database.g.dart';

@DataClassName("Category")
class Categories extends Table{

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 0, max:50)();
  TextColumn get color => text().withLength(min: 0, max:15)();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get type => integer()();// 1->ingreso, 0->gasto

}

@DataClassName("Movement")
class Movements extends Table{

  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 0, max:50)();
  IntColumn get categoryId  => integer()();
  RealColumn get value => real().withDefault(const Constant(0))();
  DateTimeColumn get dateMovement => dateTime().withDefault( Constant(DateTime.now()))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

}

class MovementFull{

  final  Category category;
  final Movement movement;

  MovementFull( this.category, this.movement );

  
}

@UseMoor(tables:[Categories,Movements])
class MyDatabase extends _$MyDatabase{


  MyDatabase._privateConstructor(): super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqlite", logStatements: true));

  static final MyDatabase _instance = MyDatabase._privateConstructor();

  factory MyDatabase() {
    return _instance;
  }

  Future<List<MovementFull>> getMovementsByDate( DateTime dateStart, DateTime dateEnd ) async {

    final query = await (
      select( movements )..where((mv)=>mv.dateMovement.isBetweenValues(dateStart, dateEnd) & mv.active.equals(true))
    ).join([
      innerJoin( categories, categories.id.equalsExp(movements.categoryId) & movements.dateMovement.isBetweenValues(dateStart, dateEnd) )
    ]).map((result) => MovementFull( result.readTable(categories), result.readTable(movements) )).get();

    return query;
  }

  Future<List<MovementFull>> getMovementsDisabled() async {
    
    final query = await (
      select( movements )..where((mv)=> mv.active.equals(false))
    ).join([
      innerJoin( categories, categories.id.equalsExp(movements.categoryId) )
    ]).map((result) => MovementFull( result.readTable(categories), result.readTable(movements) )).get();

    return query;
  }


  Future<List<MovementFull>> getMovementsByFilter( DateTime dateStart, DateTime dateEnd, List<int> categoriesId, List<bool> isActive ) async {

    final query = await (
      select( movements )..where((mv)=>mv.dateMovement.isBetweenValues(dateStart, dateEnd) & mv.active.isIn(isActive) & mv.categoryId.isIn(categoriesId) )
    ).join([
      innerJoin( categories, categories.id.equalsExp(movements.categoryId)  )
    ]).map((result) => MovementFull( result.readTable(categories), result.readTable(movements) )).get();



    return query;
  }




  @override
  int get schemaVersion =>  1;

}