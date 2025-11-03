import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final bool isEnabled;

  const QuizTimerWidget({
    super.key, // ✅ super parameter modern
    required this.remainingSeconds,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) return const SizedBox.shrink();

    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final isLowTime = remainingSeconds <= 60;
    final isCriticalTime = remainingSeconds <= 30;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isCriticalTime
            ? AppTheme.errorLight.withValues(alpha: 0.1)
            : isLowTime
                ? AppTheme.warningLight.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCriticalTime
              ? AppTheme.errorLight
              : isLowTime
                  ? AppTheme.warningLight
                  : AppTheme.lightTheme.colorScheme.primary,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'timer',
            color: isCriticalTime
                ? AppTheme.errorLight
                : isLowTime
                    ? AppTheme.warningLight
                    : AppTheme.lightTheme.colorScheme.primary,
            size: 18,
          ),
          SizedBox(width: 1.w),
          Text(
            timeString,
            style: AppTheme.dataTextStyle(
              isLight: true,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ).copyWith(
              color: isCriticalTime
                  ? AppTheme.errorLight
                  : isLowTime
                      ? AppTheme.warningLight
                      : AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
