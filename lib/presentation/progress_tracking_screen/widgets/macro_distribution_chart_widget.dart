import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MacroDistributionChartWidget extends StatefulWidget {
  final Map<String, dynamic> macroData;
  final bool isLoading;

  const MacroDistributionChartWidget({
    super.key,
    required this.macroData,
    required this.isLoading,
  });

  @override
  State<MacroDistributionChartWidget> createState() =>
      _MacroDistributionChartWidgetState();
}

class _MacroDistributionChartWidgetState
    extends State<MacroDistributionChartWidget> {
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
                  iconName: 'pie_chart',
                  color: AppTheme.lightTheme.secondaryHeaderColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Macro Distribution',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            widget.isLoading
                ? _buildLoadingState()
                : Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 150,
                          child: PieChart(
                            _buildPieChartData(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: _buildMacroLegend(),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 150,
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
    );
  }

  PieChartData _buildPieChartData() {
    final protein = widget.macroData["protein"] as double;
    final carbs = widget.macroData["carbs"] as double;
    final fats = widget.macroData["fats"] as double;

    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      borderData: FlBorderData(show: false),
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: [
        PieChartSectionData(
          color: AppTheme.lightTheme.primaryColor,
          value: protein,
          title: touchedIndex == 0 ? '${protein.toInt()}%' : '',
          radius: touchedIndex == 0 ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: AppTheme.getWarningColor(true),
          value: carbs,
          title: touchedIndex == 1 ? '${carbs.toInt()}%' : '',
          radius: touchedIndex == 1 ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: AppTheme.getSuccessColor(true),
          value: fats,
          title: touchedIndex == 2 ? '${fats.toInt()}%' : '',
          radius: touchedIndex == 2 ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroLegend() {
    final protein = widget.macroData["protein"] as double;
    final carbs = widget.macroData["carbs"] as double;
    final fats = widget.macroData["fats"] as double;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          color: AppTheme.lightTheme.primaryColor,
          label: 'Protein',
          percentage: protein,
          icon: 'fitness_center',
        ),
        const SizedBox(height: 12),
        _buildLegendItem(
          color: AppTheme.getWarningColor(true),
          label: 'Carbs',
          percentage: carbs,
          icon: 'grain',
        ),
        const SizedBox(height: 12),
        _buildLegendItem(
          color: AppTheme.getSuccessColor(true),
          label: 'Fats',
          percentage: fats,
          icon: 'opacity',
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required double percentage,
    required String icon,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${percentage.toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
