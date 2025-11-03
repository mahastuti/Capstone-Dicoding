import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/daily_quiz_card.dart';
import './widgets/greeting_header.dart';
import './widgets/progress_section.dart';
import './widgets/recommendation_card.dart';

/// Homepage (Beranda) screen.
/// - Greeting, daily quiz card, rekomendasi, ringkasan progres.
/// - TabController untuk 3 tab: Beranda, Statistik, Profil.
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  late final TabController _tabController;

  /// Jumlah soal terpilih untuk quiz (dipakai/ditampilkan di DailyQuizCard)
  int _selectedQuestionCount = 10;

  // Mock data (ganti dengan data nyata dari API kalau perlu)
  final Map<String, dynamic> _userData = {
    'name': 'Andi Pratama',
    'currentStreak': 7,
  };

  final Map<String, dynamic> _dailyQuizData = {
    'status': 'available', // available, completed, locked
    'score': 85,
    'questionsAnswered': 15,
    'countdown': '2 jam 30 menit',
  };

  final List<Map<String, dynamic>> _recommendations = [
    {
      'id': 1,
      'title': 'Matematika Dasar',
      'description':
          'Pelajari konsep dasar matematika dengan soal-soal yang menarik dan mudah dipahami',
      'difficulty': 'Mudah',
      'estimatedTime': '15 menit',
      'questionCount': 10,
      'image': 'https://images.unsplash.com/photo-1662057168154-89300791ad6e',
      'semanticLabel':
          'Abstract blue mathematical waves and formulas floating in water-like background',
    },
    {
      'id': 2,
      'title': 'Sejarah Indonesia',
      'description':
          'Jelajahi perjalanan sejarah Indonesia dari masa ke masa dengan quiz interaktif',
      'difficulty': 'Sedang',
      'estimatedTime': '20 menit',
      'questionCount': 15,
      'image': 'https://images.unsplash.com/photo-1628760988872-4957ed8aeeee',
      'semanticLabel':
          'Traditional Indonesian temple architecture with intricate stone carvings',
    },
    {
      'id': 3,
      'title': 'Bahasa Inggris',
      'description':
          'Tingkatkan kemampuan bahasa Inggris dengan latihan grammar dan vocabulary',
      'difficulty': 'Sulit',
      'estimatedTime': '25 menit',
      'questionCount': 20,
      'image': 'https://images.unsplash.com/photo-1710921156564-a3886c004ba3',
      'semanticLabel': 'Open English dictionary book with pages spread',
    },
    {
      'id': 4,
      'title': 'Sains & Teknologi',
      'description':
          'Eksplorasi dunia sains dan teknologi modern dengan pertanyaan yang menantang',
      'difficulty': 'Sedang',
      'estimatedTime': '18 menit',
      'questionCount': 12,
      'image': 'https://images.unsplash.com/photo-1657778752180-53adc732cf9e',
      'semanticLabel':
          'Modern laboratory equipment with test tubes, beakers, and instruments',
    },
  ];

  final Map<String, dynamic> _progressData = {
    'weeklyProgress': [75, 82, 68, 90, 85, 78, 88],
    'quickStats': {
      'completedQuizzes': 42,
      'averageScore': 82,
      'currentStreak': 7,
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        // rebuild saat index berubah (mis. untuk menampilkan / menyembunyikan FAB)
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Simulasi refresh — panggil API di sini jika perlu
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        // update data jika ada perubahan
      });
    }
  }

  /// Handler ketika user memilih jumlah soal di DailyQuizCard
  void _onQuestionCountSelected(int count) {
    setState(() {
      _selectedQuestionCount = count;
    });
  }

  void _startDailyQuiz() {
    Navigator.pushNamed(context, '/quiz-interface', arguments: {
      'questionCount': _selectedQuestionCount,
      'source': 'daily_quiz',
    });
  }

  void _onRecommendationTap(Map<String, dynamic> recommendation) {
    Navigator.pushNamed(context, '/quiz-interface', arguments: {
      'recommendation': recommendation,
    });
  }

  void _onRecommendationLongPress(Map<String, dynamic> recommendation) {
    _showRecommendationPreview(recommendation);
  }

  void _showRecommendationPreview(Map<String, dynamic> recommendation) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(bottom: 3.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                recommendation['title'] as String,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                recommendation['description'] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                      height: 1.5,
                    ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  _buildPreviewInfo(
                    'Tingkat Kesulitan',
                    recommendation['difficulty'] as String,
                    'school',
                  ),
                  SizedBox(width: 4.w),
                  _buildPreviewInfo(
                    'Estimasi Waktu',
                    recommendation['estimatedTime'] as String,
                    'schedule',
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _onRecommendationTap(recommendation);
                  },
                  child: const Text('Mulai Quiz'),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewInfo(String label, String value, String iconName) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              size: 20,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _onProfileTap() {
    Navigator.pushNamed(context, '/user-profile');
  }

  void _onViewProgressDetails() {
    Navigator.pushNamed(context, '/performance-analytics');
  }

  void _onPracticeQuiz() {
    Navigator.pushNamed(context, '/quiz-interface', arguments: {'source': 'practice'});
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBerandaTab(),
                  _buildStatistikTab(),
                  _buildProfilTab(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                border: Border(
                  top: BorderSide(
                    color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                unselectedLabelColor:
                    isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                indicatorColor: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                tabs: const [
                  Tab(icon: Icon(Icons.home), text: 'Beranda'),
                  Tab(icon: Icon(Icons.analytics), text: 'Statistik'),
                  Tab(icon: Icon(Icons.person), text: 'Profil'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _onPracticeQuiz,
              backgroundColor: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              foregroundColor: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
              icon: CustomIconWidget(
                iconName: 'quiz',
                color: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                size: 20,
              ),
              label: Text(
                'Quiz Latihan',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            )
          : null,
    );
  }

  Widget _buildBerandaTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).brightness == Brightness.dark ? AppTheme.primaryDark : AppTheme.primaryLight,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingHeader(
              userName: _userData['name'] as String,
              currentStreak: _userData['currentStreak'] as int,
              onProfileTap: _onProfileTap,
            ),
            SizedBox(height: 2.h),
            DailyQuizCard(
              quizData: _dailyQuizData,
              selectedQuestionCount: _selectedQuestionCount,
              onQuestionCountSelected: _onQuestionCountSelected,
              onStartQuiz: _startDailyQuiz,
            ),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Rekomendasi Untukmu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 28.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 4.w),
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  return RecommendationCard(
                    recommendation: _recommendations[index],
                    onTap: () => _onRecommendationTap(_recommendations[index]),
                    onLongPress: () => _onRecommendationLongPress(_recommendations[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            ProgressSection(
              progressData: _progressData,
              onViewDetails: _onViewProgressDetails,
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildStatistikTab() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Statistik Detail',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Lihat analisis performa lengkap',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _onViewProgressDetails,
            child: const Text('Buka Statistik'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilTab() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
                width: 2,
              ),
            ),
            child: CustomIconWidget(
              iconName: 'person',
              color: isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
              size: 48,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _userData['name'] as String,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Kelola profil dan pengaturan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight,
                ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _onProfileTap,
            child: const Text('Buka Profil'),
          ),
        ],
      ),
    );
  }
}
