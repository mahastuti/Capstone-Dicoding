import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String selectedLanguage;
  final bool isDarkMode;
  final bool biometricEnabled;
  final Function(String) onLanguageChanged;
  final Function(bool) onDarkModeChanged;
  final Function(bool) onBiometricChanged;

  const SettingsSectionWidget({
    super.key,
    required this.selectedLanguage,
    required this.isDarkMode,
    required this.biometricEnabled,
    required this.onLanguageChanged,
    required this.onDarkModeChanged,
    required this.onBiometricChanged,
  });

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Pilih Bahasa',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: Text('🇮🇩', style: TextStyle(fontSize: 6.w)),
              title: const Text('Bahasa Indonesia'),
              trailing: selectedLanguage == 'id'
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 5.w,
                    )
                  : null,
              onTap: () {
                onLanguageChanged('id');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Text('🇺🇸', style: TextStyle(fontSize: 6.w)),
              title: const Text('English'),
              trailing: selectedLanguage == 'en'
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 5.w,
                    )
                  : null,
              onTap: () {
                onLanguageChanged('en');
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

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
                  iconName: 'settings',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Pengaturan',
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
                iconName: 'language',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              title: const Text('Bahasa'),
              subtitle: Text(
                  selectedLanguage == 'id' ? 'Bahasa Indonesia' : 'English'),
              trailing: CustomIconWidget(
                iconName: 'keyboard_arrow_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onTap: () => _showLanguageSelector(context),
            ),
            Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: isDarkMode ? 'dark_mode' : 'light_mode',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              title: const Text('Mode Gelap'),
              subtitle: Text(isDarkMode ? 'Aktif' : 'Nonaktif'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: onDarkModeChanged,
              ),
            ),
            Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              title: const Text('Autentikasi Biometrik'),
              subtitle: Text(biometricEnabled ? 'Aktif' : 'Nonaktif'),
              trailing: Switch(
                value: biometricEnabled,
                onChanged: onBiometricChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
