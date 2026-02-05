import 'package:hive/hive.dart';

part 'decision.g.dart';

@HiveType(typeId: 0)
class Decision extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final DecisionCategory category;

  @HiveField(3)
  final String goal;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final EmotionalState emotionalState;

  @HiveField(6)
  final int energyLevel; // 1-5

  @HiveField(7)
  final int urgencyLevel; // 1-5

  @HiveField(8)
  final DecisionContext context;

  @HiveField(9)
  final bool involvesOthers;

  @HiveField(10)
  final String expectedResult;

  @HiveField(11)
  String? actualResult;

  @HiveField(12)
  int? resultRating; // 1-5

  @HiveField(13)
  DateTime? resultAddedAt;

  Decision({
    required this.id,
    required this.createdAt,
    required this.category,
    required this.goal,
    required this.description,
    required this.emotionalState,
    required this.energyLevel,
    required this.urgencyLevel,
    required this.context,
    required this.involvesOthers,
    required this.expectedResult,
    this.actualResult,
    this.resultRating,
    this.resultAddedAt,
  });

  Decision copyWith({
    String? id,
    DateTime? createdAt,
    DecisionCategory? category,
    String? goal,
    String? description,
    EmotionalState? emotionalState,
    int? energyLevel,
    int? urgencyLevel,
    DecisionContext? context,
    bool? involvesOthers,
    String? expectedResult,
    String? actualResult,
    int? resultRating,
    DateTime? resultAddedAt,
  }) {
    return Decision(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      goal: goal ?? this.goal,
      description: description ?? this.description,
      emotionalState: emotionalState ?? this.emotionalState,
      energyLevel: energyLevel ?? this.energyLevel,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      context: context ?? this.context,
      involvesOthers: involvesOthers ?? this.involvesOthers,
      expectedResult: expectedResult ?? this.expectedResult,
      actualResult: actualResult ?? this.actualResult,
      resultRating: resultRating ?? this.resultRating,
      resultAddedAt: resultAddedAt ?? this.resultAddedAt,
    );
  }

  bool get hasResult => actualResult != null && resultRating != null;
}

@HiveType(typeId: 1)
enum DecisionCategory {
  @HiveField(0)
  work,

  @HiveField(1)
  money,

  @HiveField(2)
  relationships,

  @HiveField(3)
  health,

  @HiveField(4)
  other;

  String get displayName {
    switch (this) {
      case DecisionCategory.work:
        return 'Work';
      case DecisionCategory.money:
        return 'Money';
      case DecisionCategory.relationships:
        return 'Relationships';
      case DecisionCategory.health:
        return 'Health';
      case DecisionCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case DecisionCategory.work:
        return '💼';
      case DecisionCategory.money:
        return '💰';
      case DecisionCategory.relationships:
        return '❤️';
      case DecisionCategory.health:
        return '🏃';
      case DecisionCategory.other:
        return '📌';
    }
  }
}

@HiveType(typeId: 2)
enum EmotionalState {
  @HiveField(0)
  calm,

  @HiveField(1)
  excited,

  @HiveField(2)
  anxious,

  @HiveField(3)
  stressed,

  @HiveField(4)
  confident,

  @HiveField(5)
  uncertain;

  String get displayName {
    switch (this) {
      case EmotionalState.calm:
        return 'Calm';
      case EmotionalState.excited:
        return 'Excited';
      case EmotionalState.anxious:
        return 'Anxious';
      case EmotionalState.stressed:
        return 'Stressed';
      case EmotionalState.confident:
        return 'Confident';
      case EmotionalState.uncertain:
        return 'Uncertain';
    }
  }

  String get emoji {
    switch (this) {
      case EmotionalState.calm:
        return '😌';
      case EmotionalState.excited:
        return '🤩';
      case EmotionalState.anxious:
        return '😰';
      case EmotionalState.stressed:
        return '😫';
      case EmotionalState.confident:
        return '😎';
      case EmotionalState.uncertain:
        return '🤔';
    }
  }
}

@HiveType(typeId: 3)
enum DecisionContext {
  @HiveField(0)
  home,

  @HiveField(1)
  work,

  @HiveField(2)
  commute,

  @HiveField(3)
  other;

  String get displayName {
    switch (this) {
      case DecisionContext.home:
        return 'Home';
      case DecisionContext.work:
        return 'At Work';
      case DecisionContext.commute:
        return 'Commute';
      case DecisionContext.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case DecisionContext.home:
        return '🏠';
      case DecisionContext.work:
        return '🏢';
      case DecisionContext.commute:
        return '🚗';
      case DecisionContext.other:
        return '📍';
    }
  }
}
