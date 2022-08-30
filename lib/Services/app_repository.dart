import 'package:lear_task/Models/quote_model.dart';
import 'package:lear_task/Services/api_helper.dart';

abstract class AppBaseRepository {
  Future<List<Quote>> getQuote();
  Future<String>getImageUrl();

}
class AppRepository implements AppBaseRepository {
  @override
  Future<String> getImageUrl() async {
   return await ApiHelper().getImageUrl();
  }

  @override
  Future<List<Quote>> getQuote() async{
    return await ApiHelper().getQuote();
  }


}