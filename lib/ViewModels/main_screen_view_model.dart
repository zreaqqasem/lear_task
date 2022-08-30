import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lear_task/AppStates/image_api_states.dart';
import 'package:lear_task/Services/app_repository.dart';

class ImageViewModel extends Cubit<ImageApiState> {
  ImageViewModel() : super(const ImageApiInitial());
  final AppRepository _repo  = AppRepository();
  @override
  Future<void> close() async {
    return super.close();
  }

  Future<void>getImageUrl()async {
    try {
      emit(const ImageApiLoading());
      await _repo
          .getImageUrl()
          .catchError((Object obj) {
        switch (obj.runtimeType) {
          case DioError:
            final res = (obj as DioError).response;
            emit(ImageApiError("there's an error : ${res?.data["detail"]}"));
            break;
          default:
            emit(const ImageApiError("there's an error "));
        }
      }).then((value) {
        emit(ImageApiCompleted(value));
      });
    } on Exception {
      emit(const ImageApiError("Error while trying to fetch data"));
    }
  }

}

