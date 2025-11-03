import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeeklyActivityHeatmapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> activityData;

  const WeeklyActivityHeatmapWidget({
    super.key, // gunakan super.key
    required this.activityData,
  });

  @override
  State<WeeklyActivityHeatmapWidget> createState() =>
      _WeeklyActivityHeatmapWidgetState();
}

class _WeeklyActivityHeatmapWidgetState
    extends State<WeeklyActivityHeatmapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

  Color _getActivityColor(int quizCount) {
    if (quizCount == 0) {
      return AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2);
    }
    if (quizCount == 1) {
      return AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3);
    }
    if (quizCount == 2) {
      return AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5);
    }
    if (quizCount >= 3) {
      return AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8);
    }
    return AppTheme.lightTheme.primaryColor;
  }

  String _getActivityLabel(int quizCount) {
    if (quizCount == 0) {
      return 'Tidak ada aktivitas';
    }
    if (quizCount == 1) {
      return '1 kuis';
    }
    return '$quizCount kuis';
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

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
                iconName: 'calendar_view_week',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Aktivitas Mingguan',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Column(
                children: [
                  // Days of week header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: daysOfWeek.map((day) {
                      return SizedBox(
                        width: 10.w,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 2.h),
                  // Activity grid (4 weeks)
                  ...List.generate(4, (weekIndex) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (dayIndex) {
                          final dataIndex = weekIndex * 7 + dayIndex;
                          final hasData = dataIndex < widget.activityData.length;
                          final quizCount = hasData
                              ? (widget.activityData[dataIndex]['quizCount'] as int)
                              : 0;

                          return GestureDetector(
                            onTap: hasData
                                ? () {
                                    _showActivityTooltip(
                                        context, widget.activityData[dataIndex]);
                                  }
                                : null,
                            child: AnimatedContainer(
                              duration: Duration(
                                  milliseconds: 200 + (dataIndex * 50)),
                              curve: Curves.easeOutBack,
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: _getActivityColor(quizCount),
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(
                                  color: AppTheme
                                      .lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: quizCount > 0
                                  ? Center(
                                      child: Text(
                                        quizCount.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
          SizedBox(height: 2.h),
          _buildActivityLegend(),
        ],
      ),
    );
  }

  Widget _buildActivityLegend() {
    return Row(
      children: [
        Text(
          'Kurang',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 9.sp,
          ),
        ),
        SizedBox(width: 2.w),
        ...List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 1.w),
            child: Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: _getActivityColor(index),
                borderRadius: BorderRadius.circular(0.5.w),
              ),
            ),
          );
        }),
        SizedBox(width: 2.w),
        Text(
          'Lebih',
          style: TextStyle(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }

  void _showActivityTooltip(BuildContext context, Map<String, dynamic> data) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: position.dx + 20.w,
            top: position.dy + 10.h,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(2.w),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.w),
                  boxShadow: AppTheme.cardShadow(isLight: true),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data['date'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _getActivityLabel(data['quizCount'] as int),
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
