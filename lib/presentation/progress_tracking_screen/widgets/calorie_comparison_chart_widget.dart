import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CalorieComparisonChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> calorieData;
  final String selectedPeriod;
  final bool isLoading;

  const CalorieComparisonChartWidget({
    super.key,
    required this.calorieData,
    required this.selectedPeriod,
    required this.isLoading,
  });

  @override
  State<CalorieComparisonChartWidget> createState() =>
      _CalorieComparisonChartWidgetState();
}

class _CalorieComparisonChartWidgetState
    extends State<CalorieComparisonChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: AppTheme.getWarningColor(true),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Calorie Intake vs Goal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                _buildAverageIntake(),
              ],
            ),
            const SizedBox(height: 20),
            widget.isLoading
                ? _buildLoadingState()
                : SizedBox(
                    height: 200,
                    child: BarChart(
                      _buildBarChartData(),
                    ),
                  ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageIntake() {
    if (widget.calorieData.isEmpty) return const SizedBox.shrink();

    final avgIntake = widget.calorieData
            .map((data) => data["consumed"] as int)
            .reduce((a, b) => a + b) /
        widget.calorieData.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Avg: ${avgIntake.round()} cal',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
    );
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 2500,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final data = widget.calorieData[group.x.toInt()];
            final date = DateTime.parse(data["date"] as String);
            final consumed = data["consumed"] as int;
            final goal = data["goal"] as int;
            final difference = consumed - goal;

            return BarTooltipItem(
              '${date.day}/${date.month}\nConsumed: $consumed cal\nGoal: $goal cal\n${difference >= 0 ? '+' : ''}$difference cal',
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < widget.calorieData.length) {
                final date =
                    DateTime.parse(widget.calorieData[index]["date"] as String);
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${date.day}/${date.month}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
              return const Text('');
            },
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 500,
            getTitlesWidget: (value, meta) {
              return Text(
                '${(value / 1000).toStringAsFixed(1)}k',
                style: Theme.of(context).textTheme.bodySmall,
              );
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: widget.calorieData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final consumed = (data["consumed"] as int).toDouble();
        final goal = (data["goal"] as int).toDouble();
        final isTouched = index == touchedIndex;

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: consumed,
              color: consumed > goal
                  ? AppTheme.getWarningColor(true)
                  : AppTheme.getSuccessColor(true),
              width: isTouched ? 20 : 16,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
          showingTooltipIndicators: isTouched ? [0] : [],
        );
      }).toList(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 500,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem(
          color: AppTheme.getSuccessColor(true),
          label: 'Within Goal',
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          color: AppTheme.getWarningColor(true),
          label: 'Over Goal',
        ),
        const Spacer(),
        Text(
          'Tap bars for details',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
