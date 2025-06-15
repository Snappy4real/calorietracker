import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calorie_progress_widget.dart';
import './widgets/exercise_summary_widget.dart';
import './widgets/macro_breakdown_widget.dart';
import './widgets/meal_card_widget.dart';
import './widgets/quick_add_section_widget.dart';
import './widgets/water_intake_widget.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock data for dashboard
  final Map<String, dynamic> _dashboardData = {
    "dailyCalories": {
      "goal": 2000,
      "consumed": 1450,
      "burned": 300,
    },
    "recentFoods": [
      {
        "id": 1,
        "name": "Banana",
        "calories": 105,
        "image":
            "https://images.pexels.com/photos/2872755/pexels-photo-2872755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      },
      {
        "id": 2,
        "name": "Greek Yogurt",
        "calories": 130,
        "image":
            "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      },
      {
        "id": 3,
        "name": "Almonds",
        "calories": 160,
        "image":
            "https://images.pexels.com/photos/1295572/pexels-photo-1295572.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      },
    ],
    "meals": [
      {
        "type": "Breakfast",
        "calories": 420,
        "foods": [
          {"name": "Oatmeal", "calories": 150},
          {"name": "Banana", "calories": 105},
          {"name": "Almonds", "calories": 165},
        ],
      },
      {
        "type": "Lunch",
        "calories": 650,
        "foods": [
          {"name": "Grilled Chicken", "calories": 350},
          {"name": "Brown Rice", "calories": 200},
          {"name": "Vegetables", "calories": 100},
        ],
      },
      {
        "type": "Dinner",
        "calories": 380,
        "foods": [
          {"name": "Salmon", "calories": 280},
          {"name": "Sweet Potato", "calories": 100},
        ],
      },
      {
        "type": "Snacks",
        "calories": 0,
        "foods": [],
      },
    ],
    "exercise": {
      "caloriesBurned": 300,
      "activities": ["30 min Running", "15 min Strength Training"],
    },
    "waterIntake": {
      "current": 6,
      "goal": 8,
    },
    "macros": {
      "carbs": {"current": 180, "goal": 250},
      "protein": {"current": 120, "goal": 150},
      "fat": {"current": 65, "goal": 80},
    },
  };

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/progress-tracking-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/food-detail-portion-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-settings-screen');
        break;
    }
  }

  void _openFoodSearch() {
    Navigator.pushNamed(context, '/food-detail-portion-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                SizedBox(height: 3.h),

                // Calorie Progress Chart
                CalorieProgressWidget(
                  goal: (_dashboardData["dailyCalories"]
                      as Map<String, dynamic>)["goal"] as int,
                  consumed: (_dashboardData["dailyCalories"]
                      as Map<String, dynamic>)["consumed"] as int,
                  burned: (_dashboardData["dailyCalories"]
                      as Map<String, dynamic>)["burned"] as int,
                ),
                SizedBox(height: 3.h),

                // Quick Add Section
                QuickAddSectionWidget(
                  recentFoods: (_dashboardData["recentFoods"] as List)
                      .cast<Map<String, dynamic>>(),
                  onFoodTap: (food) => _openFoodSearch(),
                ),
                SizedBox(height: 3.h),

                // Meals Section
                Text(
                  "Today's Meals",
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),

                ...(_dashboardData["meals"] as List).map((meal) {
                  final mealData = meal as Map<String, dynamic>;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: MealCardWidget(
                      mealType: mealData["type"] as String,
                      calories: mealData["calories"] as int,
                      foods: (mealData["foods"] as List)
                          .cast<Map<String, dynamic>>(),
                      onAddFood: () => _openFoodSearch(),
                      onTap: () => _openFoodSearch(),
                    ),
                  );
                }),

                SizedBox(height: 2.h),

                // Exercise Summary
                ExerciseSummaryWidget(
                  caloriesBurned: ((_dashboardData["exercise"]
                      as Map<String, dynamic>)["caloriesBurned"] as int),
                  activities: ((_dashboardData["exercise"]
                          as Map<String, dynamic>)["activities"] as List)
                      .cast<String>(),
                  onLogWorkout: () =>
                      Navigator.pushNamed(context, '/progress-tracking-screen'),
                ),
                SizedBox(height: 2.h),

                // Water Intake
                WaterIntakeWidget(
                  current: ((_dashboardData["waterIntake"]
                      as Map<String, dynamic>)["current"] as int),
                  goal: ((_dashboardData["waterIntake"]
                      as Map<String, dynamic>)["goal"] as int),
                  onIncrement: () {
                    setState(() {
                      final waterData =
                          _dashboardData["waterIntake"] as Map<String, dynamic>;
                      if ((waterData["current"] as int) <
                          (waterData["goal"] as int)) {
                        waterData["current"] =
                            (waterData["current"] as int) + 1;
                      }
                    });
                  },
                ),
                SizedBox(height: 2.h),

                // Macro Breakdown
                MacroBreakdownWidget(
                  macros: (_dashboardData["macros"] as Map<String, dynamic>),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFoodSearch,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'camera_alt',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning!",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              "Let's track your calories",
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile-settings-screen'),
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            ),
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'trending_up',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'search',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
