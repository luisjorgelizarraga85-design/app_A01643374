import 'package:flutter_test/flutter_test.dart';
import 'package:app_a01643374/main.dart';

void main() {
  testWidgets('Cell Counter smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CellCounterApp()); // 👈 nombre correcto
    expect(find.text('Cell Counter'), findsOneWidget);
  });
}