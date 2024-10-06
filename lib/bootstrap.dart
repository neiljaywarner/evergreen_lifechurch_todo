import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options_dev.dart';
import 'package:flutter/widgets.dart';


Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Note: google-services.json and firebase_options_dev.dart
  // ok to add to public repo per docs.
  // TODO(neiljaywarner): use app check in prod and security rules for database.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('fcm token below');
  debugPrint(fcmToken);
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // TODO(neiljaywarner): Proper error handling

  runApp(await builder());
}
