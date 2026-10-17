import 'package:flutter_test/flutter_test.dart';
import 'package:mahua_xpress/main.dart';

void main() {
  testWidgets('App smoke test - verifies splash renders and transitions', (WidgetTester tester) async {
    await tester.pumpWidget(const MahuaXpressApp());
    expect(find.text('mahua xpress'), findsOneWidget);

    // Advance time past the splash screen
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    // Verify main screen renders
    expect(find.text('Delivery'), findsOneWidget);
  });
}
