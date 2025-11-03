import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_section_widget.dart';
import './widgets/analytics_header_widget.dart';
import './widgets/detailed_statistics_widget.dart';
import './widgets/score_trend_chart_widget.dart';
import './widgets/subject_breakdown_widget.dart';
import './widgets/time_period_selector_widget.dart';
import './widgets/weekly_activity_heatmap_widget.dart';

class PerformanceAnalytics extends StatefulWidget {
  const PerformanceAnalytics({super.key});

  @override
  State<PerformanceAnalytics> createState() => _PerformanceAnalyticsState();
}

class _PerformanceAnalyticsState extends State<PerformanceAnalytics> {
  String selectedTimePeriod = '30 hari';
  bool isLoading = false;

  // Mock data for analytics
  final List<Map<String, dynamic>> scoreData = [
    {'date': '01/10', 'score': 75.0},
    {'date': '03/10', 'score': 82.5},
    {'date': '05/10', 'score': 78.0},
    {'date': '07/10', 'score': 85.5},
    {'date': '09/10', 'score': 88.0},
    {'date': '11/10', 'score': 91.5},
    {'date': '13/10', 'score': 89.0},
    {'date': '15/10', 'score': 93.5},
    {'date': '17/10', 'score': 87.0},
    {'date': '18/10', 'score': 95.0},
  ];

  final List<Map<String, dynamic>> subjectData = [
    {'subject': 'Matematika', 'accuracy': 85.5},
    {'subject': 'Fisika', 'accuracy': 78.2},
    {'subject': 'Kimia', 'accuracy': 92.1},
    {'subject': 'Biologi', 'accuracy': 67.8},
    {'subject': 'Bahasa Indonesia', 'accuracy': 89.3},
    {'subject': 'Sejarah', 'accuracy': 74.6},
  ];

  final List<Map<String, dynamic>> activityData = [
    {'date': '14/10', 'quizCount': 2},
    {'date': '15/10', 'quizCount': 1},
    {'date': '16/10', 'quizCount': 3},
    {'date': '17/10', 'quizCount': 0},
    {'date': '18/10', 'quizCount': 2},
    {'date': '19/10', 'quizCount': 1},
    {'date': '20/10', 'quizCount': 4},
    {'date': '21/10', 'quizCount': 2},
    {'date': '22/10', 'quizCount': 1},
    {'date': '23/10', 'quizCount': 3},
    {'date': '24/10', 'quizCount': 0},
    {'date': '25/10', 'quizCount': 2},
    {'date': '26/10', 'quizCount': 1},
    {'date': '27/10', 'quizCount': 2},
    {'date': '28/10', 'quizCount': 3},
    {'date': '29/10', 'quizCount': 1},
    {'date': '30/10', 'quizCount': 2},
    {'date': '31/10', 'quizCount': 0},
    {'date': '01/11', 'quizCount': 1},
    {'date': '02/11', 'quizCount': 3},
    {'date': '03/11', 'quizCount': 2},
    {'date': '04/11', 'quizCount': 1},
    {'date': '05/11', 'quizCount': 4},
    {'date': '06/11', 'quizCount': 2},
    {'date': '07/11', 'quizCount': 1},
    {'date': '08/11', 'quizCount': 3},
    {'date': '09/11', 'quizCount': 0},
    {'date': '10/11', 'quizCount': 2},
  ];

  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'Pemula',
      'description': 'Selesaikan 10 kuis pertama Anda',
      'icon': 'star',
      'earned': true,
      'progress': 1.0,
    },
    {
      'title': 'Konsisten',
      'description': 'Kerjakan kuis selama 7 hari berturut-turut',
      'icon': 'local_fire_department',
      'earned': true,
      'progress': 1.0,
    },
    {
      'title': 'Ahli Matematika',
      'description': 'Raih skor 90% dalam 5 kuis Matematika',
      'icon': 'calculate',
      'earned': false,
      'progress': 0.6,
    },
    {
      'title': 'Penjelajah',
      'description': 'Coba semua mata pelajaran yang tersedia',
      'icon': 'explore',
      'earned': true,
      'progress': 1.0,
    },
    {
      'title': 'Perfeksionis',
      'description': 'Raih skor 100% dalam satu kuis',
      'icon': 'emoji_events',
      'earned': false,
      'progress': 0.8,
    },
    {
      'title': 'Maraton',
      'description': 'Selesaikan 100 kuis',
      'icon': 'directions_run',
      'earned': false,
      'progress': 0.45,
    },
  ];

  final Map<String, dynamic> detailedStatistics = {
    'averageCompletionTime': '3.2',
    'mostChallengingTopic': 'Biologi',
    'improvementRate': '12.5',
    'longestCorrectStreak': '15',
    'totalStudyTime': '24.5',
    'highestAccuracy': '95.0',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshAnalytics,
        color: AppTheme.lightTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Analytics Header
              AnalyticsHeaderWidget(
                totalQuizzes: 45,
                averageScore: 86.7,
                currentStreak: 12,
                bestWeek: 18,
              ),
              SizedBox(height: 3.h),

              // Time Period Selector
              TimePeriodSelectorWidget(
                selectedPeriod: selectedTimePeriod,
                onPeriodChanged: _onTimePeriodChanged,
              ),
              SizedBox(height: 3.h),

              // Score Trend Chart
              ScoreTrendChartWidget(
                scoreData: _getFilteredScoreData(),
                timePeriod: selectedTimePeriod,
              ),
              SizedBox(height: 3.h),

              // Subject Breakdown
              SubjectBreakdownWidget(
                subjectData: subjectData,
              ),
              SizedBox(height: 3.h),

              // Weekly Activity Heatmap
              WeeklyActivityHeatmapWidget(
                activityData: activityData,
              ),
              SizedBox(height: 3.h),

              // Achievement Section
              AchievementSectionWidget(
                achievements: achievements,
              ),
              SizedBox(height: 3.h),

              // Detailed Statistics
              DetailedStatisticsWidget(
                statistics: detailedStatistics,
              ),
              SizedBox(height: 3.h),

              // Export Data Button
              _buildExportButton(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Analitik Performa',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'share',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: _shareAnalytics,
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : _exportData,
        icon: isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : CustomIconWidget(
                iconName: 'download',
                color: Colors.white,
                size: 5.w,
              ),
        label: Text(
          isLoading ? 'Mengekspor...' : 'Ekspor Data',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
        ),
      ),
    );
  }

  void _onTimePeriodChanged(String period) {
    setState(() {
      selectedTimePeriod = period;
    });
  }

  List<Map<String, dynamic>> _getFilteredScoreData() {
    // Filter data based on selected time period
    switch (selectedTimePeriod) {
      case '7 hari':
        return scoreData.take(7).toList();
      case '3 bulan':
        return scoreData; // Return all data for 3 months
      default:
        return scoreData; // Default to 30 days
    }
  }

  Future<void> _refreshAnalytics() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data analitik berhasil diperbarui'),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      );
    }
  }

  Future<void> _exportData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Simulate PDF generation
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Laporan PDF berhasil diekspor'),
            backgroundColor: AppTheme.successLight,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengekspor data. Silakan coba lagi.'),
            backgroundColor: AppTheme.errorLight,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _shareAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        title: Text(
          'Bagikan Analitik',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Pilih cara untuk membagikan data analitik Anda:',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fitur berbagi akan segera tersedia'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              );
            },
            child: Text('Bagikan'),
          ),
        ],
      ),
    );
  }
}
