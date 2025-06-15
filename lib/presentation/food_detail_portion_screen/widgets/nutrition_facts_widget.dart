import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NutritionFactsWidget extends StatelessWidget {
  final Map<String, double> macronutrients;
  final Map<String, dynamic> vitamins;

  const NutritionFactsWidget({
    super.key,
    required this.macronutrients,
    required this.vitamins,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Text(
              'Nutrition Facts',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Macronutrients
                _buildNutrientSection('Macronutrients', [
                  _buildNutrientRow(
                    'Protein',
                    '${macronutrients["protein"]?.toStringAsFixed(1)}g',
                    _calculateDailyValue(macronutrients["protein"] ?? 0, 50),
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                  _buildNutrientRow(
                    'Carbohydrates',
                    '${macronutrients["carbs"]?.toStringAsFixed(1)}g',
                    _calculateDailyValue(macronutrients["carbs"] ?? 0, 300),
                    AppTheme.lightTheme.colorScheme.secondary,
                  ),
                  _buildNutrientRow(
                    'Total Fat',
                    '${macronutrients["fat"]?.toStringAsFixed(1)}g',
                    _calculateDailyValue(macronutrients["fat"] ?? 0, 65),
                    AppTheme.getWarningColor(true),
                  ),
                  _buildNutrientRow(
                    'Dietary Fiber',
                    '${macronutrients["fiber"]?.toStringAsFixed(1)}g',
                    _calculateDailyValue(macronutrients["fiber"] ?? 0, 25),
                    AppTheme.getSuccessColor(true),
                  ),
                ]),

                SizedBox(height: 3.h),

                // Other Nutrients
                _buildNutrientSection('Other Nutrients', [
                  _buildNutrientRow(
                    'Sugar',
                    '${macronutrients["sugar"]?.toStringAsFixed(1)}g',
                    _calculateDailyValue(macronutrients["sugar"] ?? 0, 50),
                    AppTheme.getErrorColor(true),
                  ),
                  _buildNutrientRow(
                    'Sodium',
                    '${macronutrients["sodium"]?.toStringAsFixed(0)}mg',
                    _calculateDailyValue(macronutrients["sodium"] ?? 0, 2300),
                    AppTheme.getWarningColor(true),
                  ),
                ]),

                SizedBox(height: 3.h),

                // Vitamins & Minerals
                if (vitamins.isNotEmpty)
                  _buildNutrientSection('Vitamins & Minerals', [
                    if ((vitamins["vitaminA"] as double) > 0)
                      _buildNutrientRow(
                        'Vitamin A',
                        '${(vitamins["vitaminA"] as double).toStringAsFixed(0)}IU',
                        _calculateDailyValue(
                            vitamins["vitaminA"] as double, 5000),
                        AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    if ((vitamins["vitaminC"] as double) > 0)
                      _buildNutrientRow(
                        'Vitamin C',
                        '${(vitamins["vitaminC"] as double).toStringAsFixed(0)}mg',
                        _calculateDailyValue(
                            vitamins["vitaminC"] as double, 60),
                        AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    if ((vitamins["calcium"] as double) > 0)
                      _buildNutrientRow(
                        'Calcium',
                        '${(vitamins["calcium"] as double).toStringAsFixed(0)}mg',
                        _calculateDailyValue(
                            vitamins["calcium"] as double, 1000),
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    if ((vitamins["iron"] as double) > 0)
                      _buildNutrientRow(
                        'Iron',
                        '${(vitamins["iron"] as double).toStringAsFixed(1)}mg',
                        _calculateDailyValue(vitamins["iron"] as double, 18),
                        AppTheme.getErrorColor(true),
                      ),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientSection(String title, List<Widget> nutrients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ...nutrients,
      ],
    );
  }

  Widget _buildNutrientRow(
      String name, String amount, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
              Text(
                amount,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  double _calculateDailyValue(double amount, double dailyValue) {
    return (amount / dailyValue * 100).clamp(0, 100);
  }
}
