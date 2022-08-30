import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lear_task/Services/app_repository.dart';
import '../AppStates/quote_states.dart';

class QuoteViewModel extends Cubit<QuoteApiState> {
  QuoteViewModel() : super(const QuoteApiInitial());
  final AppRepository _repo  = AppRepository();
  Future<void>getQuote()async {
    try {
      emit(const QuoteApiLoading());
      await _repo
          .getQuote().then((value) {
        emit(QuoteApiCompleted(value));
      }).catchError((Object obj) {
        switch (obj.runtimeType) {
          case DioError:
            final res = (obj as DioError).response;
            emit(QuoteApiError("there's an error : ${res?.data["detail"]}"));
            break;
          default:
            emit(const QuoteApiError("there's an error "));
        }
      });
    } on Exception {
      emit(const QuoteApiError("Error while trying to fetch data"));
    }
  }

}

