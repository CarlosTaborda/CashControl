import 'package:moor/moor.dart';
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
class Movement extends Table{

  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 0, max:50)();
  IntColumn get categoryId  => integer()();
  RealColumn get value => real().withDefault(const Constant(0))();
  DateTimeColumn get dateMovement => dateTime().withDefault( Constant(DateTime.now()))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

}

@UseMoor(tables:[Categories,Movement])
class MyDatabase{
 
}
