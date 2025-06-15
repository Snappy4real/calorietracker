import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/dashboard_home_screen/dashboard_home_screen.dart';
import '../presentation/food_detail_portion_screen/food_detail_portion_screen.dart';
import '../presentation/progress_tracking_screen/progress_tracking_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String dashboardHomeScreen = '/dashboard-home-screen';
  static const String foodDetailPortionScreen = '/food-detail-portion-screen';
  static const String progressTrackingScreen = '/progress-tracking-screen';
  static const String profileSettingsScreen = '/profile-settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    dashboardHomeScreen: (context) => const DashboardHomeScreen(),
    foodDetailPortionScreen: (context) => const FoodDetailPortionScreen(),
    progressTrackingScreen: (context) => const ProgressTrackingScreen(),
    profileSettingsScreen: (context) => const ProfileSettingsScreen(),
  };
}
