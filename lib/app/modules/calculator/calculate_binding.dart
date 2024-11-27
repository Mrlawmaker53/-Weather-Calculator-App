import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'calculate_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}


class Calculator extends StatelessWidget {
  final CalculatorController controller = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Display area
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(
                  () => Text(
                controller.displayText.value,
                style: TextStyle(color: Colors.white, fontSize: 72),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          // Calculator buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  buildButtonRow(['AC', '+/-', '%', '/']),
                  buildButtonRow(['7', '8', '9', 'x']),
                  buildButtonRow(['4', '5', '6', '-']),
                  buildButtonRow(['1', '2', '3', '+']),
                  buildButtonRow(['0', '.', '=', '']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return CalcButton(
          buttonText: button,
          onPressed: () => controller.onButtonPressed(button),
        );
      }).toList(),
    );
  }
}

class CalcButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  CalcButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonText == '+' ||
                buttonText == '-' ||
                buttonText == 'x' ||
                buttonText == '/'
                ? Colors.orange
                : Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}