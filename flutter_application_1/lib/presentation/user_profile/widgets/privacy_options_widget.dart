import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyOptionsWidget extends StatelessWidget {
  final bool dataSharing;
  final bool accountVisible;
  final Function(bool) onDataSharingChanged;
  final Function(bool) onAccountVisibilityChanged;

  const PrivacyOptionsWidget({
    super.key,
    required this.dataSharing,
    required this.accountVisible,
    required this.onDataSharingChanged,
    required this.onAccountVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'privacy_tip',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Privasi',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              title: const Text('Berbagi Data untuk Analitik'),
              subtitle: const Text('Membantu meningkatkan pengalaman aplikasi'),
              trailing: Switch(
                value: dataSharing,
                onChanged: onDataSharingChanged,
              ),
            ),
            Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              title: const Text('Profil Publik'),
              subtitle: const Text('Izinkan pengguna lain melihat profil Anda'),
              trailing: Switch(
                value: accountVisible,
                onChanged: onAccountVisibilityChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
