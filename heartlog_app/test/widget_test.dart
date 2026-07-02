import 'package:flutter_test/flutter_test.dart';
import 'package:heartlog/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App renders main scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const HeartLogApp());
    expect(find.byType(MainScaffold), findsOneWidget);
  });
}
