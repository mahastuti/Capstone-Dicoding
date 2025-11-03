import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/quiz_answer_option.dart';
import './widgets/quiz_app_bar.dart';
import './widgets/quiz_menu_bottom_sheet.dart';
import './widgets/quiz_navigation_buttons.dart';
import './widgets/quiz_progress_bar.dart';
import './widgets/quiz_question_card.dart';
import './widgets/quiz_timer_widget.dart';

class QuizInterface extends StatefulWidget {
  const QuizInterface({super.key});

  @override
  State<QuizInterface> createState() => _QuizInterfaceState();
}

class _QuizInterfaceState extends State<QuizInterface>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  Timer? _timer;
  int _remainingSeconds = 600; // 10 minutes
  final bool _isTimerEnabled = true;
  final Set<int> _markedQuestions = {};
  final Map<int, int> _userAnswers = {};
  late PageController _pageController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  final List<Map<String, dynamic>> _quizQuestions = [
    {
      "id": 1,
      "question": "Apa ibu kota Indonesia?",
      "image":
          "https://images.unsplash.com/photo-1500361123587-35e7e3b274be",
      "semanticLabel":
          "Pemandangan kota Jakarta dengan gedung-gedung pencakar langit dan jalan raya yang ramai di sore hari",
      "options": [
        {"label": "A", "text": "Jakarta"},
        {"label": "B", "text": "Surabaya"},
        {"label": "C", "text": "Bandung"},
        {"label": "D", "text": "Medan"}
      ],
      "correctAnswer": 0
    },
    {
      "id": 2,
      "question": "Siapa presiden pertama Indonesia?",
      "image": "",
      "semanticLabel": "",
      "options": [
        {"label": "A", "text": "Soekarno"},
        {"label": "B", "text": "Soeharto"},
        {"label": "C", "text": "B.J. Habibie"},
        {"label": "D", "text": "Megawati"}
      ],
      "correctAnswer": 0
    },
    {
      "id": 3,
      "question": "Berapa jumlah pulau di Indonesia menurut data terbaru?",
      "image":
          "https://images.unsplash.com/photo-1730149453237-110edda1657a",
      "semanticLabel":
          "Pemandangan kepulauan Indonesia dari udara menunjukkan pulau-pulau hijau yang dikelilingi laut biru jernih",
      "options": [
        {"label": "A", "text": "13.466 pulau"},
        {"label": "B", "text": "17.508 pulau"},
        {"label": "C", "text": "15.000 pulau"},
        {"label": "D", "text": "20.000 pulau"}
      ],
      "correctAnswer": 1
    },
    {
      "id": 4,
      "question": "Apa mata uang resmi Indonesia?",
      "image": "",
      "semanticLabel": "",
      "options": [
        {"label": "A", "text": "Rupiah"},
        {"label": "B", "text": "Ringgit"},
        {"label": "C", "text": "Baht"},
        {"label": "D", "text": "Peso"}
      ],
      "correctAnswer": 0
    },
    {
      "id": 5,
      "question": "Kapan Indonesia merdeka?",
      "image":
          "https://images.unsplash.com/photo-1693707623618-4137c2726951",
      "semanticLabel":
          "Bendera merah putih Indonesia berkibar dengan latar belakang langit biru cerah dan awan putih",
      "options": [
        {"label": "A", "text": "17 Agustus 1945"},
        {"label": "B", "text": "17 Agustus 1944"},
        {"label": "C", "text": "17 Agustus 1946"},
        {"label": "D", "text": "17 Agustus 1947"}
      ],
      "correctAnswer": 0
    },
    {
      "id": 6,
      "question": "Apa bahasa resmi Indonesia?",
      "image": "",
      "semanticLabel": "",
      "options": [
        {"label": "A", "text": "Bahasa Indonesia"},
        {"label": "B", "text": "Bahasa Jawa"},
        {"label": "C", "text": "Bahasa Sunda"},
        {"label": "D", "text": "Bahasa Melayu"}
      ],
      "correctAnswer": 0
    },
    {
      "id": 7,
      "question": "Siapa yang dijuluki Bapak Proklamasi?",
      "image": "",
      "semanticLabel": "",
      "options": [
        {"label": "A", "text": "Soekarno"},
        {"label": "B", "text": "Mohammad Hatta"},
        {"label": "C", "text": "Soekarno dan Mohammad Hatta"},
        {"label": "D", "text": "Soedirman"}
      ],
      "correctAnswer": 2
    },
    {
      "id": 8,
      "question": "Apa nama lagu kebangsaan Indonesia?",
      "image":
          "https://images.unsplash.com/photo-1693483747737-beca905c326c",
      "semanticLabel":
          "Sekelompok anak-anak Indonesia mengenakan seragam putih merah sedang menyanyikan lagu kebangsaan dengan khidmat",
      "options": [
        {"label": "A", "text": "Indonesia Raya"},
        {"label": "B", "text": "Garuda Pancasila"},
        {"label": "C", "text": "Tanah Airku"},
        {"label": "D", "text": "Rayuan Pulau Kelapa"}
      ],
      "correctAnswer": 0
    },
    {
      "id": 9,
      "question": "Berapa jumlah provinsi di Indonesia saat ini?",
      "image": "",
      "semanticLabel": "",
      "options": [
        {"label": "A", "text": "34 provinsi"},
        {"label": "B", "text": "33 provinsi"},
        {"label": "C", "text": "35 provinsi"},
        {"label": "D", "text": "32 provinsi"}
      ],
      "correctAnswer": 0
    },
    {
      "id": 10,
      "question": "Apa nama filosofi negara Indonesia?",
      "image":
          "https://images.unsplash.com/photo-1627881802342-a89f2687ee9d",
      "semanticLabel":
          "Lambang Garuda Pancasila dengan perisai yang menampilkan lima simbol ideologi Indonesia pada latar belakang emas",
      "options": [
        {"label": "A", "text": "Pancasila"},
        {"label": "B", "text": "Bhinneka Tunggal Ika"},
        {"label": "C", "text": "Gotong Royong"},
        {"label": "D", "text": "Tri Dharma"}
      ],
      "correctAnswer": 0
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    _startTimer();
    _updateProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!_isTimerEnabled) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _finishQuiz();
      }
    });
  }

  void _updateProgress() {
    final progress = (_currentQuestionIndex + 1) / _quizQuestions.length;
    _progressAnimationController.animateTo(progress);
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
      _userAnswers[_currentQuestionIndex] = index;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = _userAnswers[_currentQuestionIndex];
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswerIndex = _userAnswers[_currentQuestionIndex];
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _toggleBookmark() {
    setState(() {
      if (_markedQuestions.contains(_currentQuestionIndex)) {
        _markedQuestions.remove(_currentQuestionIndex);
      } else {
        _markedQuestions.add(_currentQuestionIndex);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _showMenuBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => QuizMenuBottomSheet(
        onPause: () {
          Navigator.pop(context);
          _pauseQuiz();
        },
        onReviewMarked: () {
          Navigator.pop(context);
          _reviewMarkedQuestions();
        },
        onExit: () {
          Navigator.pop(context);
          _showExitConfirmation();
        },
        markedQuestionsCount: _markedQuestions.length,
      ),
    );
  }

  void _pauseQuiz() {
    _timer?.cancel();
    // Save quiz state and navigate back
    Navigator.pop(context);
  }

  void _reviewMarkedQuestions() {
    if (_markedQuestions.isNotEmpty) {
      final firstMarkedQuestion = _markedQuestions.first;
      setState(() {
        _currentQuestionIndex = firstMarkedQuestion;
        _selectedAnswerIndex = _userAnswers[_currentQuestionIndex];
      });
      _pageController.animateToPage(
        firstMarkedQuestion,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Keluar dari Kuis?',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Progres kuis Anda akan hilang jika keluar sekarang. Apakah Anda yakin?',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Keluar',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _finishQuiz() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/quiz-results');
  }

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = _currentQuestionIndex == _quizQuestions.length - 1;
    final canGoNext = _selectedAnswerIndex != null;
    final canGoBack = _currentQuestionIndex > 0;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: QuizAppBar(
        onBookmark: _toggleBookmark,
        onMenu: _showMenuBottomSheet,
        isBookmarked: _markedQuestions.contains(_currentQuestionIndex),
      ),
      body: Column(
        children: [
          // Progress Bar and Timer
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return QuizProgressBar(
                      currentQuestion: _currentQuestionIndex + 1,
                      totalQuestions: _quizQuestions.length,
                      progress: _progressAnimation.value,
                    );
                  },
                ),
                if (_isTimerEnabled) ...[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QuizTimerWidget(
                          remainingSeconds: _remainingSeconds,
                          isEnabled: _isTimerEnabled,
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 1.h),
              ],
            ),
          ),

          // Question Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentQuestionIndex = index;
                  _selectedAnswerIndex = _userAnswers[_currentQuestionIndex];
                });
                _updateProgress();
              },
              itemCount: _quizQuestions.length,
              itemBuilder: (context, index) {
                final question = _quizQuestions[index];
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Column(
                    children: [
                      QuizQuestionCard(
                        questionText: question["question"] as String,
                        imageUrl: question["image"] as String?,
                        semanticLabel: question["semanticLabel"] as String?,
                      ),
                      SizedBox(height: 3.h),

                      // Answer Options
                      ...(question["options"] as List)
                          .asMap()
                          .entries
                          .map((entry) {
                        final optionIndex = entry.key;
                        final option = entry.value as Map<String, dynamic>;

                        return QuizAnswerOption(
                          optionText: option["text"] as String,
                          optionLabel: option["label"] as String,
                          isSelected: _selectedAnswerIndex == optionIndex,
                          onTap: () => _selectAnswer(optionIndex),
                        );
                      }),

                      SizedBox(height: 3.h),
                    ],
                  ),
                );
              },
            ),
          ),

          // Navigation Buttons
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: SafeArea(
              child: QuizNavigationButtons(
                canGoBack: canGoBack,
                canGoNext: canGoNext,
                onPrevious: canGoBack ? _previousQuestion : null,
                onNext: canGoNext ? _nextQuestion : null,
                isLastQuestion: isLastQuestion,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
