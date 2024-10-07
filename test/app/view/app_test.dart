import 'package:evergreen_lifechurch_todo/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders app', (tester) async {
      await tester.pumpWidget(const App());
    });
  });
}