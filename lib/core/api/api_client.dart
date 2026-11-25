import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// The only place that talks to the network.
///
/// Public methods return a checked Response (status already verified) or
/// throw one of our ApiException classes.
class ApiClient {
  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  /// The real client for the app. Tests can use ApiClient(fakeClient) instead.
  factory ApiClient.live() => ApiClient(http.Client());

  final http.Client _client;
  final String host;

  static const _timeout = Duration(seconds: 10);

  /// Headers in one place.
  Map<String, String> get _headers => const {'Accept': 'application/json'};

  // ---------- public API ----------

  Future<http.Response> get(String path, {Map<String, String>? query}) {
    final uri = Uri.https(host, path, query);
    return _request(() => _client.get(uri, headers: _headers));
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) {
    final uri = Uri.https(host, path);
    return _request(
      () => _client.post(
        uri,
        headers: {..._headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );
  }

  /// Turns the body into JSON. A broken body becomes BadResponseException.
  dynamic decode(http.Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const BadResponseException('body is not valid JSON');
    }
  }

  // ---------- private steps ----------

  /// send -> log -> check. The order matters: status is checked BEFORE the body.
  Future<http.Response> _request(Future<http.Response> Function() call) async {
    final response = await _send(call);
    _log(response);
    _check(response);
    return response;
  }

  /// Runs the call with a 10-second timeout.
  /// No route or no answer -> NoConnectionException.
  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      return await call().timeout(_timeout);
    } on SocketException {
      throw const NoConnectionException(); // airplane mode, wrong host
    } on TimeoutException {
      throw const NoConnectionException(); // Wi-Fi that leads nowhere
    } on http.ClientException {
      throw const NoConnectionException(); // other transport problems
    }
  }

  /// Status -> our exception.
  void _check(http.Response response) {
    final status = response.statusCode;
    if (status == 401) throw const UnauthorizedException();
    if (status == 404) throw const NotFoundException();
    if (status >= 500) throw ServerException(status);
    if (status < 200 || status >= 300) {
      throw BadResponseException('unexpected status $status');
    }
  }

  /// Debug only: one line per response, visible in DevTools -> Logging.
  void _log(http.Response response) {
    if (!kDebugMode) return;
    final request = response.request;
    log(
      '${request?.method} ${request?.url} -> ${response.statusCode}',
      name: 'api',
    );
  }
}
