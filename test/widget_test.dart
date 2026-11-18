import 'package:flutter_test/flutter_test.dart';
import 'package:agrismart/main.dart';

void main() {
  testWidgets('AgriSmart app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const AgriSmartApp());

    expect(find.text('AgriSmart'), findsOneWidget);
    expect(find.text('Parcelle Nord'), findsOneWidget);
    expect(find.text('Parcelle Sud'), findsOneWidget);
    expect(find.text('Serre 1'), findsOneWidget);
    expect(find.text('Parcelle Est'), findsOneWidget);
  });
}