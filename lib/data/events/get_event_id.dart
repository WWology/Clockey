import 'package:fpdart/fpdart.dart';
import 'package:supabase/supabase.dart';

import '../../env.dart';
import 'event_errors.dart';

TaskEither<EventError, int> getEventId(
  String eventName,
  DateTime eventTime,
) =>
    TaskEither.tryCatch(
      () async {
        final supabase = SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey);

        final event = await supabase
            .from('clockey')
            .select('id')
            .eq('eventName', eventName)
            .eq('eventTime', eventTime)
            .limit(1)
            .single();

        final id = event['id'] as int;

        return id;
      },
      GetEventIdError.new,
    );
