import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'database.g.dart';

@DataClassName("Category")
class Categories extends Table{

  IntColumn get id=> integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 0, max:50)();
  TextColumn get color => text().withLength(min: 0, max:15)();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get type => integer()();

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

  final  Categories category;
  final Movements movement;

  MovementFull( this.category, this.movement );

  
}

@UseMoor(tables:[Categories,Movements])
class MyDatabase extends _$MyDatabase{
  MyDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqlite", logStatements: true));


  Future<List<MovementFull>> getMovementsByDate( DateTime dateStart, DateTime dateEnd ) async {
    print("999999999999999");
    final query = select( movements ).join([
      innerJoin( categories, categories.id.equalsExp(movements.id) )
    ]).map((row){
      print("-----------------------------------------");
      print(row.toString());
      return MovementFull( null, null);
    }).get();





    return query;
  }

  @override
  // TODO: implement schemaVersion
  int get schemaVersion =>  1;

}