# users_api

Users app with auth, settings, offline cache and profile photo.
Practices 11–13.

## Structure

```
lib/
  main.dart
  core/api/           — ApiClient, ApiException
  core/storage/       — SecureStore
  features/users/     — user, repository, cache, model, screen, widgets
  features/auth/      — AuthModel, LoginScreen
  features/settings/  — SettingsModel, SettingsScreen
  features/profile/   — ProfileScreen
test/
  fakes/              — FakeUserRepository
  features/users/     — user, model, repository, screen tests
tool/check_layers.sh  — layer rule check
```

## Quality checklist

```
$ flutter analyze
(no errors — only `deprecated_member_use` info from the beta channel)

$ dart format .
Formatted 25 files (0 changed)

$ flutter test
00:01 +8: All tests passed!

$ ./tool/check_layers.sh
✅ Layer check passed.
```