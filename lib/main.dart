import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: VotrrApp(),
    ),
  );
}

/// The root widget of the application.
///
/// ConsumerWidget (from Riverpod) is like a regular StatelessWidget
/// but it can "watch" providers. We'll use this pattern a lot.
class VotrrApp extends ConsumerWidget {
  const VotrrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch() subscribes to the router — whenever auth state
    // changes, the router will automatically redirect users
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Votrr',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
