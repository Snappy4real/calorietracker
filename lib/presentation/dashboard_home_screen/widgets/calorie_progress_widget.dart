import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalorieProgressWidget extends StatelessWidget {
  final int goal;
  final int consumed;
  final int burned;

  const CalorieProgressWidget({
    super.key,
    required this.goal,
    required this.consumed,
    required this.burned,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = goal - consumed + burned;
    final progress = consumed / goal;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Daily Calorie Goal",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // Circular Progress Chart
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 2,
                    centerSpaceRadius: 20.w,
                    sections: [
                      PieChartSectionData(
                        value: consumed.toDouble(),
                        color: AppTheme.lightTheme.primaryColor,
                        radius: 4.w,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: (goal - consumed).toDouble(),
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        radius: 4.w,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      remaining > 0 ? remaining.toString() : "0",
                      style:
                          AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: remaining > 0
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.getWarningColor(true),
                      ),
                    ),
                    Text(
                      "calories left",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                "Consumed",
                consumed.toString(),
                AppTheme.lightTheme.primaryColor,
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              _buildStatItem(
                "Burned",
                burned.toString(),
                AppTheme.getSuccessColor(true),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              _buildStatItem(
                "Goal",
                goal.toString(),
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
