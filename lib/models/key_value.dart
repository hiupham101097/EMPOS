import 'package:json_annotation/json_annotation.dart';

part 'key_value.g.dart';

//  dart run build_runner build
@JsonSerializable()
class KeyValue {
  late String key;
  late String? value;
  late String? value1;
  late String? value2;
  late String? value3;

  KeyValue({
    required this.key,
    this.value,
    this.value1,
    this.value2,
    this.value3
  });

  factory KeyValue.fromJson(Map<String, dynamic> json) =>
      _$KeyValueFromJson(json);

  Map<String, dynamic> toJson() => _$KeyValueToJson(this);
}
