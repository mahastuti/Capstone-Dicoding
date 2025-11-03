import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSectionWidget extends StatefulWidget {
  final String fullName;
  final String email;
  final String educationLevel;
  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onEducationLevelChanged;

  const AccountSectionWidget({
    super.key,
    required this.fullName,
    required this.email,
    required this.educationLevel,
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onEducationLevelChanged,
  });

  @override
  State<AccountSectionWidget> createState() => _AccountSectionWidgetState();
}

class _AccountSectionWidgetState extends State<AccountSectionWidget> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  String _selectedEducationLevel = '';
  bool _isLoading = false;

  final List<String> _educationLevels = [
    'SD/MI',
    'SMP/MTs',
    'SMA/SMK/MA',
    'Diploma',
    'Sarjana (S1)',
    'Magister (S2)',
    'Doktor (S3)',
  ];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _selectedEducationLevel = widget.educationLevel;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _saveChanges() async {
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama lengkap tidak boleh kosong')),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    widget.onFullNameChanged(_fullNameController.text.trim());
    widget.onEmailChanged(_emailController.text.trim());
    widget.onEducationLevelChanged(_selectedEducationLevel);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan berhasil disimpan')),
      );
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
                  iconName: 'account_circle',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Informasi Akun',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 2.h),
            // gunakan initialValue bukan value (value deprecated)
            DropdownButtonFormField<String>(
              initialValue:
                  _selectedEducationLevel.isNotEmpty ? _selectedEducationLevel : null,
              decoration: const InputDecoration(
                labelText: 'Tingkat Pendidikan',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              items: _educationLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedEducationLevel = value);
                }
              },
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
