import 'package:flutter_test/flutter_test.dart';
import 'package:users_api/features/users/user.dart';

void main() {
  group('User.fromJson', () {
    test('parses a valid user', () {
      final json = {
        'id': 1,
        'name': 'Leanne Graham',
        'username': 'Bret',
        'email': 'Sincere@april.biz',
        'phone': '1-770-736-8031 x56442',
        'website': 'hildegard.org',
        'address': {
          'street': 'Kulas Light',
          'suite': 'Apt. 556',
          'city': 'Gwenborough',
          'zipcode': '92998-3874',
          'geo': {'lat': '-37.3159', 'lng': '81.1496'},
        },
        'company': {
          'name': 'Romaguera-Crona',
          'catchPhrase': 'Multi-layered client-server neural-net',
        },
      };

      final user = User.fromJson(json);
      expect(user.name, 'Leanne Graham');
      expect(user.address.city, 'Gwenborough');
      expect(user.address.geo.lat, -37.3159);
    });

    test('throws TypeError when id is a String', () {
      final json = {
        'id': '1',
        'name': 'Leanne Graham',
        'username': 'Bret',
        'email': 'Sincere@april.biz',
        'phone': '1-770-736-8031 x56442',
        'website': 'hildegard.org',
        'address': {
          'street': 'Kulas Light',
          'suite': 'Apt. 556',
          'city': 'Gwenborough',
          'zipcode': '92998-3874',
          'geo': {'lat': '-37.3159', 'lng': '81.1496'},
        },
        'company': {
          'name': 'Romaguera-Crona',
          'catchPhrase': 'Multi-layered client-server neural-net',
        },
      };

      expect(() => User.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
