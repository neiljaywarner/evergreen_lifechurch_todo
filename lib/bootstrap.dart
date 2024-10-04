import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';


Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // TODO(neiljaywarner): Proper error handling

  runApp(await builder());
}
