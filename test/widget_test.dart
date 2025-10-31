import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heritageapp/main.dart';

void main() {
  testWidgets('Heritage App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyHeritageApp());

    // Verify that the app starts with Home screen
    expect(find.text('My Heritage'), findsOneWidget);
    expect(find.text('Welcome Back! 👋'), findsOneWidget);
  });

  testWidgets('Navigation between screens works', (WidgetTester tester) async {
    await tester.pumpWidget(MyHeritageApp());

    // Verify Home screen is initially shown
    expect(find.text('QUICK STATS'), findsOneWidget);

    // Tap on Community tab
    await tester.tap(find.text('Community'));
    await tester.pumpAndSettle();

    // Verify Community screen is shown
    expect(find.text('Community Forum'), findsOneWidget);
    expect(find.text('Language Learning'), findsOneWidget);

    // Tap on Family Tree tab
    await tester.tap(find.text('Family Tree'));
    await tester.pumpAndSettle();

    // Verify Family Tree screen is shown
    expect(find.text('Family Tree'), findsOneWidget);
    expect(find.text('Build Your Family Tree'), findsOneWidget);
  });

  testWidgets('Home screen displays all sections', (WidgetTester tester) async {
    await tester.pumpWidget(MyHeritageApp());

    // Verify all main sections are present
    expect(find.text('QUICK STATS'), findsOneWidget);
    expect(find.text('FEATURED HERITAGE SITES'), findsOneWidget);
    expect(find.text('RECENT ACTIVITY'), findsOneWidget);

    // Verify stats cards are present
    expect(find.text('Heritage Sites'), findsOneWidget);
    expect(find.text('Family Trees'), findsOneWidget);
    expect(find.text('Photos'), findsOneWidget);
  });

  testWidgets('Mental Health screen has mood tracking', (WidgetTester tester) async {
    await tester.pumpWidget(MyHeritageApp());

    // Navigate to Mental Health screen
    await tester.tap(find.text('Wellness'));
    await tester.pumpAndSettle();

    // Verify mood tracking elements
    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(find.text('Mood Rating:'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('Save Mood Entry'), findsOneWidget);
  });

  testWidgets('Events screen shows cultural events', (WidgetTester tester) async {
    await tester.pumpWidget(MyHeritageApp());

    // Navigate to Events screen
    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();

    // Verify events are displayed
    expect(find.text('Cultural Events'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(find.text('Register'), findsWidgets);
  });
}