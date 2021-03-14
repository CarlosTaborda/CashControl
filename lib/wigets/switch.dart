import 'package:flutter/material.dart';
class MySwitch extends StatefulWidget {

  final void Function(bool) onChange;
  final bool initValue;
  final String inputTitle;
  final String outputTitle;
  final Color incomeColor;
  final Color outColor;

  MySwitch({
    Key key, 
    @required this.initValue, 
    @required this.onChange, 
    this.inputTitle="", 
    this.outputTitle="",
    @required this.incomeColor,
    @required this.outColor

  }) : super(key: key);

  @override
  _MySwitchState createState() => _MySwitchState( initValue, onChange, inputTitle, outputTitle, incomeColor, outColor);
}

class _MySwitchState extends State<MySwitch> {

  bool _value;
  Function(bool)  _onChange;
  String _inputTitle;
  String _outputTitle;
  Color _incomeColor;
  Color _outColor;



  _MySwitchState( this._value, this._onChange, this._inputTitle, this._outputTitle, this._incomeColor, this._outColor );


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 200,
      height: 40,
      child: AnimatedSwitcher(
        duration: Duration( milliseconds: 200 ),
        child: _value? _moneyInput():_moneyOutput(),
        switchInCurve: Curves.bounceInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(child: child, opacity: animation);
        }

      ),
    );
  }

  Widget _moneyInput(){
    return Row(
      key: UniqueKey(),
      children: [
        Expanded(
          child:TextButton(
            onPressed: (){
              setState(() {
                _value= true;
                _onChange( _value );
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(_incomeColor)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( Icons.arrow_downward, color: Colors.white, ),
                Text(
                  _inputTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child:TextButton(
            onPressed: (){
              setState(() {
                _value= false;
                _onChange( _value );
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( Icons.arrow_upward, color: Colors.white, ),
                Text(
                  _outputTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
          ),
          flex: 1,
        )
      ],
    );
  }

  Widget _moneyOutput(){
    return Row(
      key: UniqueKey(),
      children: [
        Expanded(
          child: TextButton(
            onPressed: (){
              setState(() {
                _value= true;
                _onChange( _value );
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( Icons.arrow_downward, color: Colors.white, ),
                Text(
                  _inputTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
          ),
          flex: 1,
        
        ),
        Expanded(
          child: TextButton(
            onPressed: (){
              setState(() {
                _value= false;
                _onChange( _value );
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(_outColor)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( Icons.arrow_upward, color: Colors.white, ),
                Text(
                  _outputTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
          ),
          flex: 1,
        
        )
      ],
    );
  }


}
