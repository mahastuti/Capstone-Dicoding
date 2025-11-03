import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementSectionWidget({
    super.key,
    required this.achievements,
  });

  @override
  State<AchievementSectionWidget> createState() =>
      _AchievementSectionWidgetState();
}

class _AchievementSectionWidgetState extends State<AchievementSectionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                iconName: 'emoji_events',
                color: AppTheme.warningLight,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Pencapaian',
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
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 3.w,
                  childAspectRatio: 0.8,
                ),
                itemCount: widget.achievements.length,
                itemBuilder: (context, index) {
                  final achievement = widget.achievements[index];
                  final isEarned = achievement['earned'] as bool;
                  final progress = achievement['progress'] as double;

                  return Transform.scale(
                    scale: _animation.value,
                    child: GestureDetector(
                      onTap: () =>
                          _showAchievementDetails(context, achievement),
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: isEarned
                              ? AppTheme.warningLight.withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3.w),
                          border: Border.all(
                            color: isEarned
                                ? AppTheme.warningLight
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: achievement['icon'] as String,
                              color: isEarned
                                  ? AppTheme.warningLight
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              size: 8.w,
                            ),
                            SizedBox(height: 2.w),
                            Text(
                              achievement['title'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isEarned
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!isEarned) ...[
                              SizedBox(height: 2.w),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppTheme
                                    .lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                              SizedBox(height: 1.w),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  fontSize: 8.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.w),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: achievement['icon'] as String,
              color: achievement['earned'] as bool
                  ? AppTheme.warningLight
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 8.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                achievement['title'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            if (!(achievement['earned'] as bool)) ...[
              SizedBox(height: 2.h),
              Text(
                'Progress: ${((achievement['progress'] as double) * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(height: 1.h),
              LinearProgressIndicator(
                value: achievement['progress'] as double,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
