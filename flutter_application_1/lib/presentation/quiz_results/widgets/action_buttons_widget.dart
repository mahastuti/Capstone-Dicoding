import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onRetakeQuiz;
  final VoidCallback onViewExplanations;
  final VoidCallback onShareResults;
  final VoidCallback onBackToHome;

  const ActionButtonsWidget({
    super.key,
    required this.onRetakeQuiz,
    required this.onViewExplanations,
    required this.onShareResults,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Actions Row
        Row(
          children: [
            // Retake Quiz Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onRetakeQuiz,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Quiz Lagi',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // View Explanations Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onViewExplanations,
                icon: CustomIconWidget(
                  iconName: 'lightbulb_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  'Lihat Pembahasan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Secondary Actions Row
        Row(
          children: [
            // Share Results Button
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppTheme.lightTheme.colorScheme.tertiary,
                      AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onShareResults,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Bagikan Hasil',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Back to Home Button
            Expanded(
              child: TextButton.icon(
                onPressed: onBackToHome,
                icon: CustomIconWidget(
                  iconName: 'home',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                label: Text(
                  'Kembali ke Beranda',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Additional Quick Actions
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAction(
                context,
                'Analitik',
                'analytics',
                () => Navigator.pushNamed(context, '/performance-analytics'),
              ),
              _buildDivider(),
              _buildQuickAction(
                context,
                'Profil',
                'person',
                () => Navigator.pushNamed(context, '/user-profile'),
              ),
              _buildDivider(),
              _buildQuickAction(
                context,
                'Pengaturan',
                'settings',
                () {
                  // Handle settings navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fitur pengaturan akan segera hadir'),
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 4.h,
      width: 1,
      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
    );
  }
}
