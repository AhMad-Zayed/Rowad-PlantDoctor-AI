import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smart_plant_doctor/main.dart';
import 'package:smart_plant_doctor/presentation/providers/app_state.dart';

void main() {
  testWidgets('App starts and builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const SmartPlantDoctorApp(),
      ),
    );

    // Verify that the widget tree has built successfully
    expect(find.byType(SmartPlantDoctorApp), findsOneWidget);
  });
}
