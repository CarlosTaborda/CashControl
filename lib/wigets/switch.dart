import 'package:flutter/material.dart';
class MySwitch extends StatefulWidget {

  final void Function onChange( bool );
  final bool initValue;
  final String inputTitle;
  final String outputTitle;


  MySwitch({Key key, @required this.initValue, this.onChange, this.inputTitle, this.outputTitle}) : super(key: key);

  @override
  _MySwitchState createState() => _MySwitchState( initValue, onChange, inputTitle, outputTitle);
}

class _MySwitchState extends State<MySwitch> {

  bool _value;
  VoidCallback  _onChange( bool );
  String _inputTitle;
  String _outputTitle;



  _MySwitchState( this._value, this._onChange, this._inputTitle, this._outputTitle );


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
            onPressed: ()=>_onChange( _value ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
            ),
            child: Text(_inputTitle),
          ),
          flex: 1,
        ),
        Expanded(
          child:TextButton(
            onPressed: _onChange,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
            ),
            child: Text(_outputTitle),
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
            onPressed: _onChange,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)
            ),
            child: Text(_inputTitle),
          ),
          flex: 1,
        
        ),
        Expanded(
          child: TextButton(
            onPressed: _onChange,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
            ),
            child: Text(_outputTitle),
          ),
          flex: 1,
        
        )
      ],
    );
  }


}