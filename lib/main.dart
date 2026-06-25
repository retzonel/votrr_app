import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:votrr/app.dart';

import 'firebase_options.dart';

Future<void> main() async {
//init widgets
  WidgetsFlutterBinding.ensureInitialized();

//lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

//init firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    host: 'firestore.googleapis.com',
    sslEnabled: true,
    persistenceEnabled: true,
  );
  print('Firestore settings applied');

//run
  runApp(
    const ProviderScope(
      child: VotrrApp(),
    ),
  );
}
