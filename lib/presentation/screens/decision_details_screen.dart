import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/decision.dart';
import '../providers/decision_provider.dart';

class DecisionDetailsScreen extends ConsumerStatefulWidget {
  final Decision decision;

  const DecisionDetailsScreen({super.key, required this.decision});

  @override
  ConsumerState<DecisionDetailsScreen> createState() => _DecisionDetailsScreenState();
}

class _DecisionDetailsScreenState extends ConsumerState<DecisionDetailsScreen> {
  final _actualResultController = TextEditingController();
  int _resultRating = 3;

  @override
  void dispose() {
    _actualResultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Decision Details'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showDeleteConfirmation(context),
          child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildInfoSection(),
              const SizedBox(height: 24),
              _buildExpectedResult(),
              const SizedBox(height: 24),
              widget.decision.hasResult ? _buildActualResult() : _buildAddResultButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.systemGrey5,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.decision.category.emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.decision.category.displayName,
                      style: const TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.decision.goal,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.decision.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              widget.decision.description,
              style: const TextStyle(
                fontSize: 17,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            _formatDate(widget.decision.createdAt),
            style: const TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Decision Context',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Emotional State', 
          '${widget.decision.emotionalState.emoji} ${widget.decision.emotionalState.displayName}'),
        _buildInfoRow('Energy Level', '⚡ ${widget.decision.energyLevel}/5'),
        _buildInfoRow('Urgency Level', '🚨 ${widget.decision.urgencyLevel}/5'),
        _buildInfoRow('Location', 
          '${widget.decision.context.emoji} ${widget.decision.context.displayName}'),
        _buildInfoRow('Others Involved', 
          widget.decision.involvesOthers ? '👥 Yes' : '👤 No'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.systemGrey5,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectedResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expected Result',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.decision.expectedResult,
            style: const TextStyle(
              fontSize: 17,
              color: CupertinoColors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActualResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Actual Result',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getRatingColor(widget.decision.resultRating!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.decision.resultRating}/5',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.decision.actualResult!,
                style: const TextStyle(
                  fontSize: 17,
                  color: CupertinoColors.black,
                ),
              ),
              if (widget.decision.resultAddedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Added ${_formatDate(widget.decision.resultAddedAt!)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey2,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            color: CupertinoColors.systemGrey5,
            onPressed: _showEditResultDialog,
            child: const Text('Edit Result', style: TextStyle(color: CupertinoColors.black)),
          ),
        ),
      ],
    );
  }

  Widget _buildAddResultButton() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: CupertinoColors.activeBlue,
        onPressed: _showAddResultDialog,
        child: const Text(
          'Add Result',
          style: TextStyle(color: CupertinoColors.white),
        ),
      ),
    );
  }

  void _showAddResultDialog() {
    _actualResultController.clear();
    _resultRating = 3;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CupertinoColors.white, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: CupertinoColors.activeBlue)),
                    ),
                    const Text(
                      'Add Result',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.black,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _saveResult(context),
                      child: const Text('Done', style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What happened?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CupertinoTextField(
                        controller: _actualResultController,
                        placeholder: 'Describe the actual result...',
                        maxLines: 5,
                        style: const TextStyle(fontSize: 17),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Decision Rating',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (index) {
                              return Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _resultRating == index + 1
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.systemGrey,
                                  fontWeight: _resultRating == index + 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              );
                            }),
                          ),
                          CupertinoSlider(
                            value: _resultRating.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            onChanged: (value) {
                              setModalState(() => _resultRating = value.round());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditResultDialog() {
    _actualResultController.text = widget.decision.actualResult ?? '';
    _resultRating = widget.decision.resultRating ?? 3;
    _showAddResultDialog();
  }

  Future<void> _saveResult(BuildContext modalContext) async {
    if (_actualResultController.text.trim().isEmpty) return;

    await ref.read(decisionActionsProvider).addResult(
          decisionId: widget.decision.id,
          actualResult: _actualResultController.text,
          rating: _resultRating,
        );

    if (mounted) {
      Navigator.pop(modalContext);
      setState(() {}); // Refresh the screen
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Decision?'),
        content: const Text('This action cannot be undone'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await ref.read(decisionActionsProvider).deleteDecision(widget.decision.id);
              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close details screen
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return CupertinoColors.systemGreen;
    if (rating >= 3) return CupertinoColors.systemOrange;
    return CupertinoColors.systemRed;
  }
}
