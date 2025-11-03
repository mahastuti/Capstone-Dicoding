import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectBreakdownWidget extends StatefulWidget {
  final List<Map<String, dynamic>> subjectData;

  const SubjectBreakdownWidget({
    super.key,
    required this.subjectData,
  });

  @override
  State<SubjectBreakdownWidget> createState() => _SubjectBreakdownWidgetState();
}

class _SubjectBreakdownWidgetState extends State<SubjectBreakdownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return AppTheme.successLight;
    if (accuracy >= 60) return AppTheme.warningLight;
    return AppTheme.errorLight;
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
                iconName: 'bar_chart',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Breakdown Mata Pelajaran',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 35.h,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final subject = widget.subjectData[group.x.toInt()];
                          return BarTooltipItem(
                            '${subject['subject']}\nAkurasi: ${rod.toY.toStringAsFixed(1)}%',
                            TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
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
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < widget.subjectData.length) {
                              final subject = widget.subjectData[index]['subject'] as String;
                              final label = subject.length > 8 ? '${subject.substring(0, 8)}...' : subject;

                              // Return a simple aligned widget instead of SideTitleWidget/meta.axisSide
                              return Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  label,
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
                            return Text(
                              '${value.toInt()}%',
                              style: TextStyle(
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                fontSize: 9.sp,
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
                    barGroups: widget.subjectData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final accuracy = (data['accuracy'] as num).toDouble();
                      final animatedHeight = accuracy * _animation.value;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: animatedHeight,
                            color: _getAccuracyColor(accuracy),
                            width: 6.w,
                            borderRadius: BorderRadius.circular(1.w),
                            gradient: LinearGradient(
                              colors: [
                                _getAccuracyColor(accuracy),
                                _getAccuracyColor(accuracy).withValues(alpha: 0.7),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Baik (≥80%)', AppTheme.successLight),
        _buildLegendItem('Cukup (60-79%)', AppTheme.warningLight),
        _buildLegendItem('Perlu Perbaikan (<60%)', AppTheme.errorLight),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.w),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }
}
