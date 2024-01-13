import 'package:fpdart/fpdart.dart';
import 'package:supabase/supabase.dart';

import '../../env.dart';
import 'event.dart';
import 'event_errors.dart';

TaskEither<AddGardenerEventError, Event> addGardener(
        int eventId, int gardenerId) =>
    TaskEither.tryCatch(
      () async {
        final supabase = SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey);

        final event = await supabase
            .rpc('add_gardener', params: {
              'event_id': eventId,
              'gardener_id': gardenerId,
            })
            .select()
            .limit(1)
            .single()
            .withConverter(Event.fromJson);
        return event;
      },
      AddGardenerEventError.new,
    );

TaskEither<RemoveGardenerEventError, Event> removeGardener(
  int eventId,
  int gardenerId,
) =>
    TaskEither.tryCatch(
      () async {
        final supabase = SupabaseClient(Env.supabaseUrl, Env.supabaseUrl);

        final event = await supabase
            .rpc('add_gardener', params: {
              'event_id': eventId,
              'gardener_id': gardenerId,
            })
            .select()
            .limit(1)
            .single()
            .withConverter(Event.fromJson);
        return event;
      },
      RemoveGardenerEventError.new,
    );
