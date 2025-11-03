import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LearningPreferencesWidget extends StatefulWidget {
  final List<String> selectedSubjects;
  final double difficulty;
  final bool dailyReminder;
  final TimeOfDay notificationTime;
  final Function(List<String>) onSubjectsChanged;
  final Function(double) onDifficultyChanged;
  final Function(bool) onDailyReminderChanged;
  final Function(TimeOfDay) onNotificationTimeChanged;

  const LearningPreferencesWidget({
    super.key,
    required this.selectedSubjects,
    required this.difficulty,
    required this.dailyReminder,
    required this.notificationTime,
    required this.onSubjectsChanged,
    required this.onDifficultyChanged,
    required this.onDailyReminderChanged,
    required this.onNotificationTimeChanged,
  });

  @override
  State<LearningPreferencesWidget> createState() =>
      _LearningPreferencesWidgetState();
}

class _LearningPreferencesWidgetState extends State<LearningPreferencesWidget> {
  late List<String> _selectedSubjects;
  late double _difficulty;
  late bool _dailyReminder;
  late TimeOfDay _notificationTime;

  final List<String> _availableSubjects = [
    'Matematika',
    'Bahasa Indonesia',
    'Bahasa Inggris',
    'IPA',
    'IPS',
    'Sejarah',
    'Geografi',
    'Fisika',
    'Kimia',
    'Biologi',
    'Ekonomi',
    'Sosiologi',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSubjects = List.from(widget.selectedSubjects);
    _difficulty = widget.difficulty;
    _dailyReminder = widget.dailyReminder;
    _notificationTime = widget.notificationTime;
  }

  String _getDifficultyLabel(double value) {
    if (value <= 0.33) return 'Mudah';
    if (value <= 0.66) return 'Sedang';
    return 'Sulit';
  }

  Future<void> _selectNotificationTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _notificationTime) {
      setState(() => _notificationTime = picked);
      widget.onNotificationTimeChanged(picked);
    }
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
                  iconName: 'tune',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Preferensi Belajar',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              'Mata Pelajaran Favorit',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _availableSubjects.map((subject) {
                final isSelected = _selectedSubjects.contains(subject);
                return FilterChip(
                  label: Text(subject),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSubjects.add(subject);
                      } else {
                        _selectedSubjects.remove(subject);
                      }
                    });
                    widget.onSubjectsChanged(_selectedSubjects);
                  },
                  selectedColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.lightTheme.primaryColor,
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
            Text(
              'Tingkat Kesulitan Kuis',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _difficulty,
                    onChanged: (value) {
                      setState(() => _difficulty = value);
                      widget.onDifficultyChanged(value);
                    },
                    divisions: 2,
                    label: _getDifficultyLabel(_difficulty),
                  ),
                ),
                SizedBox(width: 3.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getDifficultyLabel(_difficulty),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pengingat Harian',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Switch(
                  value: _dailyReminder,
                  onChanged: (value) {
                    setState(() => _dailyReminder = value);
                    widget.onDailyReminderChanged(value);
                  },
                ),
              ],
            ),
            if (_dailyReminder) ...[
              SizedBox(height: 2.h),
              InkWell(
                onTap: _selectNotificationTime,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Waktu Pengingat: ${_notificationTime.format(context)}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_right',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
