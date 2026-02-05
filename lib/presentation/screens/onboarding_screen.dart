import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'timeline_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      emoji: '🎯',
      title: 'Track Your Decisions',
      description: 'Record every important decision you make with context about your emotional state, energy level, and expectations.',
    ),
    OnboardingPage(
      emoji: '📊',
      title: 'Evaluate Results',
      description: 'After some time, evaluate how your decisions turned out. Learn from your patterns and improve future choices.',
    ),
    OnboardingPage(
      emoji: '📈',
      title: 'Analyze Patterns',
      description: 'Discover which contexts and emotional states lead to better decisions. Use data to make smarter choices.',
    ),
    OnboardingPage(
      emoji: '✨',
      title: 'Get Started',
      description: 'Ready to make more deliberate decisions? Let\'s begin your journey to better decision-making.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final box = await Hive.openBox('settings');
    await box.put('onboarding_completed', true);
    
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const TimelineScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Icon(
                        CupertinoIcons.chevron_left,
                        color: CupertinoColors.activeBlue,
                      ),
                    )
                  else
                    const SizedBox(width: 44),
                  Row(
                    children: List.generate(_pages.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.systemGrey4,
                        ),
                      );
                    }),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _completeOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.emoji,
            style: const TextStyle(fontSize: 100),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 17,
              color: CupertinoColors.systemGrey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String emoji;
  final String title;
  final String description;

  OnboardingPage({
    required this.emoji,
    required this.title,
    required this.description,
  });
}
