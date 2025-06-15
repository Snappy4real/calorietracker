import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IngredientListWidget extends StatelessWidget {
  final List<String> ingredients;
  final List<String> allergens;

  const IngredientListWidget({
    super.key,
    required this.ingredients,
    required this.allergens,
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
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'list_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Ingredients',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Ingredients List
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: ingredients.map((ingredient) {
                final isAllergen = _isAllergen(ingredient);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isAllergen
                        ? AppTheme.getErrorColor(true).withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
                    border: Border.all(
                      color: isAllergen
                          ? AppTheme.getErrorColor(true)
                          : AppTheme.lightTheme.colorScheme.primary,
                      width: isAllergen ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isAllergen)
                        Padding(
                          padding: EdgeInsets.only(right: 1.w),
                          child: CustomIconWidget(
                            iconName: 'warning',
                            color: AppTheme.getErrorColor(true),
                            size: 14,
                          ),
                        ),
                      Text(
                        ingredient,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isAllergen
                              ? AppTheme.getErrorColor(true)
                              : AppTheme.lightTheme.colorScheme.primary,
                          fontWeight:
                              isAllergen ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Allergen Information
            if (allergens.isNotEmpty && !allergens.contains("None"))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.getErrorColor(true).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            AppTheme.getErrorColor(true).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'warning',
                              color: AppTheme.getErrorColor(true),
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Allergen Warning',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.getErrorColor(true),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Contains: ${allergens.join(", ")}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.getErrorColor(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // No Allergens Message
            if (allergens.contains("None"))
              Column(
                children: [
                  SizedBox(height: 2.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.getSuccessColor(true)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.getSuccessColor(true),
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'No known allergens',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.getSuccessColor(true),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  bool _isAllergen(String ingredient) {
    if (allergens.contains("None")) return false;

    final commonAllergens = [
      'milk',
      'eggs',
      'fish',
      'shellfish',
      'tree nuts',
      'peanuts',
      'wheat',
      'soybeans',
      'dairy',
      'egg',
      'nut',
      'soy',
      'gluten'
    ];

    final ingredientLower = ingredient.toLowerCase();
    return commonAllergens.any((allergen) =>
        ingredientLower.contains(allergen) ||
        allergens.any((a) => ingredientLower.contains(a.toLowerCase())));
  }
}
