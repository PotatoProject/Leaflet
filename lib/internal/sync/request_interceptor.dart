import 'package:dio/dio.dart';
import 'package:potato_notes/internal/logger_provider.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/controller.dart';
import 'package:potato_notes/internal/utils.dart';

class RequestInterceptor extends InterceptorsWrapper with LoggerProvider {
  @override
  Future onRequest(RequestOptions options) async {
    logger.v(
      "Going to send ${options.method.toUpperCase()} to ${options.uri.toString()}",
    );
    final Map<String, dynamic> headers = options.headers;
    final bool useToken = headers["useToken"] == true;
    final bool useRefreshToken = headers["useRefreshToken"] == true;

    if (useToken) {
      headers.remove("useToken");
      final String? token = prefs.accessToken;
      headers.putIfAbsent("Authorization", () => "Bearer $token");
    } else if (useRefreshToken) {
      headers.remove("useRefreshToken");
      final String? token = prefs.refreshToken;
      headers.putIfAbsent("Authorization", () => "Bearer $token");
    }

    return super.onRequest(options.copyWith(headers: headers));
  }

  @override
  Future onResponse(Response response) {
    final List<String> uriParts =
        response.realUri.toString().replaceFirst(prefs.apiUrl, "").split("/");
    uriParts.removeAt(0);
    logger.v(
      "(${response.request.method.toUpperCase()} /${uriParts.join("/")}) Server responded with (${response.statusCode}): ${response.data}",
    );
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) async {
    if (err.response?.statusCode == 401) {
      final AuthResponse response = await Controller.account.refreshToken();
      if (response.status) {
        final RequestOptions rOptions = err.request!;
        final Options options = Options(
          method: rOptions.method,
          sendTimeout: rOptions.sendTimeout,
          receiveTimeout: rOptions.receiveTimeout,
          extra: rOptions.extra,
          headers: Utils.asMap<String, dynamic>(rOptions.headers
              .update("Authorization", (value) => prefs.getToken())),
          responseType: rOptions.responseType,
          contentType: rOptions.contentType,
          validateStatus: rOptions.validateStatus,
          receiveDataWhenStatusError: rOptions.receiveDataWhenStatusError,
          followRedirects: rOptions.followRedirects,
          maxRedirects: rOptions.maxRedirects,
          requestEncoder: rOptions.requestEncoder,
          responseDecoder: rOptions.responseDecoder,
          listFormat: rOptions.listFormat,
        );

        return dio.request(
          rOptions.path,
          options: options,
          onReceiveProgress: err.request!.onReceiveProgress,
          onSendProgress: err.request!.onSendProgress,
        );
      }
    }
    return super.onError(err);
  }
}
