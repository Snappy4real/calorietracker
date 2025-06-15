import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAddSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentFoods;
  final Function(Map<String, dynamic>) onFoodTap;

  const QuickAddSectionWidget({
    super.key,
    required this.recentFoods,
    required this.onFoodTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quick Add",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () => onFoodTap({}),
              child: Text(
                "View All",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recentFoods.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final food = recentFoods[index];
              return _buildQuickAddItem(food);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAddItem(Map<String, dynamic> food) {
    return GestureDetector(
      onTap: () => onFoodTap(food),
      child: Container(
        width: 20.w,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              ),
              child: ClipOval(
                child: food["image"] != null
                    ? CustomImageWidget(
                        imageUrl: food["image"] as String,
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.cover,
                      )
                    : CustomIconWidget(
                        iconName: 'restaurant',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              food["name"] as String? ?? "",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
