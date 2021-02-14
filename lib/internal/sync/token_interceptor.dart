import 'package:dio/dio.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/sync/account_controller.dart';

class TokenInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err) async {
    if (err.response?.statusCode == 401) {
      final AuthResponse response = await AccountController.refreshToken();
      if (response.status) {
        final RequestOptions options = err.request;
        return dio.request(options.path,
            options: options
              ..headers.update("Authorization", (value) => prefs.getToken()),
            onReceiveProgress: err.request.onReceiveProgress,
            onSendProgress: err.request.onSendProgress);
      }
    }
    return super.onError(err);
  }
}
