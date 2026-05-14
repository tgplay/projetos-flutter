import 'package:flutter_test/flutter_test.dart';
import 'package:palco/database/app_database.dart';
import 'package:palco/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final db = AppDatabase();
    await tester.pumpWidget(PalcoApp(db: db));
    expect(find.text('Palco'), findsWidgets);
    await db.close();
  });
}
