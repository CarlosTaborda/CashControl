
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/movement_controller.dart';
import '../models/database.dart';
import '../wigets/month_picker_dialog.dart';
import 'appbar_view.dart';



class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final movementsCtrl  = MovementController() ;
  final _moneyFmt      = NumberFormat.simpleCurrency();
  DateTime _dateStart  = DateTime.now();
  DateTime _dateEnd    = DateTime.now();
  double _totalInputs  = 0;
  double _totalOutputs = 0;
  DateTime _dateMovement=DateTime.now();
  List<Map<String, dynamic>> _listCategories = [];

  @override
  void initState() {
    
    super.initState();
    final DateTime now = DateTime.now();
    _dateStart = DateTime(now.year, now.month, 1);
    _dateEnd  = now.month < 12 ? DateTime(now.year, now.month + 1, 1) : DateTime(now.year+1,  1, 1);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text("Balance"),
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/CreateEditMovement", arguments: [false]).then((value){
            setState(()=>null);
          });
        },
        child: Icon( Icons.add ),
        backgroundColor: Color(0xff93a889),

      ),
      body: Container(
        child: _listMovements(),
      ),
      bottomNavigationBar: MenuApp(),
    );
  }

  void _calcValues( List<MovementFull> movements){
    
    List<int> _categoriesAdded = [];

    _totalOutputs = 0;
    _totalInputs = 0;
    _listCategories = [];

    for( MovementFull m in movements){
      
      if( m.category.type == 0 )
        _totalOutputs += m.movement.value;
      else
        _totalInputs += m.movement.value;


      print( "Categoria:"+m.category.id.toString()+" Exits:"+(_categoriesAdded.contains(m.category.id)).toString() );
      print(_categoriesAdded);

      if( !_categoriesAdded.contains(m.category.id) ){
        
        _listCategories.add({
          "id":m.category.id,
          "name":m.category.name,
          "value": m.movement.value,
          "input": m.category.type == 1
        });

        _categoriesAdded.add(m.category.id);

      }        
      else{

        for( int i = 0; i < _listCategories.length; i++ ){

          if( _listCategories[ i ]["id"] == m.category.id  ){

            _listCategories[ i ]["value"] = _listCategories[ i ]["value"] + m.movement.value;
            break;

          }
            

        }

      }

    }
    //setState(()=>null);

  }


  Widget _listMovements(){

    return FutureBuilder(
      future: movementsCtrl.getMovements(_dateStart, _dateEnd),
      builder: (BuildContext context, AsyncSnapshot<List<MovementFull>> response ){

        if( !response.hasData ){
          return Container();
        }else{
          _calcValues( response.data );
          
          return ListView(
            children: _getListElementsHome(response.data),
          );
        }
        
      
      }
    );

  }


  List<Widget> _getListElementsHome( List<MovementFull> ms ){

    List<Widget> element = [];

    double _percentOutput = 0;
    

    element.add(Center(
      child: ElevatedButton(
        child: Text("Fecha ${_dateMovement.year}-${_dateMovement.month}" ),
        onPressed: ()=>_showMonthPicker(),
      ),
    ));

    if( _totalInputs > 0)
      _percentOutput = (_totalOutputs*100)/_totalInputs;

    final List<Map<String, dynamic>> chartData = [
        {"name":"EGRESO", "value":_percentOutput>100?100:_percentOutput, "color":Colors.red},
        {"name":"INGRESO", "value":(100-_percentOutput < 0 ? 0: 100 - _percentOutput), "color":Colors.green},
    ];




    element.add(
      Container(
        padding: EdgeInsets.all(10),
        width: Get.width*0.9,
        child: GestureDetector(
          child: Card(
            color: Color(0xff3e563e),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15 ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: Get.width*0.8,
                        child: ListTile(
                          dense: true,
                          title: Text(
                            _moneyFmt.format( _totalInputs-_totalOutputs ),
                            style: TextStyle(
                              fontSize: 35,
                              color: Color(0xffced9df)

                            ),
                          ),
                          subtitle: Text("RESTANTE", style: TextStyle(fontSize: 13, color: Color(0xffced9df), fontWeight: FontWeight.bold))
                        ),
                      )
                      
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Get.width * 0.6,
                            child: ListTile(
                              dense: true,
                              title: Text( _moneyFmt.format( _totalInputs ), style: TextStyle(
                                fontSize: 25,
                                color: Color(0xffced9df)
                              )),
                              subtitle: Text("INGRESO",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffced9df)
                                )
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.6,
                            child: ListTile(
                              
                              dense: true,
                              title: Text( _moneyFmt.format( _totalOutputs ), style: TextStyle(
                                color: Color(0xffced9df),
                                fontSize: 25
                              )),
                              subtitle: Text("GASTOS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffced9df)
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            padding: EdgeInsets.all(7),
                            child: Text(
                              "%"+(_percentOutput>100?"0":(100-_percentOutput).toStringAsFixed(2)),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffced9df)
                              ),
                            ),
                          ),
                          Container(
                            height: Get.width*0.30,
                            width: Get.width*0.30,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                DoughnutSeries<Map, String>(
                                    dataSource: chartData,
                                    pointColorMapper:(Map data,  _) => data["color"],
                                    xValueMapper: (Map data, _) => data["name"],
                                    yValueMapper: (Map data, _) => data["value"]
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            padding: EdgeInsets.all(7),
                            child: Text("%"+_percentOutput.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffced9df)
                              ),
                            ),
                          ),
                        ],
                      ),
                      

                    ],
                  ),
                  SizedBox(height: 10)
                ],
              ),
            )
          ),
          onTap: ()=>Get.toNamed(
                      "/MovementsChart", 
                      arguments: [_dateStart, _dateEnd]
                    ).then((value) => setState((){})),
        )
      )
    );

    element.addAll( ms.map(
      (e) =>
      ListTile(
        leading:Icon(Icons.circle, color: Color(int.parse(e.category.color, radix:16)),size: 45,),
        title: Text(
          e.category.name, 
          style: TextStyle(
            color: Colors.white,
            fontSize: 23
          )
        ),
        subtitle: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                e.movement.description, 
                textAlign: TextAlign.left,
                style: TextStyle(color:Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(_moneyFmt.format(e.movement.value), style: TextStyle(color: Colors.white)),
                Text(e.movement.dateMovement.toString().substring(0,10), style: TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
        trailing: SizedBox(
          width: 85,
          child: Row(
          
            children: [
              IconButton(onPressed: ()=>_confirmDeleteMovement(e.movement), icon: Icon(Icons.delete, color: Colors.white,)),
              Icon( e.category.type == 1? Icons.arrow_downward : Icons.arrow_upward, color: e.category.type==1? Colors.green:Colors.red,)
            ],
          ),
        ),
        onTap: (){
          Get.toNamed("/CreateEditMovement", arguments: [true, e.movement.id]);
        },

      ) 
    ).toList());

    if(ms.length == 0)
      element.add(Center(
        child: Text("NO HAY MOVIMIENTOS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ));


    return element;
  }


  void _showMonthPicker() async {
    
    showMonthPicker(
      context: Get.context,
      initialDate: _dateMovement,
      firstDate: DateTime.utc(2010),
      lastDate: DateTime.now(),
      
    ).then((value){
      setState(() {
        _dateStart = value;
        _dateEnd = value.month < 12 ? DateTime(value.year, value.month + 1, 1) : DateTime(value.year+1,  1, 1);
      });
    });
  }

  void _confirmDeleteMovement( Movement m ){
    Get.defaultDialog(
      title: "Confirmar",
      middleText: "Desear borrar este movimiento de la lista?",
      confirm: Container(
        height: 40,
        width: 95,
        padding: EdgeInsets.symmetric( vertical: 8, horizontal: 10 ),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)
          ),
          onPressed: ()=>_logicDelete(m),
          child: Text( "Eliminar", style: TextStyle(
            color: Colors.white, 
            fontSize: 16, fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
      ),
      cancel: Container(
        height: 40,
        width: 90,
        padding: EdgeInsets.symmetric( vertical: 8, horizontal: 10 ),
        child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero)

            ),
              onPressed: ()=>Get.back(),
            child: Text( "Cancelar", style: TextStyle(
              color: Colors.red, 
              fontSize: 16, 
              fontWeight: FontWeight.bold,          
            ),
            textAlign: TextAlign.center, 
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color:Colors.red) 
        ),
      )

    ).then((value){
      setState(() {
        
      });
    });
  }

  void _logicDelete( Movement m ){
    movementsCtrl.edit(m.id, m.description, m.value, false, m.categoryId, m.dateMovement);
    Get.back();
    Future.delayed(Duration(milliseconds: 350), ()=>setState(() {}));
    
  }

}


