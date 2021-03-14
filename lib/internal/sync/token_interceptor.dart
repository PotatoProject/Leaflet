import 'package:dio/dio.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';
import 'package:potato_notes/internal/utils.dart';

class TokenInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err) async {
    if (err.response?.statusCode == 401) {
      final AuthResponse response = await AccountController.refreshToken();
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
