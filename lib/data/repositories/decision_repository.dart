import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/decision.dart';

class DecisionRepository {
  static const String _boxName = 'decisions';
  Box<Decision>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DecisionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DecisionCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(EmotionalStateAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DecisionContextAdapter());
    }

    _box = await Hive.openBox<Decision>(_boxName);
  }

  Box<Decision> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('DecisionRepository not initialized');
    }
    return _box!;
  }

  Future<void> addDecision(Decision decision) async {
    await box.put(decision.id, decision);
  }

  Future<void> updateDecision(Decision decision) async {
    await box.put(decision.id, decision);
  }

  Future<void> deleteDecision(String id) async {
    await box.delete(id);
  }

  Decision? getDecision(String id) {
    return box.get(id);
  }

  List<Decision> getAllDecisions() {
    return box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Decision> getDecisionsByCategory(DecisionCategory category) {
    return box.values
        .where((decision) => decision.category == category)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Decision> getDecisionsWithResults() {
    return box.values
        .where((decision) => decision.hasResult)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Decision> getDecisionsWithoutResults() {
    return box.values
        .where((decision) => !decision.hasResult)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Stream<List<Decision>> watchAllDecisions() async* {
    // Сначала отдаем текущие данные
    yield getAllDecisions();
    
    // Затем слушаем изменения
    await for (final _ in box.watch()) {
      yield getAllDecisions();
    }
  }

  Future<void> close() async {
    await _box?.close();
  }
}
