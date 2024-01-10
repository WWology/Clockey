import 'package:fpdart/fpdart.dart';
import 'package:supabase/supabase.dart';

import '../../env.dart';
import 'event.dart';
import 'event_errors.dart';

TaskEither<EventError, Unit> createEvent(Event event) => TaskEither.tryCatch(
      () async {
        final supabase = SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey);
        await supabase.from('clockey').insert(event);

        return unit;
      },
      CreateEventError.new,
    );
