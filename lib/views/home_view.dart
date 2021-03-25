
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/movement_controller.dart';
import '../models/database.dart';
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
          return Column(children: []);
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

    if( _totalInputs > 0)
      _percentOutput = (_totalOutputs*100)/_totalInputs;

    final List<Map<String, dynamic>> chartData = [
        {"name":"EGRESO", "value":_percentOutput>100?100:_percentOutput, "color":Colors.red},
        {"name":"INGRESO", "value":(100-_percentOutput < 0 ? 0: 100 - _percentOutput), "color":Colors.green},
    ];

    element.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10), 
        child: Center(
          child: Text("Balance", style: 
            TextStyle(
              color: Color(0xffced9df),
              fontSize: 30,
            )
          )
        )
      )
    );



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
                            height: 150,
                            width: 150,
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
          onTap: ()=>Get.toNamed("/MovementsChart", arguments: [ _totalInputs, _totalOutputs, _listCategories]),
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
        trailing: Icon( e.category.type == 1? Icons.arrow_downward : Icons.arrow_upward, color: e.category.type==1? Colors.green:Colors.red,),
      ) 
    ).toList());


    return element;
  }
}



class CreateEditMovement extends StatefulWidget {

  final bool edit;
  CreateEditMovement({Key key, this.edit:false}) : super(key: key);

  @override
  _CreateEditMovementState createState() => _CreateEditMovementState(edit);
}

class _CreateEditMovementState extends State<CreateEditMovement> with SingleTickerProviderStateMixin {

  bool _edit;
  TabController _tabController;
  final _descriptionCtrl = TextEditingController();
  final _valueCtrl       = TextEditingController();
  String _color          = "";
  int _categoryId        = null;
  final _formKey         = GlobalKey<FormState>();
  DateTime _dateMovement = DateTime.now();
  final _movementCtrl    = MovementController();

  _CreateEditMovementState( this._edit );

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_edit ? "Editar Movimiento" : "Nuevo Movimiento"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: _form()
      )
    );
  }


  Widget _form(){
    return Form(
        key: _formKey,
        child : ListView(
          children: [
            SizedBox(height: Get.height*0.05,),
            _descriptionTextInput(),
            SizedBox(height:10),
            _valueTextInput(),
            SizedBox(height:10),
            _selectDateInput(),
            SizedBox(height:10),
            PreferredSize(
              preferredSize: Size(Get.width/2, 20),
              child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: Get.width/2,
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.all(2),
                  indicator: BoxDecoration(
                    
                    border: Border(
                      bottom: BorderSide(style: BorderStyle.solid,width: 5, color: Color(0xFF7993a0) ),
                      
                    )
                  ),
                  tabs:[
                    Tab(text:"GASTOS"), 
                    Tab(text:"INGRESOS"),
                  ],
                  indicatorColor: Color(0xFF7993A0),            
                ),
              ),
            )
            ),
            Container(
              width: Get.width,
              height: 120,
              child: TabBarView(
                controller: _tabController,

                children: [
                  _listCategories(0),
                  _listCategories(1)
                ]
              ),
            ),
            ElevatedButton(onPressed: ()=>createMovement(), child: Text("CREAR"))
            
          ]
        ),
      );
  }

  void createMovement(){
    setState(() {
      print( "createMovement( ${_descriptionCtrl.text}, $_categoryId, ${_valueCtrl.text}, ${_dateMovement.toString()} )" );
      _movementCtrl.create(_descriptionCtrl.text, _categoryId, double.parse( _valueCtrl.text ), _dateMovement, true).then((value) => Get.back());
    });
  }


  Widget _listCategories( int type ){
    return FutureBuilder(
      future: _movementCtrl.getByTypeAndState(type, true),
      builder: ( BuildContext context, AsyncSnapshot<List<Category>> snapshot ){

        if( snapshot.hasData ){
          return ListView(
            children: snapshot.data.map(
              (c) => ListTile(
                leading: Icon(_color==c.color? Icons.check : Icons.circle, size: 50, color: Color( int.parse(c.color, radix: 16) ),),
                onTap: (){
                  setState(() {
                    _color = c.color;
                    _categoryId = c.id;
                  });
                },
                title: Container(
                    width: Get.width*0.5,
                    child: Text(c.name,style: TextStyle(color:Colors.white,),
                  ),
                ),
              ) 
            
            ).toList(),
          );
        }

        return Center( child: Text("NO HAY CATEGORIAS", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold)));
      }
    );
  }


  TextFormField _descriptionTextInput(){
    return TextFormField(
      controller: _descriptionCtrl,
      decoration: InputDecoration(
        labelText: "DESCRIPCIÓN",
        labelStyle: TextStyle(
          color: Color(0xff091008)
        )

      ),
    );
  }

  TextFormField _valueTextInput(){
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
      controller: _valueCtrl,
      decoration: InputDecoration(
        
        labelText: "VALOR",
        labelStyle: TextStyle(
          color: Color(0xff091008)
        )

      ),
    );
  }


  ElevatedButton _selectDateInput(){
    return ElevatedButton(
      onPressed: ()=>_showDatePicker(), 
      child: Text(
        DateTime.now().toString().substring(0,10)
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[900])
      ),
    );
  }


  void _showDatePicker() async {
    final DateTime picked = await showDatePicker(
      locale: Locale("es"),
      context: Get.context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

  

    if( picked != null && picked != _dateMovement ){
      setState(() {
        _dateMovement = picked;
      });
    }
  }
}

class MovementsChart extends StatefulWidget {
  MovementsChart({Key key}) : super(key: key);

  @override
  _MovementsChartState createState() => _MovementsChartState();
}

class _MovementsChartState extends State<MovementsChart> {

  double _totalInputs = 0;
  double _totalOutputs = 0;
  List<Map> _categories;
  final _moneyFmt = NumberFormat.simpleCurrency();

  @override
  void initState() {
    
    super.initState();
    _totalInputs  = Get.arguments[0];
    _totalOutputs = Get.arguments[1];
    _categories   = Get.arguments[2];


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

  Container _getBody(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _panel(),
          SizedBox(
            height: Get.height *0.60,
            child: ListView(
              children: _getCategories(),
              
            ),
          )
          
        ],
      )
    );
  }

  Container _panel(){
    return Container(
      height: Get.height * 0.30,
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
                        _moneyFmt.format(_totalInputs),
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
      {"name":cat["name"], "value": _percent, "color": cat["input"]? Colors.green: Colors.red[700]},
      {"name":"saldo", "value": 100-_percent, "color": Color(0xff3e563e)},

    ];


    return Container(
      margin: EdgeInsets.all(5),
      child: Card(
        color: Color(0xff1f2f22),
        child: Column(
          children: [
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
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}