import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:users_api/features/settings/settings_model.dart';
import 'package:users_api/features/users/users_model.dart';
import 'package:users_api/features/users/users_screen.dart';

import '../../fakes/fake_user_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('shows the offline view and Retry', (tester) async {
    final model = UsersModel(FakeUserRepository(fail: true));
    await model.load();

    final settings = SettingsModel(
      SharedPreferencesAsync(),
      dark: false,
      city: null,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: model),
          ChangeNotifierProvider.value(value: settings),
        ],
        child: const MaterialApp(home: Scaffold(body: UsersScreen())),
      ),
    );

    expect(find.text('No connection'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
