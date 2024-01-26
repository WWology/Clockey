import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'event.dart';
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

typedef InvoiceData = Map<String, List<Event>>;

/// Get all events worked by a [gardener] between [startDate] & [endDate]
TaskEither<EventError, InvoiceData> getEvents({
  required int gardenerID,
  required DateTime start,
  required DateTime end,
}) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();
        final InvoiceData invoiceData = {};

        final (
          dotaEventsWorked,
          csEventsWorked,
          rlEventsWorked,
          otherEventsWorked,
          deductions
        ) = await (
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'Dota')
              .filter('gardeners', 'cs', {'$gardenerID'})
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'CS')
              .filter('gardeners', 'cs', {'$gardenerID'})
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'RL')
              .filter('gardeners', 'cs', {'$gardenerID'})
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'Other')
              .filter('gardeners', 'cs', {'$gardenerID'})
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .rpc<List<Map<String, dynamic>>>('get_deductions', params: {
                'start_date': start.toString(),
                'end_date': end.toString(),
                'gardener_id': '$gardenerID'
              })
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
        ).wait;

        invoiceData.addAll({
          'Dota': dotaEventsWorked,
          'CS': csEventsWorked,
          'RL': rlEventsWorked,
          'Other': otherEventsWorked,
          'Deductions': deductions,
        });

        return invoiceData;
      },
      GetEventsError.new,
    );

typedef ReportData = Map<String, List<Event>>;

/// Get all events in between [start] and [end] date
TaskEither<EventError, ReportData> getReport({
  required DateTime start,
  required DateTime end,
}) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();
        final ReportData reportData = {};

        final (dotaEvents, csEvents, rlEvents, otherEvents, deductions) =
            await (
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'Dota')
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'CS')
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'RL')
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'Other')
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .rpc<List<Map<String, dynamic>>>('get_report', params: {
                'start_date': start.toString(),
                'end_date': end.toString(),
              })
              .order('time', ascending: true)
              .withConverter((events) => events.map(Event.fromJson).toList()),
        ).wait;

        reportData.addAll({
          'Dota': dotaEvents,
          'CS': csEvents,
          'RL': rlEvents,
          'Other': otherEvents,
          'Deductions': deductions,
        });

        return reportData;
      },
      GetEventsError.new,
    );
