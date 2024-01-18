import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'event.dart';
import 'event_errors.dart';

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
              .order('time', ascending: false)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'CS')
              .filter('gardeners', 'cs', {'$gardenerID'})
              .order('time', ascending: false)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'RL')
              .filter('gardeners', 'cs', {'$gardenerID'})
              .order('time', ascending: false)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .from('clockey')
              .select()
              .gte('time', start)
              .lte('time', end)
              .eq('type', 'Other')
              .filter('gardeners', 'cs', {'$gardenerID'})
              .order('time', ascending: false)
              .withConverter((events) => events.map(Event.fromJson).toList()),
          supabase
              .rpc<List<Map<String, dynamic>>>('get_deductions', params: {
                'start_date': start.toString(),
                'end_date': end.toString(),
                'gardener_id': '$gardenerID'
              })
              .order('time', ascending: false)
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
