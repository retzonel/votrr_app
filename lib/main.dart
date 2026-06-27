import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votrr/app.dart';

import 'firebase_options.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//init widgets
  WidgetsFlutterBinding.ensureInitialized();

//lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //incase we cant get google font, fallback
  GoogleFonts.config.allowRuntimeFetching = false;

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

  FlutterNativeSplash.remove();

//run
  runApp(
    const ProviderScope(
      child: VotrrApp(),
    ),
  );
}
