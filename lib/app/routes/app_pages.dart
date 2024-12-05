import 'package:get/get.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/quizz/quizz_ui.dart';
import '../modules/weather/weather_view.dart';
import '../modules/calculator/calculate_view.dart';
part 'app_routes.dart';

class AppPages {
  static const String INITIAL = Routes.DASHBOARD; // Define the initial route
  static final pages = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
    ),
    GetPage(
      name: Routes.CALCULATE,
      page: () => CalculateView(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
    ),
  GetPage(
      name: Routes.Quizz,
      page: () => QuizScreen(),
    ),
  ];
}
