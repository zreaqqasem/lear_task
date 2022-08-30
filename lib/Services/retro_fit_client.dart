import 'package:dio/dio.dart';
import 'package:lear_task/Models/quote_model.dart';
import 'package:retrofit/http.dart';
part 'retro_fit_client.g.dart';

@RestApi()
abstract class RetroFitClient {
  factory RetroFitClient(Dio dio, {String baseUrl}) = _RetroFitClient;

  @GET("https://zenquotes.io/api/random")
  Future<List<Quote>>getQuote();

  @GET("https://inspirobot.me/api?generate=true")
  Future<String>getImageUrl();
}

