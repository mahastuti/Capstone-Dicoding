import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> recommendation;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow(isLight: !isDarkMode),
          border: Border.all(
            color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CustomImageWidget(
                imageUrl: recommendation['image'] as String,
                width: double.infinity,
                height: 12.h,
                fit: BoxFit.cover,
                semanticLabel: recommendation['semanticLabel'] as String,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                                    recommendation['difficulty'] as String)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            recommendation['difficulty'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: _getDifficultyColor(
                                      recommendation['difficulty'] as String),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: (isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: isDarkMode
                                    ? AppTheme.textSecondaryDark
                                    : AppTheme.textSecondaryLight,
                                size: 12,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                recommendation['estimatedTime'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendation['title'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          Expanded(
                            child: Text(
                              recommendation['description'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? AppTheme.textSecondaryDark
                                        : AppTheme.textSecondaryLight,
                                    height: 1.4,
                                  ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'quiz',
                                color: isDarkMode
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${recommendation['questionCount']} soal',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: (isDarkMode
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: isDarkMode
                                ? AppTheme.primaryDark
                                : AppTheme.primaryLight,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'mudah':
        return AppTheme.successLight;
      case 'sedang':
        return AppTheme.warningLight;
      case 'sulit':
        return AppTheme.errorLight;
      default:
        return AppTheme.successLight;
    }
  }
}
