import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBookmark;
  final VoidCallback onMenu;
  final bool isBookmarked;

  const QuizAppBar({
    super.key, // ✅ pakai super.key di sini
    required this.onBookmark,
    required this.onMenu,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Kuis Harian',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onBookmark,
          icon: CustomIconWidget(
            iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
            color: isBookmarked
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: onMenu,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
