
abstract class ImageApiState {
  const ImageApiState();
}

class ImageApiInitial extends ImageApiState {
  const ImageApiInitial();
}

class ImageApiLoading extends ImageApiState {
  const ImageApiLoading();
}

class ImageApiCompleted extends ImageApiState {
  final String response;
  const ImageApiCompleted(this.response);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ImageApiCompleted && o.response == response;
  }

  @override
  int get hashCode => response.hashCode;


}

class ImageApiError extends ImageApiState {
  final String message;
  const ImageApiError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ImageApiError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}
