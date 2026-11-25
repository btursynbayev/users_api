import 'package:users_api/core/api/api_exception.dart';
import 'package:users_api/features/users/user.dart';
import 'package:users_api/features/users/user_repository.dart';

class FakeUserRepository implements UserRepository {
  final bool fail;
  final Duration delay;

  FakeUserRepository({this.fail = false, this.delay = Duration.zero});

  @override
  Future<UsersResult> getAll() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (fail) throw const NoConnectionException();
    return const UsersResult(
      items: [
        User(
          id: 1,
          name: 'Alice',
          username: 'alice',
          email: 'alice@example.com',
          phone: '123',
          website: 'alice.dev',
          address: Address(
            street: 'Main St',
            suite: '1',
            city: 'Almaty',
            zipcode: '050000',
            geo: Geo(lat: 43.0, lng: 76.0),
          ),
          company: (name: 'Acme', catchPhrase: 'We build'),
        ),
        User(
          id: 2,
          name: 'Bob',
          username: 'bob',
          email: 'bob@example.com',
          phone: '456',
          website: null,
          address: Address(
            street: 'Second St',
            suite: '2',
            city: 'Astana',
            zipcode: '010000',
            geo: Geo(lat: 51.0, lng: 71.0),
          ),
          company: (name: 'Beta', catchPhrase: 'We test'),
        ),
      ],
    );
  }

  @override
  Future<User> getById(int id) async => throw UnimplementedError();

  @override
  Future<User> create(User draft) async => throw UnimplementedError();
}
