import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/premium_banner_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_stats_card_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "weight": "65 kg",
    "height": "5'6\"",
    "age": "28 years",
    "activityLevel": "Moderately Active",
    "dailyCalorieGoal": "1800 kcal",
    "weightGoal": "Lose 5 kg",
    "targetDate": "March 2024"
  };

  // Settings state
  bool notificationsEnabled = true;
  bool mealReminders = true;
  bool goalAchievements = true;
  bool weeklySummary = false;
  bool isMetricUnits = true;
  bool dataSharing = false;
  bool photoStorage = true;
  bool biometricAuth = false;

  // Connected apps status
  final List<Map<String, dynamic>> connectedApps = [
    {
      "name": "Apple Health",
      "icon": "health_and_safety",
      "connected": true,
      "lastSync": "2 hours ago"
    },
    {
      "name": "Google Fit",
      "icon": "fitness_center",
      "connected": false,
      "lastSync": "Never"
    },
    {
      "name": "Fitbit",
      "icon": "watch",
      "connected": true,
      "lastSync": "1 day ago"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(userData: userData),

              SizedBox(height: 2.h),

              // Profile Stats Card
              ProfileStatsCardWidget(userData: userData),

              SizedBox(height: 3.h),

              // Premium Banner
              const PremiumBannerWidget(),

              SizedBox(height: 2.h),

              // Goal Management Section
              SettingsSectionWidget(
                title: "Goal Management",
                children: [
                  SettingsItemWidget(
                    icon: "flag",
                    title: "Daily Calorie Goal",
                    subtitle: userData["dailyCalorieGoal"] as String,
                    onTap: () => _showEditDialog("Daily Calorie Goal"),
                  ),
                  SettingsItemWidget(
                    icon: "trending_down",
                    title: "Weight Goal",
                    subtitle: userData["weightGoal"] as String,
                    onTap: () => _showEditDialog("Weight Goal"),
                  ),
                  SettingsItemWidget(
                    icon: "schedule",
                    title: "Target Date",
                    subtitle: userData["targetDate"] as String,
                    onTap: () => _showDatePicker(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Notifications Section
              SettingsSectionWidget(
                title: "Notifications",
                children: [
                  SettingsItemWidget(
                    icon: "notifications",
                    title: "Push Notifications",
                    subtitle: notificationsEnabled ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    icon: "restaurant",
                    title: "Meal Reminders",
                    subtitle: mealReminders ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: mealReminders,
                      onChanged: notificationsEnabled
                          ? (value) {
                              setState(() {
                                mealReminders = value;
                              });
                            }
                          : null,
                    ),
                  ),
                  SettingsItemWidget(
                    icon: "emoji_events",
                    title: "Goal Achievements",
                    subtitle: goalAchievements ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: goalAchievements,
                      onChanged: notificationsEnabled
                          ? (value) {
                              setState(() {
                                goalAchievements = value;
                              });
                            }
                          : null,
                    ),
                  ),
                  SettingsItemWidget(
                    icon: "summarize",
                    title: "Weekly Summary",
                    subtitle: weeklySummary ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: weeklySummary,
                      onChanged: notificationsEnabled
                          ? (value) {
                              setState(() {
                                weeklySummary = value;
                              });
                            }
                          : null,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // App Preferences Section
              SettingsSectionWidget(
                title: "App Preferences",
                children: [
                  SettingsItemWidget(
                    icon: "straighten",
                    title: "Units",
                    subtitle: isMetricUnits
                        ? "Metric (kg, cm)"
                        : "Imperial (lbs, ft)",
                    trailing: Switch(
                      value: isMetricUnits,
                      onChanged: (value) {
                        setState(() {
                          isMetricUnits = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    icon: "palette",
                    title: "Theme",
                    subtitle: "Light Mode",
                    onTap: () => _showThemeDialog(),
                  ),
                  SettingsItemWidget(
                    icon: "language",
                    title: "Language",
                    subtitle: "English",
                    onTap: () => _showLanguageDialog(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Privacy & Security Section
              SettingsSectionWidget(
                title: "Privacy & Security",
                children: [
                  SettingsItemWidget(
                    icon: "share",
                    title: "Data Sharing",
                    subtitle: dataSharing ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: dataSharing,
                      onChanged: (value) {
                        setState(() {
                          dataSharing = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    icon: "photo_library",
                    title: "Photo Storage",
                    subtitle: photoStorage ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: photoStorage,
                      onChanged: (value) {
                        setState(() {
                          photoStorage = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    icon: "fingerprint",
                    title: "Biometric Authentication",
                    subtitle: biometricAuth ? "Enabled" : "Disabled",
                    trailing: Switch(
                      value: biometricAuth,
                      onChanged: (value) {
                        setState(() {
                          biometricAuth = value;
                        });
                      },
                    ),
                  ),
                  SettingsItemWidget(
                    icon: "lock",
                    title: "Change Password",
                    subtitle: "Update your password",
                    onTap: () => _showPasswordDialog(),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Connected Apps Section
              SettingsSectionWidget(
                title: "Connected Apps",
                children: (connectedApps as List).map((dynamic app) {
                  final appMap = app as Map<String, dynamic>;
                  return SettingsItemWidget(
                    icon: appMap["icon"] as String,
                    title: appMap["name"] as String,
                    subtitle: appMap["connected"] as bool
                        ? "Last sync: ${appMap["lastSync"]}"
                        : "Not connected",
                    trailing: appMap["connected"] as bool
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.getSuccessColor(true),
                            size: 20,
                          )
                        : TextButton(
                            onPressed: () =>
                                _connectApp(appMap["name"] as String),
                            child: const Text("Connect"),
                          ),
                    onTap: () => _showAppDetails(appMap),
                  );
                }).toList(),
              ),

              SizedBox(height: 2.h),

              // Data Management Section
              SettingsSectionWidget(
                title: "Data Management",
                children: [
                  SettingsItemWidget(
                    icon: "download",
                    title: "Export Data",
                    subtitle: "Download your health data",
                    onTap: () => _exportData(),
                  ),
                  SettingsItemWidget(
                    icon: "backup",
                    title: "Backup & Restore",
                    subtitle: "Manage your data backup",
                    onTap: () => _showBackupDialog(),
                  ),
                  SettingsItemWidget(
                    icon: "delete_forever",
                    title: "Delete Account",
                    subtitle: "Permanently delete your account",
                    onTap: () => _showDeleteAccountDialog(),
                    textColor: AppTheme.getErrorColor(true),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Support & About Section
              SettingsSectionWidget(
                title: "Support & About",
                children: [
                  SettingsItemWidget(
                    icon: "help",
                    title: "FAQ",
                    subtitle: "Frequently asked questions",
                    onTap: () => _openFAQ(),
                  ),
                  SettingsItemWidget(
                    icon: "contact_support",
                    title: "Contact Support",
                    subtitle: "Get help from our team",
                    onTap: () => _contactSupport(),
                  ),
                  SettingsItemWidget(
                    icon: "feedback",
                    title: "Send Feedback",
                    subtitle: "Help us improve the app",
                    onTap: () => _sendFeedback(),
                  ),
                  SettingsItemWidget(
                    icon: "info",
                    title: "About",
                    subtitle: "Version 2.1.0",
                    onTap: () => _showAboutDialog(),
                  ),
                  SettingsItemWidget(
                    icon: "description",
                    title: "Terms of Service",
                    subtitle: "Read our terms",
                    onTap: () => _openTerms(),
                  ),
                  SettingsItemWidget(
                    icon: "privacy_tip",
                    title: "Privacy Policy",
                    subtitle: "Read our privacy policy",
                    onTap: () => _openPrivacyPolicy(),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Logout Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.getErrorColor(true),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'logout',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Logout",
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(String field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          decoration: InputDecoration(
            hintText: "Enter new $field",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$field updated successfully")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        setState(() {
          userData["targetDate"] = "${date.month}/${date.year}";
        });
      }
    });
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text("Light"),
              value: "light",
              groupValue: "light",
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text("Dark"),
              value: "dark",
              groupValue: "light",
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text("System"),
              value: "system",
              groupValue: "light",
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("Spanish"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("French"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
              ),
            ),
            SizedBox(height: 2.h),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
              ),
            ),
            SizedBox(height: 2.h),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password updated successfully")),
              );
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _connectApp(String appName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connecting to $appName...")),
    );
  }

  void _showAppDetails(Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(app["name"] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Status: ${app["connected"] as bool ? "Connected" : "Disconnected"}"),
            SizedBox(height: 1.h),
            Text("Last Sync: ${app["lastSync"]}"),
            SizedBox(height: 2.h),
            if (app["connected"] as bool)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Disconnected from ${app["name"]}")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.getErrorColor(true),
                ),
                child: const Text("Disconnect"),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preparing data export...")),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Backup & Restore"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'cloud_upload',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text("Create Backup"),
              subtitle: const Text("Last backup: 2 days ago"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Creating backup...")),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'cloud_download',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text("Restore Data"),
              subtitle: const Text("Restore from backup"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Restoring data...")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Account deletion cancelled")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getErrorColor(true),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openFAQ() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening FAQ...")),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening support chat...")),
    );
  }

  void _sendFeedback() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Send Feedback"),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Tell us what you think...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Feedback sent successfully")),
              );
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "CalorieTracker",
      applicationVersion: "2.1.0",
      applicationIcon: CustomIconWidget(
        iconName: 'restaurant',
        color: AppTheme.lightTheme.primaryColor,
        size: 48,
      ),
      children: [
        const Text(
            "A comprehensive health and fitness tracking app for monitoring your daily caloric intake and achieving your wellness goals."),
      ],
    );
  }

  void _openTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening Terms of Service...")),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening Privacy Policy...")),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/splash-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getErrorColor(true),
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
