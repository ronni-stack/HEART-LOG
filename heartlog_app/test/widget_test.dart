import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heartlog/screens/main_scaffold.dart';
import 'package:heartlog/theme/app_theme.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Main scaffold renders all tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MainScaffold(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(MainScaffold), findsOneWidget);
  });
}
