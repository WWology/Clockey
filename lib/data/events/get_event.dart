import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'event_errors.dart';

/// Get an [id] from an [event] with [eventName] & [eventTime]
TaskEither<EventError, int> getEventId(
  String eventName,
  DateTime eventTime,
) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

        final event = await supabase
            .from('clockey')
            .select()
            .match({
              'name': eventName,
              'time': eventTime,
            })
            .limit(1)
            .single();

        final id = event['id'] as int;

        return id;
      },
      GetEventIdError.new,
    );
