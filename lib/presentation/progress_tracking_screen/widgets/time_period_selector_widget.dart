import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimePeriodSelectorWidget extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const TimePeriodSelectorWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final periods = ['Daily', 'Weekly', 'Monthly'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'date_range',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Time Period',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                _buildCustomRangeButton(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: periods.map((period) {
                final isSelected = selectedPeriod == period;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: period != periods.last ? 8 : 0,
                    ),
                    child: _buildPeriodButton(
                      context: context,
                      period: period,
                      isSelected: isSelected,
                      onTap: () => onPeriodChanged(period),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _buildPresetOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton({
    required BuildContext context,
    required String period,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          period,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCustomRangeButton() {
    return TextButton.icon(
      onPressed: () {
        // Show date range picker
      },
      icon: CustomIconWidget(
        iconName: 'tune',
        color: AppTheme.lightTheme.primaryColor,
        size: 16,
      ),
      label: Text(
        'Custom',
        style: TextStyle(
          color: AppTheme.lightTheme.primaryColor,
          fontSize: 12,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildPresetOptions(BuildContext context) {
    final presets = [
      {'label': 'Last 7 days', 'value': '7d'},
      {'label': 'Last 30 days', 'value': '30d'},
      {'label': 'Last 90 days', 'value': '90d'},
    ];

    return Wrap(
      spacing: 8,
      children: presets.map((preset) {
        return ActionChip(
          label: Text(
            preset['label'] as String,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onPressed: () {
            // Handle preset selection
          },
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          side: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}