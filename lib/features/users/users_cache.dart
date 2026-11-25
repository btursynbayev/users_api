import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'user.dart';

class UsersCache {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.json');
  }

  Future<void> save(List<User> users) async {
    final file = await _file();
    final data = jsonEncode([for (final u in users) u.toJson()]);
    await file.writeAsString(data);
  }

  Future<List<User>?> load() async {
    final file = await _file();
    if (!await file.exists()) return null;
    final data = await file.readAsString();
    final raw = jsonDecode(data) as List<dynamic>;
    return raw.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }
}
