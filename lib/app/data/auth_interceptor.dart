import 'package:client_id/app/di/init_di.dart';
import 'package:client_id/app/domain/app_api.dart';
import 'package:client_id/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = locator.get<AuthCubit>().state.whenOrNull(
          authorized: (userEntity) => userEntity.accessToken,
        );
    if (accessToken == null) {
      super.onRequest(options, handler);
    } else {
      final headers = options.headers;
      headers["Authorization"] = "Bearer $accessToken";
      super.onRequest(options.copyWith(headers: headers), handler);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await locator.get<AuthCubit>().refreshToken();
        final request = await locator
            .get<AppApi>().request(err.requestOptions.path);
        return handler.resolve(request);
      } catch (_) {
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
