import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  final SharedPreferencesAsync _prefs;
  bool _dark;
  String? _city;

  SettingsModel(this._prefs, {required bool dark, String? city})
    : _dark = dark,
      _city = city;

  bool get dark => _dark;
  String? get city => _city;

  void setDark(bool value) {
    _dark = value;
    notifyListeners();
    _prefs.setBool('darkMode', value);
  }

  void setCity(String? value) {
    _city = value;
    notifyListeners();
    if (value == null) {
      _prefs.remove('cityFilter');
    } else {
      _prefs.setString('cityFilter', value);
    }
  }
}
