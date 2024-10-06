import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  await FirebaseAnalytics.instance.logAppOpen();
  await FirebaseAuth.instance.signInAnonymously();
// Create a new user with a first and last name
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

// Add a new document with a generated ID
  var db = FirebaseFirestore.instance;
  db.collection("users").add(user).then((DocumentReference doc) =>
      print('DocumentSnapshot added with ID: ${doc.id}'));
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // TODO(neiljaywarner): Proper error handling

  runApp(await builder());
}
