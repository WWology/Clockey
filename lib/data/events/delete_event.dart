import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'event_errors.dart';

/// Delete an [event] with the corresponding [id]
TaskEither<EventError, Unit> deleteEvent(int id) => TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

        await supabase.from('events').delete().match({'id': id});
        return unit;
      },
      DeleteEventError.new,
    );
