import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressComparisonWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentAttempts;

  const ProgressComparisonWidget({
    super.key,
    required this.recentAttempts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Perkembangan Skor',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Chart
          SizedBox(
            height: 25.h,
            child: Semantics(
              label: "Grafik perkembangan skor quiz dalam 7 percobaan terakhir",
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
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
                        // flexible signature to work with different fl_chart versions
                        getTitlesWidget: (value, meta) {
                          final int idx = (value as num).toInt();
                          if (idx >= 0 && idx < recentAttempts.length) {
                            return Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                '${idx + 1}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                ),
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
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              '${(value as num).toInt()}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
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
                  maxX: (recentAttempts.isNotEmpty) ? (recentAttempts.length - 1).toDouble() : 6,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: recentAttempts.asMap().entries.map((entry) {
                        final raw = entry.value['score'];
                        final scoreVal = (raw is num) ? raw.toDouble() : double.tryParse('$raw') ?? 0.0;
                        return FlSpot(
                          entry.key.toDouble(),
                          scoreVal * 100,
                        );
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: AppTheme.lightTheme.colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Trend Analysis
          _buildTrendAnalysis(context),

          SizedBox(height: 2.h),

          // Recent Attempts Summary
          Text(
            'Percobaan Terakhir',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          SizedBox(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentAttempts.length,
              itemBuilder: (context, index) {
                final attempt = recentAttempts[index];
                final raw = attempt['score'];
                final score = (((raw is num) ? raw.toDouble() : double.tryParse('$raw') ?? 0.0) * 100).round();
                final isLatest = index == recentAttempts.length - 1;

                return Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 3.w),
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isLatest
                        ? AppTheme.lightTheme.colorScheme.primaryContainer
                        : AppTheme.lightTheme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: isLatest
                        ? Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isLatest
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        attempt['date'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isLatest) ...[
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.2.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Terbaru',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysis(BuildContext context) {
    if (recentAttempts.length < 2) {
      return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Lakukan lebih banyak quiz untuk melihat tren perkembangan',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final rawLatest = recentAttempts.last['score'];
    final rawPrevious = recentAttempts[recentAttempts.length - 2]['score'];
    final latestScore = (rawLatest is num) ? rawLatest.toDouble() : double.tryParse('$rawLatest') ?? 0.0;
    final previousScore = (rawPrevious is num) ? rawPrevious.toDouble() : double.tryParse('$rawPrevious') ?? 0.0;
    final improvement = latestScore - previousScore;

    final isImproving = improvement > 0;
    final isStable = improvement.abs() < 0.05;

    String trendText;
    IconData trendIcon;
    Color trendColor;

    if (isStable) {
      trendText = 'Performa stabil, pertahankan konsistensi!';
      trendIcon = Icons.trending_flat;
      trendColor = AppTheme.warningLight;
    } else if (isImproving) {
      trendText = 'Bagus! Skor meningkat ${(improvement * 100).round()}% dari quiz sebelumnya';
      trendIcon = Icons.trending_up;
      trendColor = AppTheme.lightTheme.colorScheme.tertiary;
    } else {
      trendText = 'Skor turun ${(improvement.abs() * 100).round()}%, tetap semangat!';
      trendIcon = Icons.trending_down;
      trendColor = AppTheme.lightTheme.colorScheme.error;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: trendIcon.toString().split('.').last,
            color: trendColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              trendText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
