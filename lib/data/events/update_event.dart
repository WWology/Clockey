import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'event.dart';
import 'event_errors.dart';

TaskEither<EditEventError, Event> addGardener(int eventId, int gardenerId) =>
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
      EditEventError.new,
    );

TaskEither<EditEventError, Event> removeGardener(
  int eventId,
  int gardenerId,
) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

        final event = await supabase
            .rpc('remove_gardener', params: {
              'event_id': eventId,
              'gardener_id': gardenerId,
            })
            .select()
            .limit(1)
            .single()
            .withConverter(Event.fromJson);
        return event;
      },
      EditEventError.new,
    );

TaskEither<EditEventError, Unit> editName(int eventId, String newName) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

        await supabase
            .from('events')
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
            .from('events')
            .update({'time': newTime.toString()}).match({'id': eventId});

        return unit;
      },
      EditEventError.new,
    );

TaskEither<EditEventError, Unit> editHours(int eventId, num newHours) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();
        await supabase
            .from('events')
            .update({'hours': newHours}).match({'id': eventId});

        return unit;
      },
      EditEventError.new,
    );

TaskEither<EditEventError, Event> addDeduction(
  int eventId,
  int gardenerId,
  num hoursToDeduct,
) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();
        final event = await supabase
            .rpc<Map<String, dynamic>>('add_deduction', params: {
              'event_id': eventId,
              'gardener_id': gardenerId,
              'hours_to_deduct': hoursToDeduct,
            })
            .select()
            .limit(1)
            .single()
            .withConverter(Event.fromJson);
        return event;
      },
      EditEventError.new,
    );
