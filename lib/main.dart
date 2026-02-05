import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/clear_app.dart';
import 'data/repositories/decision_repository.dart';
import 'presentation/providers/decision_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  final repository = DecisionRepository();
  await repository.init();
  
  runApp(
    ProviderScope(
      overrides: [
        decisionRepositoryProvider.overrideWithValue(repository),
      ],
      child: const Deliberate(),
    ),
  );
}
