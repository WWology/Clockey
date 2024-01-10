import 'package:clockey/env.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase/supabase.dart';

import 'event_errors.dart';

/// Delete an [event] with the corresponding [id]
TaskEither<EventError, Unit> deleteEvent(int id) => TaskEither.tryCatch(
      () async {
        final supabase = SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey);

        await supabase.from('clockey').delete().match({'id': id});
        return unit;
      },
      DeleteEventError.new,
    );
