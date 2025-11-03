import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_section_widget.dart';
import './widgets/achievement_showcase_widget.dart';
import './widgets/learning_preferences_widget.dart';
import './widgets/privacy_options_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/statistics_summary_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _imagePicker = ImagePicker();

  // User data (final karena tidak dimodifikasi setelah init)
  final String _userName = 'Andi Pratama';
  final String _memberSince = 'Januari 2024';
  String? _profileImageUrl =
      'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  // Account information (bisa berubah)
  String _fullName = 'Andi Pratama Wijaya';
  String _email = 'andi.pratama@email.com';
  String _educationLevel = 'SMA/SMK/MA';

  // Learning preferences
  List<String> _selectedSubjects = ['Matematika', 'Fisika', 'Bahasa Inggris'];
  double _difficulty = 0.5;
  bool _dailyReminder = true;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 19, minute: 0);

  // Statistics (final karena tidak dimodifikasi di UI ini)
  final int _totalPoints = 2450;
  final int _quizzesCompleted = 87;
  final int _currentStreak = 12;

  // Settings
  String _selectedLanguage = 'id';
  bool _isDarkMode = false;
  bool _biometricEnabled = true;

  // Privacy
  bool _dataSharing = true;
  bool _accountVisible = false;

  // Achievements mock data (final)
  final List<Map<String, dynamic>> _achievements = [
    {
      'id': 1,
      'title': 'Pemula Hebat',
      'description': 'Menyelesaikan 10 kuis pertama dengan sempurna',
      'icon': '🏆',
      'dateEarned': '15 Januari 2024',
    },
    {
      'id': 2,
      'title': 'Streak Master',
      'description': 'Menjaga streak belajar selama 7 hari berturut-turut',
      'icon': '🔥',
      'dateEarned': '22 Januari 2024',
    },
    {
      'id': 3,
      'title': 'Matematika Pro',
      'description': 'Mencapai skor sempurna dalam 5 kuis matematika',
      'icon': '🧮',
      'dateEarned': '28 Januari 2024',
    },
  ];

  // Track apakah ada perubahan yang belum disimpan
  bool _hasUnsavedChanges = false;

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
              'Pilih Foto Profil',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            if (_profileImageUrl != null)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: Colors.red,
                  size: 6.w,
                ),
                title: const Text('Hapus Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfileImage();
                },
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 80,
        );

        if (image != null) {
          setState(() {
            _profileImageUrl = image.path;
            _hasUnsavedChanges = true;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Foto profil berhasil diperbarui')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengambil foto dari kamera')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Izin kamera diperlukan untuk mengambil foto')),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImageUrl = image.path;
          _hasUnsavedChanges = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil diperbarui')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memilih foto dari galeri')),
        );
      }
    }
  }

  void _removeProfileImage() {
    setState(() {
      _profileImageUrl = null;
      _hasUnsavedChanges = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto profil berhasil dihapus')),
    );
  }

  Future<void> _showLogoutConfirmation() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/splash-screen',
        (route) => false,
      );
    }
  }

  // Show save/discard dialog and pop if needed
  // Show save/discard dialog and pop if needed
Future<void> _showSaveChangesDialogAndMaybePop() async {
  final bool? shouldSave = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Simpan Perubahan?'),
      content: const Text(
          'Anda memiliki perubahan yang belum disimpan. Apakah Anda ingin menyimpannya?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Buang'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Simpan'),
        ),
      ],
    ),
  );

  // Don't touch context after async gap unless widget is still mounted.
  if (!mounted) return;

  if (shouldSave == true) {
    // implement real save logic here if needed
    setState(() => _hasUnsavedChanges = false);
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  } else if (shouldSave == false) {
    setState(() => _hasUnsavedChanges = false);
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
  // if null -> dismissed -> do nothing
}


  @override
  Widget build(BuildContext context) {
    // PopScope requires a synchronous canPop boolean.
    // If canPop == false, and system tries to pop, the framework will call
    // onPopInvokedWithResult with didPop == false. We then show dialog and pop manually.
    return PopScope<bool>(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // framework didn't pop because canPop was false (we have unsaved changes)
          _showSaveChangesDialogAndMaybePop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil Saya'),
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
            onPressed: () {
              if (_hasUnsavedChanges) {
                _showSaveChangesDialogAndMaybePop();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            IconButton(
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Mode edit profil akan segera hadir')),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              ProfileHeaderWidget(
                userName: _userName,
                memberSince: _memberSince,
                profileImageUrl: _profileImageUrl,
                onEditProfileImage: _showImageSourceActionSheet,
              ),
              SizedBox(height: 2.h),
              AccountSectionWidget(
                fullName: _fullName,
                email: _email,
                educationLevel: _educationLevel,
                onFullNameChanged: (value) => setState(() {
                  _fullName = value;
                  _hasUnsavedChanges = true;
                }),
                onEmailChanged: (value) => setState(() {
                  _email = value;
                  _hasUnsavedChanges = true;
                }),
                onEducationLevelChanged: (value) => setState(() {
                  _educationLevel = value;
                  _hasUnsavedChanges = true;
                }),
              ),
              LearningPreferencesWidget(
                selectedSubjects: _selectedSubjects,
                difficulty: _difficulty,
                dailyReminder: _dailyReminder,
                notificationTime: _notificationTime,
                onSubjectsChanged: (subjects) => setState(() {
                  _selectedSubjects = subjects;
                  _hasUnsavedChanges = true;
                }),
                onDifficultyChanged: (difficulty) => setState(() {
                  _difficulty = difficulty;
                  _hasUnsavedChanges = true;
                }),
                onDailyReminderChanged: (enabled) => setState(() {
                  _dailyReminder = enabled;
                  _hasUnsavedChanges = true;
                }),
                onNotificationTimeChanged: (time) => setState(() {
                  _notificationTime = time;
                  _hasUnsavedChanges = true;
                }),
              ),
              StatisticsSummaryWidget(
                totalPoints: _totalPoints,
                quizzesCompleted: _quizzesCompleted,
                currentStreak: _currentStreak,
              ),
              AchievementShowcaseWidget(
                achievements: _achievements,
              ),
              SettingsSectionWidget(
                selectedLanguage: _selectedLanguage,
                isDarkMode: _isDarkMode,
                biometricEnabled: _biometricEnabled,
                onLanguageChanged: (language) =>
                    setState(() => _selectedLanguage = language),
                onDarkModeChanged: (enabled) =>
                    setState(() => _isDarkMode = enabled),
                onBiometricChanged: (enabled) =>
                    setState(() => _biometricEnabled = enabled),
              ),
              PrivacyOptionsWidget(
                dataSharing: _dataSharing,
                accountVisible: _accountVisible,
                onDataSharingChanged: (enabled) =>
                    setState(() => _dataSharing = enabled),
                onAccountVisibilityChanged: (enabled) =>
                    setState(() => _accountVisible = enabled),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed: _showLogoutConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'logout',
                        color: Colors.white,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
