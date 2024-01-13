import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'event.dart';
import 'event_errors.dart';

TaskEither<AddGardenerEventError, Event> addGardener(
        int eventId, int gardenerId) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

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
        final supabase = GetIt.I.get<SupabaseClient>();

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

TaskEither<EditEventError, Unit> editName(int eventId, String newName) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

        await supabase
            .from('clockey')
            .update({'name': newName}).match({'id': eventId});

        return unit;
      },
      EditEventError.new,
    );

TaskEither<EditEventError, Unit> editTime(int eventId, DateTime newTime) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

        await supabase
            .from('clockey')
            .update({'time': newTime}).match({'id': eventId});

        return unit;
      },
      EditEventError.new,
    );

TaskEither<EditEventError, Unit> editHours(int eventId, int newHours) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();
        await supabase
            .from('clockey')
            .update({'hours': newHours}).match({'id': eventId});

        return unit;
      },
      EditEventError.new,
    );
