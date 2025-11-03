import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DetailedStatisticsWidget extends StatelessWidget {
  final Map<String, dynamic> statistics;

  const DetailedStatisticsWidget({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Statistik Detail',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildStatisticRow(
            'Rata-rata Waktu Penyelesaian',
            '${statistics['averageCompletionTime']} menit',
            CustomIconWidget(
              iconName: 'timer',
              color: AppTheme.lightTheme.primaryColor,
              size: 5.w,
            ),
          ),
          _buildDivider(),
          _buildStatisticRow(
            'Topik Paling Menantang',
            statistics['mostChallengingTopic'] as String,
            CustomIconWidget(
              iconName: 'trending_down',
              color: AppTheme.errorLight,
              size: 5.w,
            ),
          ),
          _buildDivider(),
          _buildStatisticRow(
            'Tingkat Peningkatan',
            '${statistics['improvementRate']}% per minggu',
            CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.successLight,
              size: 5.w,
            ),
          ),
          _buildDivider(),
          _buildStatisticRow(
            'Jawaban Benar Berturut-turut',
            '${statistics['longestCorrectStreak']} soal',
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 5.w,
            ),
          ),
          _buildDivider(),
          _buildStatisticRow(
            'Total Waktu Belajar',
            '${statistics['totalStudyTime']} jam',
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.lightTheme.primaryColor,
              size: 5.w,
            ),
          ),
          _buildDivider(),
          _buildStatisticRow(
            'Akurasi Tertinggi',
            '${statistics['highestAccuracy']}%',
            CustomIconWidget(
              iconName: 'star',
              color: AppTheme.warningLight,
              size: 5.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value, Widget icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Row(
        children: [
          icon,
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
      thickness: 1,
      height: 3.h,
    );
  }
}
