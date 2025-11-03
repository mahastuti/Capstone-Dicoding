import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/performance_analytics/performance_analytics.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/quiz_interface/quiz_interface.dart';
import '../presentation/quiz_results/quiz_results.dart';
import '../presentation/homepage/homepage.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String performanceAnalytics = '/performance-analytics';
  static const String userProfile = '/user-profile';
  static const String quizInterface = '/quiz-interface';
  static const String quizResults = '/quiz-results';
  static const String homepage = '/homepage';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    performanceAnalytics: (context) => const PerformanceAnalytics(),
    userProfile: (context) => const UserProfile(),
    quizInterface: (context) => const QuizInterface(),
    quizResults: (context) => const QuizResults(),
    homepage: (context) => const Homepage(),
  };
}
