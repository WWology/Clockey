// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

enum EventType {
  Dota,
  CS,
  RL,
  Other,
  Unknown;

  static EventType getEventType(String eventType) {
    switch (eventType) {
      case 'Dota':
        return EventType.Dota;
      case 'CS':
        return EventType.CS;
      case 'RL':
        return EventType.RL;
      case 'Other':
        return EventType.Other;
      case _:
        return EventType.Unknown;
    }
  }
}

@freezed
sealed class Event with _$Event {
  const factory Event({
    required String name,
    required DateTime time,
    required EventType type,
    required List<int> gardeners,
    required num hours,
    Map<int, num>? deductions,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  const Event._();

  bool get hasDeductions {
    if (deductions != null) {
      return true;
    }
    return false;
  }
}
