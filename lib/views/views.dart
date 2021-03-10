import 'package:get/get.dart';
import 'home_view.dart';
import 'categories_view.dart';
import 'trash_view.dart';
import 'settings_view.dart';



final views = [
  GetPage(name: "/", page: ()=>HomeView()),
  GetPage(name: "/Categories", page: ()=>CategoriesView()),
  GetPage(name: "/Trash", page: ()=>TrashView()),
  GetPage(name: "/Settings", page: ()=>SettingsView()),
];