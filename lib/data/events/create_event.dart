import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'event.dart';
import 'event_errors.dart';

/// Create an [event]
///
/// Returns an [CreateEventError] if error occurs
TaskEither<EventError, Unit> createEvent(Event event) => TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();
        await supabase.from('clockey').insert(event);

        return unit;
      },
      CreateEventError.new,
    );
