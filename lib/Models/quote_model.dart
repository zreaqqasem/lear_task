import 'package:json_annotation/json_annotation.dart';
part 'quote_model.g.dart';

@JsonSerializable()
class Quote {
  Quote(
    this.q,
    this.a,
    this.h,
  );

  @JsonKey(name: "q", includeIfNull: false)
  String q;
  @JsonKey(name: "a", includeIfNull: false)
  String a;
  @JsonKey(name: "h", includeIfNull: false)
  String h;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);

}
