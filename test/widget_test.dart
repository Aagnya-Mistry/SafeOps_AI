import 'package:flutter_test/flutter_test.dart';

import 'package:safeguard/main.dart';

void main() {
  testWidgets('splash screen renders auth entry points', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SafeguardApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('STAY SAFE'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('SAFEOPS AI'), findsOneWidget);
  });
}
