import 'package:dio/dio.dart';
import 'package:weather_app/constants/config.dart';

class AppInterceptor extends Interceptor {
  //add something, remove or similar when requesting something in application
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }
}

Dio http = (() {
  Dio dio = Dio(BaseOptions(baseUrl: Config.apiUrl));
  dio.interceptors.add(AppInterceptor());

  return dio;
})();
