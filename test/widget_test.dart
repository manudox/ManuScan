import 'package:flutter_test/flutter_test.dart';
import 'package:petro_scan/main.dart';

void main() {
  testWidgets('La app inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const ManuScanApp());

    expect(find.byType(ManuScanApp), findsOneWidget);
  });
}