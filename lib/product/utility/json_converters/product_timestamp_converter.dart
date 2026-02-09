import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// A [JsonConverter] that converts between [DateTime] and [Timestamp].
class ProductTimestampConverter implements JsonConverter<DateTime, Object> {
  const ProductTimestampConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    }
    return DateTime.now();
  }

  @override
  Object toJson(DateTime object) {
    return object.toIso8601String();
  }
}
