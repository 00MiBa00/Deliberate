#!/bin/bash

# add_decision_screen
perl -i -pe 's/Категория решения/Decision Category/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/К какой сфере жизни относится это решение\?/Which area of life does this decision relate to?/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Цель решения/Decision Goal/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Что вы хотите достичь\?/What do you want to achieve?/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Например: Сменить работу/For example: Change job/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Подробности \(опционально\)/Details (optional)/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Дополнительный контекст\.\.\./Additional context.../g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Как вы себя чувствуете прямо сейчас\?/How do you feel right now?/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Энергия и срочность/Energy and Urgency/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Где вы находитесь\?/Where are you?/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Вовлечены другие\?/Others Involved?/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Влияет ли это решение на других людей\?/Does this decision affect other people?/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Только я/Just me/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Другие люди вовлечены/Other people involved/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Чего вы ожидаете от этого решения\?/What do you expect from this decision?/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Опишите ожидаемый результат\.\.\./Describe the expected result.../g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Назад/Back/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Далее/Next/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Сохранить/Save/g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/Шаг /Step /g' lib/presentation/screens/add_decision/add_decision_screen.dart
perl -i -pe 's/ из / of /g' lib/presentation/screens/add_decision/add_decision_screen.dart

# analytics_screen
perl -i -pe 's/Недостаточно данных/Insufficient Data/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/Добавьте решения и оцените результаты/Add decisions and evaluate results/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/Всего решений/Total Decisions/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/С результатами/With Results/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/Ожидают оценки/Awaiting Evaluation/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/Средняя оценка по категориям/Average Rating by Category/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/Эмоции и результаты/Emotions and Results/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/Уровень энергии и успех/Energy Level and Success/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/ решений/ decisions/g' lib/presentation/screens/analytics_screen.dart
perl -i -pe 's/Энергия /Energy /g' lib/presentation/screens/analytics_screen.dart

# review_screen
perl -i -pe 's/Все оценено!/All Evaluated!/g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/У вас нет решений, ожидающих оценки/You have no decisions awaiting evaluation/g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/У вас /You have /g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/ без результатов/ without results/g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/Решения для оценки/Decisions to Evaluate/g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/ день назад/ day ago/g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/ дня назад/ days ago/g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/ дней назад/ days ago/g' lib/presentation/screens/review_screen.dart
perl -i -pe 's/Ожидаемый результат:/Expected Result:/g' lib/presentation/screens/review_screen.dart

# domain models
perl -i -pe 's/Работа/Work/g' lib/domain/models/decision.dart
perl -i -pe 's/Деньги/Money/g' lib/domain/models/decision.dart
perl -i -pe 's/Отношения/Relationships/g' lib/domain/models/decision.dart
perl -i -pe 's/Здоровье/Health/g' lib/domain/models/decision.dart
perl -i -pe 's/Другое/Other/g' lib/domain/models/decision.dart
perl -i -pe 's/Спокойствие/Calm/g' lib/domain/models/decision.dart
perl -i -pe 's/Возбуждение/Excited/g' lib/domain/models/decision.dart
perl -i -pe 's/Тревога/Anxious/g' lib/domain/models/decision.dart
perl -i -pe 's/Стресс/Stressed/g' lib/domain/models/decision.dart
perl -i -pe 's/Уверенность/Confident/g' lib/domain/models/decision.dart
perl -i -pe 's/Сомнения/Uncertain/g' lib/domain/models/decision.dart
perl -i -pe 's/Дома/Home/g' lib/domain/models/decision.dart
perl -i -pe 's/На работе/At Work/g' lib/domain/models/decision.dart
perl -i -pe 's/В дороге/Commute/g' lib/domain/models/decision.dart

echo "Translation complete!"
