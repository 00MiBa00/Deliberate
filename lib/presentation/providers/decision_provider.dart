import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/decision_repository.dart';
import '../../domain/models/decision.dart';

// Repository provider
final decisionRepositoryProvider = Provider<DecisionRepository>((ref) {
  return DecisionRepository();
});

// All decisions provider
final allDecisionsProvider = StreamProvider<List<Decision>>((ref) {
  final repository = ref.watch(decisionRepositoryProvider);
  return repository.watchAllDecisions();
});

// Decisions without results provider
final decisionsWithoutResultsProvider = Provider<List<Decision>>((ref) {
  final decisionsAsync = ref.watch(allDecisionsProvider);
  return decisionsAsync.when(
    data: (decisions) => decisions.where((d) => !d.hasResult).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Decisions with results provider
final decisionsWithResultsProvider = Provider<List<Decision>>((ref) {
  final decisionsAsync = ref.watch(allDecisionsProvider);
  return decisionsAsync.when(
    data: (decisions) => decisions.where((d) => d.hasResult).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Category filter provider
final selectedCategoryProvider = StateProvider<DecisionCategory?>((ref) => null);

// Filtered decisions provider
final filteredDecisionsProvider = Provider<List<Decision>>((ref) {
  final decisionsAsync = ref.watch(allDecisionsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return decisionsAsync.when(
    data: (decisions) {
      if (selectedCategory == null) {
        return decisions;
      }
      return decisions.where((d) => d.category == selectedCategory).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Decision actions
class DecisionActions {
  final Ref ref;

  DecisionActions(this.ref);

  Future<void> addDecision(Decision decision) async {
    final repository = ref.read(decisionRepositoryProvider);
    await repository.addDecision(decision);
  }

  Future<void> updateDecision(Decision decision) async {
    final repository = ref.read(decisionRepositoryProvider);
    await repository.updateDecision(decision);
  }

  Future<void> deleteDecision(String id) async {
    final repository = ref.read(decisionRepositoryProvider);
    await repository.deleteDecision(id);
  }

  Future<void> addResult({
    required String decisionId,
    required String actualResult,
    required int rating,
  }) async {
    final repository = ref.read(decisionRepositoryProvider);
    final decision = repository.getDecision(decisionId);
    
    if (decision != null) {
      final updatedDecision = decision.copyWith(
        actualResult: actualResult,
        resultRating: rating,
        resultAddedAt: DateTime.now(),
      );
      await repository.updateDecision(updatedDecision);
    }
  }
}

final decisionActionsProvider = Provider((ref) => DecisionActions(ref));
