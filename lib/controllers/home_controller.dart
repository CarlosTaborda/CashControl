
import 'package:get/get.dart';
import '../models/database.dart';

class HomeController extends GetxController{
  var count = 0.obs;
  final db=MyDatabase();
  increment() => count++;
  test(){
    this.db.getMovementsByDate(DateTime.now(), DateTime.now()).then((value) => print("ya"));
  }
}