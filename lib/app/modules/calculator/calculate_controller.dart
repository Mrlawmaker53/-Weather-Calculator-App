import 'package:get/get.dart';

class CalculatorController extends GetxController {
  var displayText = '0'.obs;
  String previousText = '';
  String currentText = '';
  String operator = '';

  void onButtonPressed(String value) {
    if (value == 'AC') {
      displayText.value = '0';
      previousText = '';
      currentText = '';
      operator = '';
    } else if (value == '+' || value == '-' || value == 'x' || value == '/') {
      if (previousText.isNotEmpty && currentText.isNotEmpty) {
        calculate();
      }
      operator = value;
      previousText = displayText.value;
      currentText = '';
    } else if (value == '=') {
      calculate();
      operator = '';
    } else if (value == '+/-') {
      if (currentText.isNotEmpty) {
        if (currentText.startsWith('-')) {
          currentText = currentText.substring(1);
        } else {
          currentText = '-' + currentText;
        }
        displayText.value = currentText;
      }
    } else if (value == '%') {
      if (currentText.isNotEmpty) {
        currentText = (double.parse(currentText) / 100).toString();
        displayText.value = currentText;
      }
    } else if (value == '.') {
      if (!currentText.contains('.')) {
        currentText += '.';
        displayText.value = currentText;
      }
    } else {
      currentText += value;
      displayText.value = currentText;
    }
  }

  void calculate() {
    double result = 0.0;
    double num1 = double.parse(previousText);
    double num2 = double.parse(currentText);

    switch (operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case 'x':
        result = num1 * num2;
        break;
      case '/':
        result = num1 / num2;
        break;
    }
    currentText = result.toString();
    displayText.value = currentText;
  }
}
