import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'views/home_view.dart';
import 'views/views.dart';

void main() {
  runApp(
    GetMaterialApp(
      home:HomeView(),
      getPages: views,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es')
      ],
      theme: ThemeData(
        primaryColor: Color(0xff3e563e),
        textTheme: TextTheme(
          headline6:  TextStyle(
            color: Color(0xffced9df),
            fontWeight: FontWeight.bold
          ),
          subtitle2: TextStyle(
            color: Color(0xffced9df),
            fontWeight: FontWeight.bold
          )
        ),
        accentTextTheme: TextTheme(
          button: TextStyle(
            color: Color(0xffced9df)
          )
        ),
        accentColor: Color(0xff1f2f22),
        colorScheme: ColorScheme(
          
          primary: Color(0xff3e563e), 
          primaryVariant: Color(0xff091008),
          background: Colors.white, 
          onError: Colors.red, 
          onPrimary: Color(0xffced9df), 
          onSecondary: Color(0xffced9df), 
          onSurface: Color(0xff091008),
          secondary: Color(0xff1f2f22),
          secondaryVariant: Colors.amber,
          surface: Color(0xff1f2f22),
          brightness: Brightness.light,
          error: Colors.red,
          onBackground: Colors.green[900]
        ),

        scaffoldBackgroundColor: Color(0xFF091008),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xff93a889), 
          filled: true,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide( color: Colors.green)),
          border: OutlineInputBorder()
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Color( 0xFF1f2f22),
          //color: Colors.white          
        ),  
      ),
      defaultTransition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
    )
  );
}
