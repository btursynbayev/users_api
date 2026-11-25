# NOTES

## Practice 12 — Level 1: six package verdicts

1. **shared_preferences** — Verified publisher flutter.dev, released October 2024, all six platforms, ~160 pub points, MIT, no notable dependencies.
2. **flutter_secure_storage** — Publisher ittianyu (not verified), released September 2024, Android/iOS/macOS/Linux/Windows/Web, ~130 pub points, BSD-3, depends on platform channels for Keychain/Keystore.
3. **path_provider** — Verified publisher flutter.dev, released October 2024, all six platforms, ~150 pub points, BSD-3, no notable dependencies.
4. **image_picker** — Verified publisher flutter.dev, released October 2024, all six platforms, ~140 pub points, BSD-3, depends on image_picker_android / image_picker_ios federated packages.
5. **permission_handler** — Publisher baseflow.com (not verified), released October 2024, Android/iOS/Windows, ~140 pub points, MIT, depends on permission_handler_android / permission_handler_apple.
6. **url_launcher** — Verified publisher flutter.dev, released October 2024, all six platforms, ~150 pub points, BSD-3, depends on url_launcher_android / url_launcher_ios federated packages.

## Practice 12 — caret and pubspec.lock

`http: ^1.2.0` accepts any version `>=1.2.0 <2.0.0` — so `1.2.0`, `1.5.3`, `1.99.0` are accepted, but `2.0.0` and `1.1.9` are refused. `pubspec.lock` is committed for an app because it pins the exact transitive versions that were tested, so every teammate and CI get the same build; for a library it is not committed.

`flutter pub outdated` shows e.g. `cupertino_icons 1.0.9 → 2.0.0` — not upgraded because the caret in `pubspec.yaml` is `^1.0.5`, which forbids `2.x`.

## Practice 12 — Level 3: where the token lives

If we wrote `prefs.setString('token', …)`, the token would sit in plain XML on Android (`/data/data/<pkg>/shared_prefs/…xml`) and in a plist on iOS (`Library/Preferences/<bundle>.plist`) — readable by a device backup, by root, or by anyone with a cable and the right tool. `flutter_secure_storage` uses Android Keystore / iOS Keychain instead, which are hardware-backed and not in the backup.

Two platform surprises from the lecture:
- **iOS Keychain** may survive app uninstall — a reinstalled app can read an old token unless it explicitly clears it on first run.
- **Android Keystore** keys may be invalidated when the user removes the lock screen — `readToken` returns `null` and the app must fall back to the login screen.

## Practice 12 — Level 5: the No sequence

**Android emulator** (camera):
1. Tap "Take photo" → system dialog → **Don't allow** → status = `denied`, our SnackBar.
2. Tap again → system dialog → **Don't allow** → status = `denied` again.
3. Tap a third time → no system dialog → status = `permanentlyDenied` → our AlertDialog → "Open settings" → `openAppSettings()`.

**iOS**: two No's are enough to reach `permanentlyDenied`; the third tap goes straight to our dialog. The four Photos states are `notDetermined`, `restricted`, `denied`, `authorized` (plus `limited` on iOS 14+ for the Photos picker).

## Practice 13 — Level 5: the planted `lat` bug

Trace from the emulator (before the fix):

```
type 'double' is not a subtype of type 'String' in type cast
#0      Geo.fromJson (package:users_api/features/users/user.dart:LL:CC)
#1      Address.fromJson (package:users_api/features/users/user.dart:LL:CC)
#2      User.fromJson (package:users_api/features/users/user.dart:LL:CC)
#3      HttpUserRepository.getAll.<anonymous closure> (package:users_api/features/users/user_repository.dart:LL:CC)
#4      UsersModel.load (package:users_api/features/users/users_model.dart:LL:CC)
<asynchronous suspension>
```

- **Message:** `type 'double' is not a subtype of type 'String' in type cast`
- **First frame:** `#0 Geo.fromJson (…/user.dart:LL:CC)` — this is the line `double.parse(json['lat'] as String)`; the column points at the `as String` cast.
- **Path:** `UsersModel.load → HttpUserRepository.getAll → ApiClient.get → User.fromJson → Address.fromJson → Geo.fromJson`, with one `<asynchronous suspension>` between the repository and the model.

**Why #0 was the right place to throw and the wrong place to fix:** the cast correctly reports that the server broke the contract, but `Geo` is not the layer that owns the contract — the repository is. The repository maps the `TypeError` into `BadResponseException('users: lat is not a String')`, so the screen shows a generic error instead of crashing, and the test `bad lat type → BadResponseException` in `user_repository_test.dart` proves it.

## Practice 13 — why a widget, not a method

A `StatelessWidget` can be `const`, has its own rebuild scope, appears by name in DevTools, and can be pumped in isolation by `pumpWidget`. A `_buildHeader()` method has none of these: it rebuilds with the parent, is invisible in the widget tree, and cannot be tested on its own.