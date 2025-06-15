import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/calorie_comparison_chart_widget.dart';
import './widgets/macro_distribution_chart_widget.dart';
import './widgets/photo_progress_widget.dart';
import './widgets/statistics_card_widget.dart';
import './widgets/streak_counter_widget.dart';
import './widgets/time_period_selector_widget.dart';
import './widgets/weight_progress_chart_widget.dart';

class ProgressTrackingScreen extends StatefulWidget {
  const ProgressTrackingScreen({super.key});

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Weekly';
  bool _isLoading = false;

  // Mock data for progress tracking
  final List<Map<String, dynamic>> weightData = [
    {"date": "2024-01-01", "weight": 75.5},
    {"date": "2024-01-08", "weight": 74.8},
    {"date": "2024-01-15", "weight": 74.2},
    {"date": "2024-01-22", "weight": 73.9},
    {"date": "2024-01-29", "weight": 73.5},
    {"date": "2024-02-05", "weight": 73.1},
    {"date": "2024-02-12", "weight": 72.8},
  ];

  final List<Map<String, dynamic>> calorieData = [
    {"date": "2024-02-06", "consumed": 1850, "goal": 2000},
    {"date": "2024-02-07", "consumed": 2100, "goal": 2000},
    {"date": "2024-02-08", "consumed": 1950, "goal": 2000},
    {"date": "2024-02-09", "consumed": 1800, "goal": 2000},
    {"date": "2024-02-10", "consumed": 2050, "goal": 2000},
    {"date": "2024-02-11", "consumed": 1900, "goal": 2000},
    {"date": "2024-02-12", "consumed": 2000, "goal": 2000},
  ];

  final Map<String, dynamic> macroData = {
    "protein": 25.0,
    "carbs": 50.0,
    "fats": 25.0,
  };

  final Map<String, dynamic> statsData = {
    "streak": 15,
    "avgCalories": 1950,
    "weightChange": -2.7,
    "goalAchievement": 85.7,
    "mostLoggedFoods": ["Chicken Breast", "Brown Rice", "Broccoli"],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  void _exportData() {
    // Show export options
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Progress Data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'picture_as_pdf',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Export as PDF'),
              subtitle: const Text('Comprehensive report with charts'),
              onTap: () {
                Navigator.pop(context);
                // Implement PDF export
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'table_chart',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Export as CSV'),
              subtitle: const Text('Raw data for analysis'),
              onTap: () {
                Navigator.pop(context);
                // Implement CSV export
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Progress Tracking'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _exportData,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.primaryColor,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.primaryColor,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Progress'),
            Tab(text: 'Photos'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.primaryColor,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDailyView(),
            _buildProgressView(),
            _buildPhotosView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimePeriodSelectorWidget(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
          ),
          const SizedBox(height: 16),
          StreakCounterWidget(
            streak: statsData["streak"] as int,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          CalorieComparisonChartWidget(
            calorieData: calorieData,
            selectedPeriod: _selectedPeriod,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          MacroDistributionChartWidget(
            macroData: macroData,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimePeriodSelectorWidget(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
          ),
          const SizedBox(height: 16),
          WeightProgressChartWidget(
            weightData: weightData,
            selectedPeriod: _selectedPeriod,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          StatisticsCardWidget(
            statsData: statsData,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          _buildGoalAchievementCard(),
        ],
      ),
    );
  }

  Widget _buildPhotosView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PhotoProgressWidget(
            isLoading: _isLoading,
          ),
          const SizedBox(height: 24),
          _buildMotivationalCard(),
        ],
      ),
    );
  }

  Widget _buildGoalAchievementCard() {
    final achievementPercentage = statsData["goalAchievement"] as double;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'emoji_events',
                  color: AppTheme.getSuccessColor(true),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Goal Achievement',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: achievementPercentage / 100,
              backgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                achievementPercentage >= 80
                    ? AppTheme.getSuccessColor(true)
                    : achievementPercentage >= 60
                        ? AppTheme.getWarningColor(true)
                        : AppTheme.getErrorColor(true),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${achievementPercentage.toStringAsFixed(1)}% of daily goals achieved',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Track Your Visual Progress',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Take progress photos to see your transformation over time. Visual progress can be just as motivating as the numbers!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Implement photo capture
              },
              icon: CustomIconWidget(
                iconName: 'add_a_photo',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Add Progress Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
