import 'package:moor/moor.dart';
part 'database.g.dart'

@DataClassName("Category")
class Categories extends Table{

  IntColumn get id=> integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 0, max:50)();
  TextColumn get color => text().withLength(min: 0, max:15)();
  BooleanColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get type => integer().();

}

@DataClassName("Movement")
class Movement extends Table{

  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(min: 0, max:50)();
  IntColumn get category_id  => integer().();
  DoubleColumn get value => real().();
  DateTimeColumn get date_movement => dateTime().();
  BooleanColumn get active => boolean().withDefault(const Constant(true))();

}

@UseMoor(tables:["Categories","Movements"])
class MyDatabase{
 
}
