import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PerformanceBreakdownWidget extends StatefulWidget {
  final List<Map<String, dynamic>> topicBreakdown;
  final Duration timeTaken;

  const PerformanceBreakdownWidget({
    super.key,
    required this.topicBreakdown,
    required this.timeTaken,
  });

  @override
  State<PerformanceBreakdownWidget> createState() => _PerformanceBreakdownWidgetState();
}

class _PerformanceBreakdownWidgetState extends State<PerformanceBreakdownWidget> {
  final Set<int> _expandedCards = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Rincian Performa',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          // Time Taken
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'timer',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Waktu Pengerjaan: ${_formatDuration(widget.timeTaken)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Topic Breakdown
          Text(
            'Akurasi per Topik',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 1.h),
          
          // NOTE: removed unnecessary .toList() in spreads
          ...widget.topicBreakdown.asMap().entries.map((entry) {
            final index = entry.key;
            final topic = entry.value;
            final isExpanded = _expandedCards.contains(index);
            
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded 
                          ? _expandedCards.remove(index)
                          : _expandedCards.add(index);
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Row(
                        children: [
                          // Topic Icon
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: _getTopicColor(topic['accuracy'] as double).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: topic['icon'] as String,
                              color: _getTopicColor(topic['accuracy'] as double),
                              size: 20,
                            ),
                          ),
                          
                          SizedBox(width: 3.w),
                          
                          // Topic Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  topic['name'] as String,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  '${topic['correct']}/${topic['total']} benar',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Accuracy Badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getTopicColor(topic['accuracy'] as double),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${((topic['accuracy'] as double) * 100).round()}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          
                          SizedBox(width: 2.w),
                          
                          // Expand Icon
                          CustomIconWidget(
                            iconName: isExpanded ? 'expand_less' : 'expand_more',
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Expanded Content
                  if (isExpanded) ...[
                    Divider(
                      height: 1,
                      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Soal:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // removed unnecessary .toList() here as well
                          ...(topic['questions'] as List<Map<String, dynamic>>).map((question) {
                            final isCorrect = question['isCorrect'] as bool;
                            return Container(
                              margin: EdgeInsets.only(bottom: 1.h),
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: isCorrect 
                                  ? AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1)
                                  : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: isCorrect ? 'check_circle' : 'cancel',
                                    color: isCorrect 
                                      ? AppTheme.lightTheme.colorScheme.tertiary
                                      : AppTheme.lightTheme.colorScheme.error,
                                    size: 16,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      question['question'] as String,
                                      style: Theme.of(context).textTheme.bodySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getTopicColor(double accuracy) {
    if (accuracy >= 0.8) return AppTheme.lightTheme.colorScheme.tertiary;
    if (accuracy >= 0.6) return AppTheme.warningLight;
    return AppTheme.lightTheme.colorScheme.error;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
