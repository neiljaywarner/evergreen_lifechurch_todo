import 'dart:async';
import 'dart:ui';

import 'package:evergreen_lifechurch_todo/app.dart';
import 'package:evergreen_lifechurch_todo/firebase_options_dev.dart';
import 'package:evergreen_lifechurch_todo/localization/string_hardcoded.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Note: google-services.json and firebase_options_dev.dart
  // ok to add to public repo per docs.
  // TODO(neiljaywarner): use app check in prod and security rules for database.

  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('fcm token below');
  debugPrint(fcmToken);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // * Entry point of the app
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
}
