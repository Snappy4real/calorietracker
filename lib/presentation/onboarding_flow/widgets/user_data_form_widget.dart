import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserDataFormWidget extends StatelessWidget {
  final int age;
  final String gender;
  final int height;
  final int weight;
  final String activityLevel;
  final String primaryGoal;
  final Function(int) onAgeChanged;
  final Function(String) onGenderChanged;
  final Function(int) onHeightChanged;
  final Function(int) onWeightChanged;
  final Function(String) onActivityLevelChanged;
  final Function(String) onPrimaryGoalChanged;
  final int estimatedCalories;

  const UserDataFormWidget({
    super.key,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.primaryGoal,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.onActivityLevelChanged,
    required this.onPrimaryGoalChanged,
    required this.estimatedCalories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Header
          Text(
            'Tell us about yourself',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Help us personalize your calorie goals',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 4.h),

          // Age and Gender Row
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                  title: 'Age',
                  child: _buildNumberStepper(
                    value: age,
                    min: 13,
                    max: 100,
                    onChanged: onAgeChanged,
                    suffix: 'years',
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDataCard(
                  title: 'Gender',
                  child: _buildDropdown(
                    value: gender,
                    items: ['Male', 'Female', 'Other'],
                    onChanged: onGenderChanged,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Height and Weight Row
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                  title: 'Height',
                  child: _buildNumberStepper(
                    value: height,
                    min: 100,
                    max: 250,
                    onChanged: onHeightChanged,
                    suffix: 'cm',
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildDataCard(
                  title: 'Weight',
                  child: _buildNumberStepper(
                    value: weight,
                    min: 30,
                    max: 300,
                    onChanged: onWeightChanged,
                    suffix: 'kg',
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Activity Level
          _buildDataCard(
            title: 'Activity Level',
            child: _buildDropdown(
              value: activityLevel,
              items: [
                'Sedentary',
                'Light',
                'Moderate',
                'Active',
                'Very Active'
              ],
              onChanged: onActivityLevelChanged,
            ),
          ),

          SizedBox(height: 3.h),

          // Primary Goal
          _buildDataCard(
            title: 'Primary Goal',
            child: _buildDropdown(
              value: primaryGoal,
              items: ['Lose Weight', 'Maintain Weight', 'Gain Weight'],
              onChanged: onPrimaryGoalChanged,
            ),
          ),

          SizedBox(height: 4.h),

          // Estimated Calories Display
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
              borderRadius: BorderRadius.circular(3.w),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Your Daily Calorie Goal',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '$estimatedCalories',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'calories per day',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildDataCard({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          child,
        ],
      ),
    );
  }

  Widget _buildNumberStepper({
    required int value,
    required int min,
    required int max,
    required Function(int) onChanged,
    required String suffix,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (value > min) {
              HapticFeedback.lightImpact();
              onChanged(value - 1);
            }
          },
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: value > min
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomIconWidget(
              iconName: 'remove',
              color: value > min
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              value.toString(),
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Text(
              suffix,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            if (value < max) {
              HapticFeedback.lightImpact();
              onChanged(value + 1);
            }
          },
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: value < max
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomIconWidget(
              iconName: 'add',
              color: value < max
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: AppTheme.lightTheme.colorScheme.surface,
      icon: CustomIconWidget(
        iconName: 'keyboard_arrow_down',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          HapticFeedback.selectionClick();
          onChanged(newValue);
        }
      },
    );
  }
}
