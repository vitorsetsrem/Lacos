import 'package:flutter_test/flutter_test.dart';
import 'package:lacos_app/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LacosApp());
    await tester.pump();

    expect(find.text("Laço's"), findsAny);
  });
}
