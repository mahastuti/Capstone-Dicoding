import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizQuestionCard extends StatelessWidget {
  final String questionText;
  final String? imageUrl;
  final String? semanticLabel;

  const QuizQuestionCard({
    super.key, // ✅ gunakan super.key (gaya Dart modern)
    required this.questionText,
    this.imageUrl,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: true),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: imageUrl!,
                width: double.infinity,
                height: 25.h,
                fit: BoxFit.cover,
                semanticLabel: semanticLabel ?? "Gambar pertanyaan kuis",
              ),
            ),
            SizedBox(height: 3.h),
          ],
          Text(
            questionText,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
