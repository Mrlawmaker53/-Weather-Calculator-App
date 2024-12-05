import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/theme/app_theme.dart';

import '../../routes/app_pages.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final DashboardController themeController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  themeController.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: themeController.toggleTheme,
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.CALCULATE);
              },
              child: const Text('Go to Calculate'),
            ),
            const SizedBox(height: 20), // Add some space between the buttons
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.HOME);
              },
              child: const Text('Go to weather App'),
            ),
            const SizedBox(height: 20), // Add some space between the buttons
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.Quizz);
              },
              child: const Text('Go to Quiz App'),
            ),
          ],
        ),
      ),
    );
  }
}
