import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressSection extends StatelessWidget {
  final Map<String, dynamic> progressData;
  final VoidCallback onViewDetails;

  const ProgressSection({
    super.key,
    required this.progressData,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<dynamic> weeklyData =
        progressData['weeklyProgress'] as List<dynamic>;
    final Map<String, dynamic> stats =
        progressData['quickStats'] as Map<String, dynamic>;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: !isDarkMode),
        border: Border.all(
          color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (isDarkMode
                            ? AppTheme.primaryDark
                            : AppTheme.primaryLight)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'trending_up',
                    color: isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progres Terbaru',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Minggu ini',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onViewDetails,
                  child: Text(
                    'Lihat Detail',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              height: 20.h,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.backgroundDark
                    : AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
                ),
              ),
              child: Semantics(
                label: "Grafik progres mingguan menunjukkan skor quiz harian",
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: (isDarkMode
                                  ? AppTheme.borderDark
                                  : AppTheme.borderLight)
                              .withValues(alpha: 0.5),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          // use dynamic params to be tolerant across fl_chart versions
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            );
                            Widget text;
                            switch ((value as num).toInt()) {
                              case 0:
                                text = Text('Sen',
                                    style: style.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondaryDark
                                            : AppTheme.textSecondaryLight));
                                break;
                              case 1:
                                text = Text('Sel',
                                    style: style.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondaryDark
                                            : AppTheme.textSecondaryLight));
                                break;
                              case 2:
                                text = Text('Rab',
                                    style: style.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondaryDark
                                            : AppTheme.textSecondaryLight));
                                break;
                              case 3:
                                text = Text('Kam',
                                    style: style.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondaryDark
                                            : AppTheme.textSecondaryLight));
                                break;
                              case 4:
                                text = Text('Jum',
                                    style: style.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondaryDark
                                            : AppTheme.textSecondaryLight));
                                break;
                              case 5:
                                text = Text('Sab',
                                    style: style.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondaryDark
                                            : AppTheme.textSecondaryLight));
                                break;
                              case 6:
                                text = Text('Min',
                                    style: style.copyWith(
                                        color: isDarkMode
                                            ? AppTheme.textSecondaryDark
                                            : AppTheme.textSecondaryLight));
                                break;
                              default:
                                text = Text('', style: style);
                                break;
                            }

                            // Avoid SideTitleWidget/axisSide — return aligned widget directly.
                            return Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 4),
                              child: text,
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          getTitlesWidget: (value, meta) {
                            // return a simple Text widget for left axis labels
                            return Text(
                              (value as num).toInt().toString(),
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            );
                          },
                          reservedSize: 32,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: (isDarkMode
                                ? AppTheme.borderDark
                                : AppTheme.borderLight)
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: weeklyData.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(),
                              (entry.value as num).toDouble());
                        }).toList(),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                            (isDarkMode
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight)
                                .withValues(alpha: 0.3),
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: isDarkMode
                                  ? AppTheme.primaryDark
                                  : AppTheme.primaryLight,
                              strokeWidth: 2,
                              strokeColor: isDarkMode
                                  ? AppTheme.backgroundDark
                                  : AppTheme.backgroundLight,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              (isDarkMode
                                      ? AppTheme.primaryDark
                                      : AppTheme.primaryLight)
                                  .withValues(alpha: 0.1),
                              (isDarkMode
                                      ? AppTheme.primaryDark
                                      : AppTheme.primaryLight)
                                  .withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Quiz Selesai',
                    '${stats['completedQuizzes']}',
                    'quiz',
                    AppTheme.successLight,
                    isDarkMode,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Rata-rata Skor',
                    '${stats['averageScore']}',
                    'grade',
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                    isDarkMode,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Streak',
                    '${stats['currentStreak']} hari',
                    'local_fire_department',
                    AppTheme.warningLight,
                    isDarkMode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String iconName,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDarkMode
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isDarkMode
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
