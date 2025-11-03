import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;
  final int currentStreak;
  final VoidCallback onProfileTap;

  const GreetingHeader({
    super.key,
    required this.userName,
    required this.currentStreak,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String greeting = _getGreeting();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppTheme.textSecondaryDark
                            : AppTheme.textSecondaryLight,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDarkMode
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.warningLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'local_fire_department',
                        color: AppTheme.warningLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '$currentStreak hari berturut-turut',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppTheme.warningLight,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color:
                    (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'person',
                color:
                    isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi,';
    } else if (hour < 15) {
      return 'Selamat Siang,';
    } else if (hour < 18) {
      return 'Selamat Sore,';
    } else {
      return 'Selamat Malam,';
    }
  }
}
