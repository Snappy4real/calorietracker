import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WeightProgressChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> weightData;
  final String selectedPeriod;
  final bool isLoading;

  const WeightProgressChartWidget({
    super.key,
    required this.weightData,
    required this.selectedPeriod,
    required this.isLoading,
  });

  @override
  State<WeightProgressChartWidget> createState() =>
      _WeightProgressChartWidgetState();
}

class _WeightProgressChartWidgetState extends State<WeightProgressChartWidget> {
  int? touchedIndex;

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
                  iconName: 'monitor_weight',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Weight Progress',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                _buildWeightChange(),
              ],
            ),
            const SizedBox(height: 20),
            widget.isLoading
                ? _buildLoadingState()
                : SizedBox(
                    height: 200,
                    child: LineChart(
                      _buildLineChartData(),
                    ),
                  ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChange() {
    if (widget.weightData.isEmpty) return const SizedBox.shrink();

    final firstWeight = widget.weightData.first["weight"] as double;
    final lastWeight = widget.weightData.last["weight"] as double;
    final change = lastWeight - firstWeight;
    final isPositive = change > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? AppTheme.getErrorColor(true).withValues(alpha: 0.1)
            : AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isPositive ? 'trending_up' : 'trending_down',
            color: isPositive
                ? AppTheme.getErrorColor(true)
                : AppTheme.getSuccessColor(true),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${change.abs().toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isPositive
                      ? AppTheme.getErrorColor(true)
                      : AppTheme.getSuccessColor(true),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
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

  LineChartData _buildLineChartData() {
    final spots = widget.weightData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value["weight"] as double);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 0.5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < widget.weightData.length) {
                final date =
                    DateTime.parse(widget.weightData[index]["date"] as String);
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
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.5,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toStringAsFixed(1)}kg',
                style: Theme.of(context).textTheme.bodySmall,
              );
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      minX: 0,
      maxX: (widget.weightData.length - 1).toDouble(),
      minY: spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 1,
      maxY: spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 1,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.7),
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppTheme.lightTheme.primaryColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final index = touchedSpot.x.toInt();
              if (index >= 0 && index < widget.weightData.length) {
                final date =
                    DateTime.parse(widget.weightData[index]["date"] as String);
                return LineTooltipItem(
                  '${touchedSpot.y.toStringAsFixed(1)} kg\n${date.day}/${date.month}/${date.year}',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Weight (kg)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
        ),
        const Spacer(),
        Text(
          'Tap points for details',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}
