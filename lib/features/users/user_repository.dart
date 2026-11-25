import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_cache.dart';

class UsersResult {
  final List<User> items;
  final bool fromCache;
  const UsersResult({required this.items, this.fromCache = false});
}

abstract interface class UserRepository {
  Future<UsersResult> getAll();
  Future<User> getById(int id);
  Future<User> create(User draft);
}

class HttpUserRepository implements UserRepository {
  final ApiClient _api;
  final UsersCache _cache;

  HttpUserRepository(this._api, this._cache);

  @override
  Future<UsersResult> getAll() async {
    try {
      final response = await _api.get('/users');
      final raw = _api.decode(response) as List<dynamic>;
      final users = raw
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
      await _cache.save(users);
      return UsersResult(items: users);
    } on NoConnectionException {
      final saved = await _cache.load();
      if (saved == null) rethrow;
      return UsersResult(items: saved, fromCache: true);
    } on ApiException {
      rethrow;
    } on TypeError catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  @override
  Future<User> getById(int id) async {
    final response = await _api.get('/users/$id');
    final raw = _api.decode(response) as Map<String, dynamic>;
    return User.fromJson(raw);
  }

  @override
  Future<User> create(User draft) async {
    final response = await _api.post('/users', draft.toJson());
    final raw = _api.decode(response) as Map<String, dynamic>;
    return User.fromJson(raw);
  }
}
