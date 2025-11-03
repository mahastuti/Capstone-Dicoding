import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScoreTrendChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> scoreData;
  final String timePeriod;

  const ScoreTrendChartWidget({
    super.key,
    required this.scoreData,
    required this.timePeriod,
  });

  @override
  State<ScoreTrendChartWidget> createState() => _ScoreTrendChartWidgetState();
}

class _ScoreTrendChartWidgetState extends State<ScoreTrendChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _toDoubleSafe(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

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
                iconName: 'show_chart',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Tren Skor (${widget.timePeriod})',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 30.h,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final spots = widget.scoreData.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final data = entry.value;
                  final rawScore = data['score'];
                  final scorePct = _toDoubleSafe(rawScore) * _animation.value;
                  return FlSpot(idx.toDouble(), scorePct);
                }).toList();

                return LineChart(
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
                          // use flexible signature (value, meta) and return a simple widget -
                          // avoids SideTitleWidget / meta.axisSide compatibility issues
                          getTitlesWidget: (value, meta) {
                            final index = (value as num).toInt();
                            if (index >= 0 && index < widget.scoreData.length) {
                              final date = widget.scoreData[index]['date']?.toString() ?? '';
                              return Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                    fontSize: 9.sp,
                                  ),
                                  textAlign: TextAlign.center,
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
                                style: TextStyle(
                                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                  fontSize: 9.sp,
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
                    maxX: (widget.scoreData.isNotEmpty) ? (widget.scoreData.length - 1).toDouble() : 6,
                    minY: 0,
                    maxY: 100,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((touchedSpot) {
                            final index = touchedSpot.x.toInt();
                            if (index >= 0 && index < widget.scoreData.length) {
                              final data = widget.scoreData[index];
                              return LineTooltipItem(
                                '${data['date']}\nSkor: ${touchedSpot.y.toStringAsFixed(1)}%',
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                            return null;
                          }).whereType<LineTooltipItem>().toList();
                        },
                      ),
                      handleBuiltInTouches: true,
                    ),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
