// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

enum EventType {
  Dota,
  CS,
  RL,
  Other,
}

@freezed
sealed class Event with _$Event {
  const factory Event({
    required String eventName,
    required DateTime eventTime,
    required EventType eventType,
    required List<int> gardeners,
    required int hours,
    Map<int, int>? deductions,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
