import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/decision.dart';
import '../../providers/decision_provider.dart';

class AddDecisionScreen extends ConsumerStatefulWidget {
  const AddDecisionScreen({super.key});

  @override
  ConsumerState<AddDecisionScreen> createState() => _AddDecisionScreenState();
}

class _AddDecisionScreenState extends ConsumerState<AddDecisionScreen> {
  int _currentStep = 0;
  final _uuid = const Uuid();

  // Form data
  DecisionCategory _category = DecisionCategory.work;
  String _goal = '';
  String _description = '';
  EmotionalState _emotionalState = EmotionalState.calm;
  int _energyLevel = 3;
  int _urgencyLevel = 3;
  DecisionContext _context = DecisionContext.home;
  bool _involvesOthers = false;
  String _expectedResult = '';

  final _goalController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _expectedResultController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    _descriptionController.dispose();
    _expectedResultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text('Step ${_currentStep + 1} of 7'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(7, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 6 ? 8 : 0),
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildCategoryStep();
      case 1:
        return _buildGoalStep();
      case 2:
        return _buildEmotionalStateStep();
      case 3:
        return _buildEnergyUrgencyStep();
      case 4:
        return _buildContextStep();
      case 5:
        return _buildInvolvesOthersStep();
      case 6:
        return _buildExpectedResultStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCategoryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Decision Category',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Which area of life does this decision relate to?',
          style: TextStyle(
            fontSize: 17,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        ...DecisionCategory.values.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionCard(
              emoji: category.emoji,
              title: category.displayName,
              isSelected: _category == category,
              onTap: () => setState(() => _category = category),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGoalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Decision Goal',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'What do you want to achieve?',
          style: TextStyle(
            fontSize: 17,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        CupertinoTextField(
          controller: _goalController,
          placeholder: 'For example: Change job',
          maxLines: 2,
          style: const TextStyle(fontSize: 17),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          onChanged: (value) => _goal = value,
        ),
        const SizedBox(height: 24),
        const Text(
          'Details (optional)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 12),
        CupertinoTextField(
          controller: _descriptionController,
          placeholder: 'Additional context...',
          maxLines: 5,
          style: const TextStyle(fontSize: 17),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          onChanged: (value) => _description = value,
        ),
      ],
    );
  }

  Widget _buildEmotionalStateStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emotional State',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'How do you feel right now?',
          style: TextStyle(
            fontSize: 17,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        ...EmotionalState.values.map((state) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionCard(
              emoji: state.emoji,
              title: state.displayName,
              isSelected: _emotionalState == state,
              onTap: () => setState(() => _emotionalState = state),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEnergyUrgencyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Energy and Urgency',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Energy Level',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildSlider(
          value: _energyLevel,
          onChanged: (value) => setState(() => _energyLevel = value.round()),
        ),
        const SizedBox(height: 32),
        const Text(
          'Urgency Level',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 12),
        _buildSlider(
          value: _urgencyLevel,
          onChanged: (value) => setState(() => _urgencyLevel = value.round()),
        ),
      ],
    );
  }

  Widget _buildContextStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Context',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Where are you?',
          style: TextStyle(
            fontSize: 17,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        ...DecisionContext.values.map((context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOptionCard(
              emoji: context.emoji,
              title: context.displayName,
              isSelected: _context == context,
              onTap: () => setState(() => _context = context),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInvolvesOthersStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Others Involved?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Does this decision affect other people?',
          style: TextStyle(
            fontSize: 17,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        _buildOptionCard(
          emoji: '👤',
          title: 'Just me',
          isSelected: !_involvesOthers,
          onTap: () => setState(() => _involvesOthers = false),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          emoji: '👥',
          title: 'Other people involved',
          isSelected: _involvesOthers,
          onTap: () => setState(() => _involvesOthers = true),
        ),
      ],
    );
  }

  Widget _buildExpectedResultStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expected Result',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'What do you expect from this decision?',
          style: TextStyle(
            fontSize: 17,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 32),
        CupertinoTextField(
          controller: _expectedResultController,
          placeholder: 'Describe the expected result...',
          maxLines: 5,
          style: const TextStyle(fontSize: 17),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          onChanged: (value) => _expectedResult = value,
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String emoji,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.activeBlue.withOpacity(0.2) : CupertinoColors.white,
          border: Border.all(
            color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey5,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: CupertinoColors.black,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: CupertinoColors.activeBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({required int value, required ValueChanged<double> onChanged}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 15,
                color: value == index + 1 ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                fontWeight: value == index + 1 ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }),
        ),
        CupertinoSlider(
          value: value.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: CupertinoColors.systemGrey5, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemGrey5,
                onPressed: () => setState(() => _currentStep--),
                child: const Text('Back', style: TextStyle(color: CupertinoColors.black)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: CupertinoButton(
              color: CupertinoColors.activeBlue,
              onPressed: _canProceed() ? _handleNext : null,
              child: Text(
                _currentStep == 6 ? 'Save' : 'Next',
                style: const TextStyle(color: CupertinoColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 1:
        return _goal.trim().isNotEmpty;
      case 6:
        return _expectedResult.trim().isNotEmpty;
      default:
        return true;
    }
  }

  void _handleNext() {
    if (_currentStep < 6) {
      setState(() => _currentStep++);
    } else {
      _saveDecision();
    }
  }

  Future<void> _saveDecision() async {
    final decision = Decision(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      category: _category,
      goal: _goal,
      description: _description,
      emotionalState: _emotionalState,
      energyLevel: _energyLevel,
      urgencyLevel: _urgencyLevel,
      context: _context,
      involvesOthers: _involvesOthers,
      expectedResult: _expectedResult,
    );

    await ref.read(decisionActionsProvider).addDecision(decision);

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
