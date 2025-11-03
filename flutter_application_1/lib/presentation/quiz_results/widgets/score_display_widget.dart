import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScoreDisplayWidget extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String performanceMessage; // sesuai pemanggilan di QuizResults
  final Color? scoreColor; // optional, bisa diberikan dari QuizResults

  const ScoreDisplayWidget({
    super.key,
    required this.score,
    required this.totalQuestions,
    this.performanceMessage = '',
    this.scoreColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // safety: hindari pembagian 0
    final double rawRatio =
        totalQuestions > 0 ? (score / totalQuestions) : 0.0;

    final double percentage = (rawRatio * 100).clamp(0.0, 100.0);
    final double progressValue = rawRatio.clamp(0.0, 1.0);

    final Color effectiveScoreColor = scoreColor ??
        (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow(isLight: !isDarkMode),
        border: Border.all(
          color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil Kuis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                ),
          ),
          SizedBox(height: 1.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Large percentage text
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: effectiveScoreColor,
                    ),
              ),
              SizedBox(width: 4.w),
              // Score / total + performance message
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$score / $totalQuestions soal',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                  ),
                  if (performanceMessage.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      performanceMessage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                          ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Visual progress bar using percentage (0..1)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 1.2.h,
              backgroundColor:
                  (isDarkMode ? AppTheme.borderDark : AppTheme.borderLight)
                      .withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(effectiveScoreColor),
            ),
          ),
        ],
      ),
    );
  }
}
