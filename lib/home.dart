import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  static const int _maxInputLength = 20;

  void _onButtonPressed(String value) {
    setState(() {
      if (_controller.text == 'ERR') {
        _controller.clear();
      }
      if (value == 'CE') {
        _controller.clear();
      } else if (value == 'C') {
        _controller.text = _controller.text.substring(0, _controller.text.length - 1);
      } else if (value == '=') {
        _evaluateExpression();
      } else {
        if (_controller.text.length < _maxInputLength) {
          _controller.text += value;
        }
      }
    });
  }

  void _evaluateExpression() {
    String expression = _controller.text;
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _controller.text = eval.toString();
    } catch (e) {
      _controller.text = 'ERR';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 32),
          SizedBox(
            width: 288.0,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                hintText: '0',
              ),
              style: const TextStyle(fontSize: 24),
              readOnly: true,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton('('),
                  _buildButton(')'),
                  _buildButton('CE'),
                  _buildButton('C'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('÷', color: Colors.yellow),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('×', color: Colors.yellow),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-', color: Colors.yellow),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildButton('0',),
                  _buildButton('.',),
                  _buildButton('=', color: Colors.lightGreenAccent),
                  _buildButton('+', color: Colors.yellow),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value, {Color? color}) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(value),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(72, 72),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: color,
      ),
      child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
