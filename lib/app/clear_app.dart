import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/timeline_screen.dart';

class Deliberate extends StatefulWidget {
  const Deliberate({super.key});

  @override
  State<Deliberate> createState() => _DeliberateState();
}

class _DeliberateState extends State<Deliberate> {
  static const Color _backgroundColor = Color(0xFFF2F2F7);
  static const Color _surfaceColor = Color(0xFFFFFFFF);

  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final box = await Hive.openBox('settings');
    final completed = box.get('onboarding_completed', defaultValue: false) as bool;
    
    setState(() {
      _showOnboarding = !completed;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Deliberate',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: _backgroundColor,
        barBackgroundColor: _surfaceColor,
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: _isLoading
          ? const CupertinoPageScaffold(
              child: Center(child: CupertinoActivityIndicator()),
            )
          : _showOnboarding
              ? const OnboardingScreen()
              : const TimelineScreen(),
    );
  }
}
