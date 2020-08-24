import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'network_callback.dart';
import 'network_parser.dart';

class NetworkService {
  static NetworkService _sInstance;

  // ignore: non_constant_identifier_names
  static bool _DEBUG = false;
  Map<String, String> _headers = {};

  static void init(bool isDebug) {
    _DEBUG = isDebug;
  }

  NetworkService._();

  factory NetworkService.shared() {
    if (_sInstance == null) {
      _sInstance = NetworkService._();
    }
    return _sInstance;
  }

  void addHeader(String key, String value) {
    _headers[key] = value;
  }

  void sendGETRequest(
      {@required String url,
      Map<String, dynamic> params,
      ParseCallback parser,
      Map<String, String> headers,
      NetworkCallback callback}) {
    assert(url != null);

    if (headers == null) {
      headers = _headers;
    }

    if (_DEBUG) {
      _debugResponse(url, null, callback);
      return;
    }
    print('--> Get URL: $url');
    http.get(url, headers: headers).then((result) {
      if (result.statusCode == 200) {
        _getResponse(true, result.body, callback, parser: parser);
      } else {
        _getResponse(false, _getMsgError(result.statusCode, result.body), callback);
      }
    }, onError: (e) {
      _getResponse(false, e.message, callback);
    });
  }

  void _getResponse(bool isOK, String data, NetworkCallback callback, {ParseCallback parser}) {
    print('--> Data from response: \n$data');
    if (isOK) {
      if (callback != null) {
        if (data.isEmpty) {
          callback(TTNetworkCallback(isOK: true, data: {}));
          return;
        }
        final _data = json.decode(data);
        if (_data is Map && _data['code'] == -1) {
          callback(TTNetworkCallback(isOK: false, msgError: _data['error'] ?? _getMsgError(_data['code'], '')));
          return;
        }
        if (_data is bool) {
          callback(TTNetworkCallback(isOK: true, data: {'isTrue': _data}));
          return;
        }
        final dt = parser != null ? parser(_data) : _data;
        callback(TTNetworkCallback(isOK: true, data: dt));
      }
    } else {
      if (callback != null) {
        callback(TTNetworkCallback(
          isOK: false,
          msgError: data, // please_try_again_later
        ));
      }
    }
  }

  void _debugResponse(String url, dynamic body, NetworkCallback callback) {
    // _demo.getResponse(url, body, callback);
  }

  String _getMsgError(int id, String body) {
    final map = <String, dynamic>{};
    map.addAll(json.decode(body));
    print(']--> Code: $id\n]--> Message: ${map["message"]}');
    return map["message"];
  }
}
