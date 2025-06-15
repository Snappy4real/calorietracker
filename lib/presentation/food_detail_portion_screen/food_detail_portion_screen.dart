import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ingredient_list_widget.dart';
import './widgets/meal_assignment_widget.dart';
import './widgets/nutrition_facts_widget.dart';
import './widgets/portion_control_widget.dart';

class FoodDetailPortionScreen extends StatefulWidget {
  const FoodDetailPortionScreen({super.key});

  @override
  State<FoodDetailPortionScreen> createState() =>
      _FoodDetailPortionScreenState();
}

class _FoodDetailPortionScreenState extends State<FoodDetailPortionScreen> {
  // Mock food data
  final Map<String, dynamic> foodData = {
    "id": 1,
    "name": "Grilled Chicken Breast",
    "brand": "Fresh Market",
    "image":
        "https://images.pexels.com/photos/106343/pexels-photo-106343.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "servingSize": "100g",
    "servingUnit": "grams",
    "calories": 165,
    "macronutrients": {
      "protein": 31.0,
      "carbs": 0.0,
      "fat": 3.6,
      "fiber": 0.0,
      "sugar": 0.0,
      "sodium": 74.0
    },
    "vitamins": {
      "vitaminA": 0.0,
      "vitaminC": 0.0,
      "calcium": 15.0,
      "iron": 1.0
    },
    "ingredients": ["Chicken breast", "Salt", "Black pepper", "Olive oil"],
    "allergens": ["None"],
    "barcode": "1234567890123"
  };

  double currentQuantity = 1.0;
  String selectedUnit = "grams";
  String selectedMeal = "lunch";
  DateTime selectedDate = DateTime.now();
  bool isFavorite = false;

  final List<String> availableUnits = ["grams", "ounces", "cups", "pieces"];
  final List<String> mealTypes = ["breakfast", "lunch", "dinner", "snacks"];

  double get calculatedCalories {
    double baseCalories = (foodData["calories"] as int).toDouble();
    return baseCalories * currentQuantity;
  }

  Map<String, double> get calculatedMacros {
    final macros = foodData["macronutrients"] as Map<String, dynamic>;
    return {
      "protein": (macros["protein"] as double) * currentQuantity,
      "carbs": (macros["carbs"] as double) * currentQuantity,
      "fat": (macros["fat"] as double) * currentQuantity,
      "fiber": (macros["fiber"] as double) * currentQuantity,
      "sugar": (macros["sugar"] as double) * currentQuantity,
      "sodium": (macros["sodium"] as double) * currentQuantity,
    };
  }

  void _updateQuantity(double newQuantity) {
    setState(() {
      currentQuantity = newQuantity;
    });
  }

  void _updateUnit(String newUnit) {
    setState(() {
      selectedUnit = newUnit;
    });
  }

  void _updateMeal(String newMeal) {
    setState(() {
      selectedMeal = newMeal;
    });
  }

  void _updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _logFood() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${foodData["name"]} (${calculatedCalories.toStringAsFixed(0)} cal) to $selectedMeal',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodData["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (foodData["brand"] != null)
                          Text(
                            foodData["brand"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isFavorite
                            ? AppTheme.lightTheme.colorScheme.primaryContainer
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: isFavorite ? 'favorite' : 'favorite_border',
                        color: isFavorite
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Food Image and Portion Control
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Food Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: CustomImageWidget(
                              imageUrl: foodData["image"] as String,
                              width: double.infinity,
                              height: 25.h,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Portion Control
                          Padding(
                            padding: EdgeInsets.all(4.w),
                            child: PortionControlWidget(
                              currentQuantity: currentQuantity,
                              selectedUnit: selectedUnit,
                              availableUnits: availableUnits,
                              servingSize: foodData["servingSize"] as String,
                              onQuantityChanged: _updateQuantity,
                              onUnitChanged: _updateUnit,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Calorie Summary Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary,
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Calories',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${calculatedCalories.toStringAsFixed(0)} cal',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          CustomIconWidget(
                            iconName: 'local_fire_department',
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Nutrition Facts
                    NutritionFactsWidget(
                      macronutrients: calculatedMacros,
                      vitamins: foodData["vitamins"] as Map<String, dynamic>,
                    ),

                    SizedBox(height: 3.h),

                    // Ingredients List
                    if (foodData["ingredients"] != null)
                      IngredientListWidget(
                        ingredients:
                            (foodData["ingredients"] as List).cast<String>(),
                        allergens:
                            (foodData["allergens"] as List).cast<String>(),
                      ),

                    SizedBox(height: 3.h),

                    // Meal Assignment
                    MealAssignmentWidget(
                      selectedMeal: selectedMeal,
                      selectedDate: selectedDate,
                      mealTypes: mealTypes,
                      onMealChanged: _updateMeal,
                      onDateChanged: _updateDate,
                    ),

                    SizedBox(height: 10.h), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Log Food Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _logFood,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Log Food (${calculatedCalories.toStringAsFixed(0)} cal)',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
