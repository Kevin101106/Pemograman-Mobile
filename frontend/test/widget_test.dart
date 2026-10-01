import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('FreshTrack app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const FreshTrackApp());

    expect(find.text('FreshTrack'), findsOneWidget);
    expect(find.text('Keep your food fresh'), findsOneWidget);
  });
}