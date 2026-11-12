
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/add_food_screen.dart';

void main() {
  testWidgets('Add Food screen displays food form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AddFoodScreen(),
      ),
    );

    expect(find.text('Add Food'), findsOneWidget);
    expect(find.text('Food Name'), findsOneWidget);
    expect(find.text('Quantity'), findsOneWidget);
    expect(find.text('Save Food'), findsOneWidget);
  });
}
