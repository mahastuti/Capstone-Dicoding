import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class DailyQuizCard extends StatefulWidget {
  final Map<String, dynamic> quizData;
  final int selectedQuestionCount;
  final Function(int) onQuestionCountSelected;
  final VoidCallback onStartQuiz;

  const DailyQuizCard({
    super.key,
    required this.quizData,
    required this.selectedQuestionCount,
    required this.onQuestionCountSelected,
    required this.onStartQuiz,
  });

  @override
  State<DailyQuizCard> createState() => _DailyQuizCardState();
}

class _DailyQuizCardState extends State<DailyQuizCard> {
  late int selectedQuestionCount;
  final List<int> questionCounts = [5, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    selectedQuestionCount = widget.selectedQuestionCount;
  }

  @override
  void didUpdateWidget(covariant DailyQuizCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // sinkronkan jika value berubah dari luar
    if (oldWidget.selectedQuestionCount != widget.selectedQuestionCount) {
      selectedQuestionCount = widget.selectedQuestionCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String status = widget.quizData['status'] as String;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow(isLight: !isDarkMode),
        border: Border.all(
          color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status, isDarkMode)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: _getStatusIcon(status),
                    color: _getStatusColor(status, isDarkMode),
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quiz Hari Ini',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppTheme.textPrimaryDark
                                      : AppTheme.textPrimaryLight,
                                ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getStatusText(status),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(status, isDarkMode),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                status == 'completed'
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${widget.quizData['score']}/100',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.successLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 3.h),

            // === STATUS AVAILABLE ===
            if (status == 'available') ...[
              Text(
                'Pilih Jumlah Soal:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.backgroundDark
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? AppTheme.borderDark
                        : AppTheme.borderLight,
                  ),
                ),
                child: Row(
                  children: questionCounts.map((count) {
                    final bool isSelected = selectedQuestionCount == count;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedQuestionCount = count;
                          });
                          widget.onQuestionCountSelected(count);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDarkMode
                                    ? AppTheme.primaryDark
                                    : AppTheme.primaryLight)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$count',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? (isDarkMode
                                          ? AppTheme.backgroundDark
                                          : AppTheme.backgroundLight)
                                      : (isDarkMode
                                          ? AppTheme.textSecondaryDark
                                          : AppTheme.textSecondaryLight),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onStartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? AppTheme.primaryDark
                        : AppTheme.primaryLight,
                    foregroundColor: isDarkMode
                        ? AppTheme.backgroundDark
                        : AppTheme.backgroundLight,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Mulai Quiz',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDarkMode
                              ? AppTheme.backgroundDark
                              : AppTheme.backgroundLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],

            // === STATUS COMPLETED ===
            if (status == 'completed') ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Quiz Hari Ini Selesai!',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Skor: ${widget.quizData['score']}/100 • ${widget.quizData['questionsAnswered']} soal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ),
            ],

            // === STATUS LOCKED ===
            if (status == 'locked') ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.warningLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.warningLight,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Quiz Terkunci',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.warningLight,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Tersedia dalam ${widget.quizData['countdown']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDarkMode
                                ? AppTheme.textSecondaryDark
                                : AppTheme.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, bool isDarkMode) {
    switch (status) {
      case 'available':
        return isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight;
      case 'completed':
        return AppTheme.successLight;
      case 'locked':
        return AppTheme.warningLight;
      default:
        return isDarkMode
            ? AppTheme.textSecondaryDark
            : AppTheme.textSecondaryLight;
    }
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case 'available':
        return 'play_circle_filled';
      case 'completed':
        return 'check_circle';
      case 'locked':
        return 'schedule';
      default:
        return 'help_outline';
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'available':
        return 'Siap dimulai';
      case 'completed':
        return 'Selesai hari ini';
      case 'locked':
        return 'Belum tersedia';
      default:
        return 'Status tidak diketahui';
    }
  }
}
