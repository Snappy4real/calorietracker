import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/user_data_form_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4; // 3 intro pages + 1 data collection page

  // User data collection variables
  int _age = 25;
  String _gender = 'Male';
  int _height = 170; // cm
  int _weight = 70; // kg
  String _activityLevel = 'Moderate';
  String _primaryGoal = 'Maintain Weight';

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Track Your Food',
      'description':
          'Easily log meals with our comprehensive food database and barcode scanner for accurate calorie tracking.',
      'imageUrl':
          'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
      'features': [
        'Barcode scanning',
        'Comprehensive food database',
        'Quick meal logging',
        'Nutritional breakdown'
      ]
    },
    {
      'title': 'Monitor Exercise',
      'description':
          'Record your workouts and activities to track calories burned and maintain an active lifestyle.',
      'imageUrl':
          'https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg?auto=compress&cs=tinysrgb&w=400',
      'features': [
        'Activity tracking',
        'Calorie burn calculation',
        'Exercise database',
        'Progress monitoring'
      ]
    },
    {
      'title': 'Achieve Your Goals',
      'description':
          'Set personalized calorie goals and track your progress with detailed insights and visual charts.',
      'imageUrl':
          'https://images.pexels.com/photos/6975474/pexels-photo-6975474.jpeg?auto=compress&cs=tinysrgb&w=400',
      'features': [
        'Personalized goals',
        'Progress visualization',
        'Daily insights',
        'Achievement tracking'
      ]
    }
  ];

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
  }

  void _completeOnboarding() {
    HapticFeedback.mediumImpact();
    // Calculate estimated daily calorie target
    int estimatedCalories = _calculateDailyCalories();

    // Navigate to dashboard with collected data
    Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
  }

  int _calculateDailyCalories() {
    // Basic BMR calculation using Mifflin-St Jeor Equation
    double bmr;
    if (_gender == 'Male') {
      bmr = 88.362 + (13.397 * _weight) + (4.799 * _height) - (5.677 * _age);
    } else {
      bmr = 447.593 + (9.247 * _weight) + (3.098 * _height) - (4.330 * _age);
    }

    // Activity multiplier
    double activityMultiplier;
    switch (_activityLevel) {
      case 'Sedentary':
        activityMultiplier = 1.2;
        break;
      case 'Light':
        activityMultiplier = 1.375;
        break;
      case 'Moderate':
        activityMultiplier = 1.55;
        break;
      case 'Active':
        activityMultiplier = 1.725;
        break;
      case 'Very Active':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.55;
    }

    double tdee = bmr * activityMultiplier;

    // Adjust based on goal
    switch (_primaryGoal) {
      case 'Lose Weight':
        return (tdee - 500).round(); // 500 calorie deficit
      case 'Gain Weight':
        return (tdee + 500).round(); // 500 calorie surplus
      default:
        return tdee.round(); // Maintain weight
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (_currentPage < _totalPages - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(height: 6.h),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  if (index < _onboardingData.length) {
                    return OnboardingPageWidget(
                      title: _onboardingData[index]['title'],
                      description: _onboardingData[index]['description'],
                      imageUrl: _onboardingData[index]['imageUrl'],
                      features: ((_onboardingData[index]['features'] as List)
                          .cast<String>()),
                    );
                  } else {
                    return UserDataFormWidget(
                      age: _age,
                      gender: _gender,
                      height: _height,
                      weight: _weight,
                      activityLevel: _activityLevel,
                      primaryGoal: _primaryGoal,
                      onAgeChanged: (value) => setState(() => _age = value),
                      onGenderChanged: (value) =>
                          setState(() => _gender = value),
                      onHeightChanged: (value) =>
                          setState(() => _height = value),
                      onWeightChanged: (value) =>
                          setState(() => _weight = value),
                      onActivityLevelChanged: (value) =>
                          setState(() => _activityLevel = value),
                      onPrimaryGoalChanged: (value) =>
                          setState(() => _primaryGoal = value),
                      estimatedCalories: _calculateDailyCalories(),
                    );
                  }
                },
              ),
            ),

            // Page indicator and navigation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _totalPages,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: _currentPage == index ? 8.w : 2.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Navigation button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: AppTheme.lightTheme.elevatedButtonTheme.style
                          ?.copyWith(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.h),
                          ),
                        ),
                      ),
                      child: Text(
                        _currentPage == _totalPages - 1
                            ? 'Get Started'
                            : 'Next',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