class MovementsChart extends StatefulWidget {
  MovementsChart({Key key}) : super(key: key);

  @override
  _MovementsChartState createState() => _MovementsChartState();
}

class _MovementsChartState extends State<MovementsChart> {


  DateTime _dteStart;
  DateTime _dteEnd;
  double _totalInputs = 0;
  double _totalOutputs = 0;
  MovementController movementsCtrl = MovementController();

  List<Map<String, dynamic>> _categories;
  final _moneyFmt = NumberFormat.simpleCurrency();

  @override
  void initState() {
    
    super.initState();
    _dteStart     = Get.arguments[0];
    _dteEnd       = Get.arguments[1];



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
      appBar: AppBar(
        title: Text("Resumen"),
        centerTitle: true,
      ),
    );
  }

  _calcValues( List<MovementFull> mvs ){
    List<int> categoriesExist = [];
    _categories = [];
    _totalOutputs = 0;
    _totalInputs = 0;

    for(MovementFull m in mvs){

      

      if( m.category.type == 1 ){
        _totalInputs += m.movement.value;
        
      }

      if( m.category.type == 0 ) {
        _totalOutputs += m.movement.value;
      }

      if(!categoriesExist.contains(m.category.id)){
        _categories.add({"id": m.category.id, "input": m.category.type == 1, "name": m.category.name, "value":m.movement.value});
        categoriesExist.add(m.category.id);
      }
      else{
        _categories[categoriesExist.indexOf(m.category.id)]["value"] += m.movement.value;
      }
    }
    
  }

  Widget _getBody(){
    return FutureBuilder(
      future: movementsCtrl.getMovements(_dteStart, _dteEnd),
      builder:( context, snapshot ) {

        if( !snapshot.hasData )
          return Center( child: CircularProgressIndicator() );

        _calcValues( snapshot.data );


        return ListView(
          children: [
            _panel(),
            Column(
              children: _getCategories(),
            ),
          ],
        );
      }
    );
    
    
  }

  Container _panel(){
    return Container(
      height: 215,
      padding: EdgeInsets.all(15),
      child: Card(
        color: Color(0xff3e563e),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                width: Get.width*0.8,
                child: ListTile(
                  title: Text(
                    _moneyFmt.format(_totalInputs - _totalOutputs),
                    style: TextStyle(
                      color: Color(0xff7993a0),
                      fontSize: 30
                    ),
                  ),
                  subtitle: Text(
                    "SALDO",
                    style: TextStyle(
                      color: Color(0xffced9df),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.40,
                    child: ListTile(
                      dense: true,
                      title: Text( 
                        _moneyFmt.format(_totalInputs),
                        style: TextStyle(
                          color: Color(0xff7993a0),
                          fontSize: 16
                        ),
                      ),
                      subtitle: Text(
                        "INGRESO",
                        style: TextStyle(
                          color: Color(0xffced9df),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      trailing: Icon( Icons.arrow_downward, color: Colors.red[700] ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.40,
                    child: ListTile(
                      dense: true,
                      title: Text( 
                        _moneyFmt.format(_totalOutputs),
                        style: TextStyle(
                          color: Color(0xff7993a0),
                          fontSize: 16
                        ),
                      ),
                      subtitle: Text(
                        "GASTO",
                        style: TextStyle(
                          color: Color(0xffced9df),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      trailing: Icon( Icons.arrow_upward, color: Colors.green,),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  List<Widget> _getCategories(){
    List<Container> _catContainer = [];

    for( int i =0; i < _categories.length; i+=2 ){

      if( _categories.length - i >= 2 ){

        _catContainer.add(
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _cardCategory( _categories[i] )
                ),
                Expanded(
                  flex: 1,
                  child: _cardCategory( _categories[i+1] )
                )
              ],
            ),
          )
        );

      }
      else if(_categories.length - i == 1){

        _catContainer.add(
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _cardCategory( _categories[i] )
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                )
              ],
            ),
          )
        );

      }
    }
    print(_catContainer.length);

    return _catContainer;

  }


  Container _cardCategory( Map cat ){

    num _percent = 0;

    if( cat["input"] && _totalInputs > 0)
      _percent = cat["value"]*100 / _totalInputs;
    else
      _percent = cat["value"]*100 / _totalOutputs;


    List<Map> chartData = [
      {"name":cat["name"], "value": num.parse( _percent.toStringAsFixed(2)), "color": cat["input"]? Colors.green: Colors.red[700]},
      {"name":"saldo", "value": 100-_percent, "color": Color(0xff3e563e)},

    ];


    return Container(
      margin: EdgeInsets.all(5),
      child: Card(
        color: Color(0xff1f2f22),
        child: GestureDetector(
          onTap: ()=>Get.toNamed("/ListMovements",arguments: [ cat["id"], _dteStart, _dteEnd ]),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("${chartData[0]["value"]}%", style: TextStyle(
                color: Get.theme.accentTextTheme.button.color,
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),),
              Container(
                height: Get.width * 0.35,
                child: SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<Map, String>(
                        dataSource: chartData,
                        pointColorMapper:(Map data,  _) => data["color"],
                        xValueMapper: (Map data, _) => data["name"],
                        yValueMapper: (Map data, _) => data["value"]
                    )
                  ],
                ),
              ),
              Text( 
                cat["name"] ,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffced9df)
                ),
              ),
              SizedBox(height: 5),
              Text(
                _moneyFmt.format(cat["value"]),
                style: Get.textTheme.subtitle2,
              ),
              SizedBox(height: 10,)
            ],
          ),
        )
      ),
    );
  }
}


