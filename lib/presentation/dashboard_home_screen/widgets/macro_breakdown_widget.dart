import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MacroBreakdownWidget extends StatelessWidget {
  final Map<String, dynamic> macros;

  const MacroBreakdownWidget({
    super.key,
    required this.macros,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Macro Breakdown",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildMacroItem(
            "Carbs",
            (macros["carbs"] as Map<String, dynamic>)["current"] as int,
            (macros["carbs"] as Map<String, dynamic>)["goal"] as int,
            AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 2.h),
          _buildMacroItem(
            "Protein",
            (macros["protein"] as Map<String, dynamic>)["current"] as int,
            (macros["protein"] as Map<String, dynamic>)["goal"] as int,
            AppTheme.getSuccessColor(true),
          ),
          SizedBox(height: 2.h),
          _buildMacroItem(
            "Fat",
            (macros["fat"] as Map<String, dynamic>)["current"] as int,
            (macros["fat"] as Map<String, dynamic>)["goal"] as int,
            AppTheme.getWarningColor(true),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String name, int current, int goal, Color color) {
    final progress = current / goal;
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${current}g / ${goal}g",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              "$percentage%",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
