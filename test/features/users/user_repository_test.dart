import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:users_api/core/api/api_client.dart';
import 'package:users_api/core/api/api_exception.dart';
import 'package:users_api/features/users/user_repository.dart';
import 'package:users_api/features/users/users_cache.dart';

void main() {
  group('HttpUserRepository.getById', () {
    test('404 → NotFoundException', () {
      final client = MockClient(
        (_) async => http.Response('{"error":"gone"}', 404),
      );
      final repo = HttpUserRepository(ApiClient(client), UsersCache());

      expect(() => repo.getById(99), throwsA(isA<NotFoundException>()));
    });

    test('500 → ServerException', () {
      final client = MockClient((_) async => http.Response('', 500));
      final repo = HttpUserRepository(ApiClient(client), UsersCache());

      expect(() => repo.getById(1), throwsA(isA<ServerException>()));
    });

    test('SocketException → NoConnectionException', () {
      final client = MockClient((_) async {
        throw const SocketException('down');
      });
      final repo = HttpUserRepository(ApiClient(client), UsersCache());

      expect(() => repo.getById(1), throwsA(isA<NoConnectionException>()));
    });
  });
}
