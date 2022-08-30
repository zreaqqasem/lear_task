import 'package:dio/dio.dart';
import 'package:lear_task/Models/quote_model.dart';
import 'package:lear_task/Services/retro_fit_client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiHelper {
  static final ApiHelper _instance = ApiHelper._internal();
  Dio? _dio;
  RetroFitClient? _client;
  String?myVerificationId;
  int? forceResendingToken;

  factory ApiHelper() {
    return _instance;
  }

  ApiHelper._internal() {
    _dio = Dio();
    _dio!.options.connectTimeout = 15000;
    _dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      request: true,
      compact: true,
    ));
    _client = RetroFitClient(_dio!);
  }

  Future<List<Quote>> getQuote() async {
    return await _client!.getQuote();
  }

  Future<String>getImageUrl() async{
    return await _client!.getImageUrl();
  }
}