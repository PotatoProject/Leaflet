// @dart=2.12

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart' as h;
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';

typedef void OnProgressCallback(int current, int total);

/// A very simple wrapper around http for some common behaviour
class HttpClient {
  final io.HttpClient _rawClient = io.HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..badCertificateCallback =
        ((io.X509Certificate cert, String host, int port) => true);
  final h.Client _innerClient = h.Client();

  Future<h.Response> get(
    String url, {
    Map<String, String>? headers,
  }) {
    return request('get', url, headers: headers);
  }

  Future<h.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return request(
      'post',
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  Future<h.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return request(
      'put',
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  Future<h.Response> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return request(
      'patch',
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  Future<h.Response> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return request(
      'delete',
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }

  Future<h.Response> head(
    String url, {
    Map<String, String>? headers,
  }) {
    return request(
      'head',
      url,
      headers: headers,
    );
  }

  Future<h.Response> request(
    String method,
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final Uri normalizedUrl = Uri.parse(url);
    late h.Response response;

    switch (method) {
      case 'get':
        response = await _innerClient.get(
          normalizedUrl,
          headers: headers,
        );
        break;
      case 'post':
        response = await _innerClient.post(
          normalizedUrl,
          headers: headers,
          body: body,
          encoding: encoding,
        );
        break;
      case 'put':
        response = await _innerClient.put(
          normalizedUrl,
          headers: headers,
          body: body,
          encoding: encoding,
        );
        break;
      case 'patch':
        response = await _innerClient.patch(
          normalizedUrl,
          headers: headers,
          body: body,
          encoding: encoding,
        );
        break;
      case 'delete':
        response = await _innerClient.delete(
          normalizedUrl,
          headers: headers,
          body: body,
          encoding: encoding,
        );
        break;
      case 'head':
        response = await _innerClient.head(
          normalizedUrl,
          headers: headers,
        );
        break;
      default:
        throw ArgumentError.value(
          method,
          "method",
          "There is no handler for such method",
        );
    }

    return tokenInterceptor(response);
  }

  Future<h.Response> tokenInterceptor(h.Response res) async {
    if (res.statusCode == 401) {
      final AuthResponse response = await AccountController.refreshToken();

      if (response.status) {
        final h.Request req = res.request! as h.Request;
        final Map<String, String> newHeaders = req.headers;
        newHeaders["Authorization"] = await prefs.getToken();

        return request(
          req.method,
          req.url.toString(),
          headers: newHeaders,
          body: req.body,
          encoding: req.encoding,
        );
      }
    }

    return res;
  }

  Future<String> upload({
    required String url,
    required io.File file,
    OnProgressCallback? onProgressChanged,
    Map<String, String>? headers,
    String method = "post",
  }) async {
    final fileStream = file.openRead();

    int totalByteLength = file.lengthSync();

    final request = await _rawClient.openUrl(method, Uri.parse(url));

    headers?.forEach((key, value) {
      request.headers.set(key, value);
    });

    request.contentLength = totalByteLength;

    int byteCount = 0;
    Stream<List<int>> streamUpload = fileStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;

          onProgressChanged?.call(byteCount, totalByteLength);

          sink.add(data);
        },
        handleError: (error, stack, sink) {
          print(error.toString());
        },
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    if (httpResponse.statusCode != 200) {
      throw Exception('Error uploading file');
    } else {
      return await _readResponseAsString(httpResponse);
    }
  }

  Future<void> download({
    required String url,
    required String fileName,
    OnProgressCallback? onProgressChanged,
    Map<String, String>? headers,
    String method = "get",
  }) async {
    final request = await _rawClient.openUrl(method, Uri.parse(url));

    headers?.forEach((key, value) {
      request.headers.set(key, value);
    });

    var httpResponse = await request.close();

    int byteCount = 0;
    int totalBytes = httpResponse.contentLength;

    final io.File file = io.File(fileName);

    var raf = file.openSync(mode: io.FileMode.write);

    Completer completer = new Completer<String>();

    httpResponse.listen(
      (data) {
        byteCount += data.length;

        raf.writeFromSync(data);

        onProgressChanged?.call(byteCount, totalBytes);
      },
      onDone: () {
        raf.closeSync();

        completer.complete(file.path);
      },
      onError: (e) {
        raf.closeSync();
        file.deleteSync();
        completer.completeError(e);
      },
      cancelOnError: true,
    );
  }

  Future<String> _readResponseAsString(io.HttpClientResponse response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}
