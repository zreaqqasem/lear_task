
import 'package:lear_task/Models/quote_model.dart';

abstract class QuoteApiState {
  const QuoteApiState();
}

class QuoteApiInitial extends QuoteApiState {
  const QuoteApiInitial();
}

class QuoteApiLoading extends QuoteApiState {
  const QuoteApiLoading();
}

class QuoteApiCompleted extends QuoteApiState {
  final List<Quote> response;
  const QuoteApiCompleted(this.response);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is QuoteApiCompleted && o.response == response;
  }

  @override
  int get hashCode => response.hashCode;


}

class QuoteApiError extends QuoteApiState {
  final String message;
  const QuoteApiError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is QuoteApiError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;

}
