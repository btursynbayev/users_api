import 'api_exception.dart';

/// A short text for the user. The switch is exhaustive: if you add a new
/// ApiException, the compiler forces you to add its text here.
extension ApiExceptionMessage on ApiException {
  String get message => switch (this) {
    NoConnectionException() => 'No connection. Check your internet.',
    NotFoundException() => 'The requested data was not found.',
    UnauthorizedException() => 'You are not allowed to do this.',
    ServerException(:final status) =>
      'Server error ($status). Try again later.',
    BadResponseException() => 'The server answer could not be read.',
  };
}
