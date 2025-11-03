import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/performance_breakdown_widget.dart';
import './widgets/progress_comparison_widget.dart';
import './widgets/question_review_widget.dart';
import './widgets/score_display_widget.dart';
import './widgets/topic_recommendations_widget.dart';

class QuizResults extends StatefulWidget {
  const QuizResults({super.key});

  @override
  State<QuizResults> createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults>
    with TickerProviderStateMixin {
  late final AnimationController _celebrationController;
  late final Animation<double> _celebrationAnimation;

  // Mock quiz results data
  final Map<String, dynamic> _quizResults = {
    "score": 8,
    "totalQuestions": 10,
    "timeTaken": const Duration(minutes: 12, seconds: 45),
    "completedAt": "18 Oktober 2024, 11:08",
    "difficulty": "Sedang",
    "category": "Matematika Dasar"
  };

  final List<Map<String, dynamic>> _questions = [
    {
      "id": 1,
      "question": "Berapakah hasil dari 15 + 27?",
      "userAnswer": "42",
      "correctAnswer": "42",
      "isCorrect": true,
      "explanation": "Penjumlahan sederhana: 15 + 27 = 42",
      "topic": "Aritmatika Dasar"
    },
    {
      "id": 2,
      "question": "Jika x + 5 = 12, maka nilai x adalah?",
      "userAnswer": "7",
      "correctAnswer": "7",
      "isCorrect": true,
      "explanation": "Untuk mencari x: x + 5 = 12, maka x = 12 - 5 = 7",
      "topic": "Aljabar Dasar"
    },
    {
      "id": 3,
      "question": "Luas persegi dengan sisi 6 cm adalah?",
      "userAnswer": "36 cm²",
      "correctAnswer": "36 cm²",
      "isCorrect": true,
      "explanation": "Luas persegi = sisi × sisi = 6 × 6 = 36 cm²",
      "topic": "Geometri"
    },
    {
      "id": 4,
      "question": "Hasil dari 8 × 7 adalah?",
      "userAnswer": "54",
      "correctAnswer": "56",
      "isCorrect": false,
      "explanation": "Perkalian: 8 × 7 = 56, bukan 54",
      "topic": "Aritmatika Dasar"
    },
    {
      "id": 5,
      "question": "Berapa persen dari 50 adalah 25?",
      "userAnswer": "50%",
      "correctAnswer": "50%",
      "isCorrect": true,
      "explanation": "25 dari 50 = (25/50) × 100% = 50%",
      "topic": "Persentase"
    },
    {
      "id": 6,
      "question": "Akar kuadrat dari 64 adalah?",
      "userAnswer": "8",
      "correctAnswer": "8",
      "isCorrect": true,
      "explanation": "√64 = 8, karena 8 × 8 = 64",
      "topic": "Akar dan Pangkat"
    },
    {
      "id": 7,
      "question": "Keliling lingkaran dengan jari-jari 7 cm adalah? (π = 22/7)",
      "userAnswer": "44 cm",
      "correctAnswer": "44 cm",
      "isCorrect": true,
      "explanation": "Keliling = 2πr = 2 × (22/7) × 7 = 44 cm",
      "topic": "Geometri"
    },
    {
      "id": 8,
      "question": "Hasil dari 100 - 37 adalah?",
      "userAnswer": "63",
      "correctAnswer": "63",
      "isCorrect": true,
      "explanation": "Pengurangan: 100 - 37 = 63",
      "topic": "Aritmatika Dasar"
    },
    {
      "id": 9,
      "question": "Jika 3y = 21, maka y = ?",
      "userAnswer": "6",
      "correctAnswer": "7",
      "isCorrect": false,
      "explanation": "Untuk mencari y: 3y = 21, maka y = 21 ÷ 3 = 7",
      "topic": "Aljabar Dasar"
    },
    {
      "id": 10,
      "question": "Volume kubus dengan sisi 4 cm adalah?",
      "userAnswer": "64 cm³",
      "correctAnswer": "64 cm³",
      "isCorrect": true,
      "explanation": "Volume kubus = sisi³ = 4³ = 64 cm³",
      "topic": "Geometri"
    }
  ];

  final List<Map<String, dynamic>> _topicBreakdown = [
    {
      "name": "Aritmatika Dasar",
      "icon": "calculate",
      "correct": 2,
      "total": 3,
      "accuracy": 0.67,
      "questions": [
        {"question": "Berapakah hasil dari 15 + 27?", "isCorrect": true},
        {"question": "Hasil dari 8 × 7 adalah?", "isCorrect": false},
        {"question": "Hasil dari 100 - 37 adalah?", "isCorrect": true}
      ]
    },
    {
      "name": "Aljabar Dasar",
      "icon": "functions",
      "correct": 1,
      "total": 2,
      "accuracy": 0.50,
      "questions": [
        {
          "question": "Jika x + 5 = 12, maka nilai x adalah?",
          "isCorrect": true
        },
        {"question": "Jika 3y = 21, maka y = ?", "isCorrect": false}
      ]
    },
    {
      "name": "Geometri",
      "icon": "category",
      "correct": 3,
      "total": 3,
      "accuracy": 1.0,
      "questions": [
        {
          "question": "Luas persegi dengan sisi 6 cm adalah?",
          "isCorrect": true
        },
        {
          "question": "Keliling lingkaran dengan jari-jari 7 cm adalah?",
          "isCorrect": true
        },
        {"question": "Volume kubus dengan sisi 4 cm adalah?", "isCorrect": true}
      ]
    },
    {
      "name": "Persentase",
      "icon": "percent",
      "correct": 1,
      "total": 1,
      "accuracy": 1.0,
      "questions": [
        {"question": "Berapa persen dari 50 adalah 25?", "isCorrect": true}
      ]
    },
    {
      "name": "Akar dan Pangkat",
      "icon": "square_root",
      "correct": 1,
      "total": 1,
      "accuracy": 1.0,
      "questions": [
        {"question": "Akar kuadrat dari 64 adalah?", "isCorrect": true}
      ]
    }
  ];

  final List<Map<String, dynamic>> _recentAttempts = [
    {"score": 0.60, "date": "11 Okt"},
    {"score": 0.65, "date": "12 Okt"},
    {"score": 0.70, "date": "13 Okt"},
    {"score": 0.75, "date": "14 Okt"},
    {"score": 0.72, "date": "15 Okt"},
    {"score": 0.78, "date": "16 Okt"},
    {"score": 0.80, "date": "18 Okt"}
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      "type": "streak",
      "title": "Konsisten!",
      "description": "Quiz 5 hari berturut-turut",
      "icon": "local_fire_department",
      "value": "5 Hari"
    },
    {
      "type": "topic_mastery",
      "title": "Master Geometri",
      "description": "Sempurna di topik Geometri",
      "icon": "emoji_events",
      "value": "100%"
    }
  ];

  final List<Map<String, dynamic>> _recommendations = [
    {
      "topic": "Aljabar Dasar",
      "icon": "functions",
      "priority": "high",
      "currentAccuracy": 0.50,
      "reason":
          "Akurasi rendah (50%) pada topik ini. Perlu latihan lebih intensif untuk memahami konsep variabel dan persamaan.",
      "suggestions": [
        "Pelajari kembali konsep dasar variabel",
        "Latihan soal persamaan linear sederhana",
        "Gunakan metode substitusi untuk memahami nilai variabel"
      ]
    },
    {
      "topic": "Aritmatika Dasar",
      "icon": "calculate",
      "priority": "medium",
      "currentAccuracy": 0.67,
      "reason":
          "Masih ada kesalahan dalam operasi perkalian. Tingkatkan kecepatan dan akurasi perhitungan dasar.",
      "suggestions": [
        "Hafalkan tabel perkalian 1-10",
        "Latihan soal operasi campuran",
        "Gunakan teknik perhitungan cepat"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeCelebrationAnimation();
    _triggerCelebrationIfHighScore();
  }

  void _initializeCelebrationAnimation() {
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));
  }

  void _triggerCelebrationIfHighScore() {
    final percentage =
        (_quizResults['score'] / _quizResults['totalQuestions']) * 100;
    if (percentage >= 80) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _celebrationController.forward();
          HapticFeedback.lightImpact();
        }
      });
    }
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = _quizResults['score'] as int;
    final totalQuestions = _quizResults['totalQuestions'] as int;
    final percentage = (score / totalQuestions * 100).round();

    final performanceData = _getPerformanceData(percentage);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Hasil Quiz',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/homepage',
            (route) => false,
          ),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareResults,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Celebration Animation Overlay
              if (percentage >= 80)
                AnimatedBuilder(
                  animation: _celebrationAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _celebrationAnimation.value,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2.h),
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.2),
                              AppTheme.warningLight.withValues(alpha: 0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'celebration',
                              color: AppTheme.warningLight,
                              size: 24,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Selamat! Skor Fantastis!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppTheme.warningLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              // Score Display
              ScoreDisplayWidget(
                score: score,
                totalQuestions: totalQuestions,
                performanceMessage: performanceData['message'] as String,
                scoreColor: performanceData['color'] as Color,
              ),

              SizedBox(height: 3.h),

              // Achievement Badges (if any)
              if (_achievements.isNotEmpty) ...[
                AchievementBadgesWidget(achievements: _achievements),
                SizedBox(height: 3.h),
              ],

              // Performance Breakdown
              PerformanceBreakdownWidget(
                topicBreakdown: _topicBreakdown,
                timeTaken: _quizResults['timeTaken'] as Duration,
              ),

              SizedBox(height: 3.h),

              // Progress Comparison Chart
              ProgressComparisonWidget(recentAttempts: _recentAttempts),

              SizedBox(height: 3.h),

              // Question Review
              QuestionReviewWidget(questions: _questions),

              SizedBox(height: 3.h),

              // AI Recommendations
              if (_recommendations.isNotEmpty) ...[
                TopicRecommendationsWidget(recommendations: _recommendations),
                SizedBox(height: 3.h),
              ],

              // Action Buttons
              ActionButtonsWidget(
                onRetakeQuiz: _retakeQuiz,
                onViewExplanations: _viewExplanations,
                onShareResults: _shareResults,
                onBackToHome: _backToHome,
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getPerformanceData(int percentage) {
    if (percentage >= 80) {
      return {
        'message': 'Luar Biasa!',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
      };
    } else if (percentage >= 60) {
      return {
        'message': 'Kerja Bagus!',
        'color': AppTheme.warningLight,
      };
    } else {
      return {
        'message': 'Terus Berlatih!',
        'color': AppTheme.lightTheme.colorScheme.error,
      };
    }
  }

  void _retakeQuiz() {
    Navigator.pushReplacementNamed(context, '/quiz-interface');
    Fluttertoast.showToast(
      msg: "Memulai quiz baru...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  void _viewExplanations() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Pembahasan Lengkap',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: QuestionReviewWidget(questions: _questions),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareResults() {
    final score = _quizResults['score'] as int;
    final totalQuestions = _quizResults['totalQuestions'] as int;
    final percentage = (score / totalQuestions * 100).round();

    final shareText = """
🎯 Hasil Quiz QuizMaster Daily

📊 Skor: $score/$totalQuestions ($percentage%)
⏱️ Waktu: ${_formatDuration(_quizResults['timeTaken'] as Duration)}
📅 ${_quizResults['completedAt']}
📚 Kategori: ${_quizResults['category']}

${_getPerformanceData(percentage)['message']} 🎉

#QuizMasterDaily #BelajarSetiapHari
    """
        .trim();

    // Simulate sharing functionality
    Fluttertoast.showToast(
      msg: "Hasil berhasil dibagikan!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      textColor: Colors.white,
    );

    // prefer debugPrint instead of print
    debugPrint("Share content: $shareText");
  }

  void _backToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/homepage',
      (route) => false,
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
