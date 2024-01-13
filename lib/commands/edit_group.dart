import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../data/events/update_event.dart';

final editGroup = ChatGroup(
  'edit',
  'Group of Command used to edit events',
  children: [
    editNameCommand,
    editTimeCommand,
    editHoursCommand,
  ],
);

final editNameCommand = ChatCommand(
  'event_name',
  'Use this to edit the name of the event',
  id('event_name', (
    InteractionChatContext context,
    @Description('ID of the event to be edited') @Name('event_id') int eventId,
    @Description('The new name of the event') @Name('new_name') String newName,
  ) async {
    context.acknowledge(level: ResponseLevel.hint);
    editName(eventId, newName).match(
      (error) {
        print(error.toString());
        context.respond(
          MessageBuilder(
            content: 'Unable to edit the name of this event, please try again',
          ),
          level: ResponseLevel.hint,
        );
      },
      (_) => context.respond(
        MessageBuilder(
          content: 'Successfully changed event $eventId name to $newName',
        ),
        level: ResponseLevel.hint,
      ),
    ).run();
  }),
);

final editTimeCommand = ChatCommand(
  'event_time',
  'Use this to edit the time of the event',
  id('event_time', (
    InteractionChatContext context,
    @Description('ID of the event to be edited') @Name('event_id') int eventId,
    @Description('The new time of this event')
    @Name('new_time')
    String newTimeString,
  ) async {
    context.acknowledge(level: ResponseLevel.hint);

    if (DateTime.tryParse(newTimeString) == null) {
      await context.respond(
        MessageBuilder(
          content: 'Start date format is invalid, please use YYYY-MM-DD',
        ),
      );
    }
    final newTime = DateTime.parse(newTimeString);
    editTime(eventId, newTime).match(
      (error) {
        print(error.toString());
        context.respond(
            MessageBuilder(
              content:
                  'Unable to edit the time of this event, please try again',
            ),
            level: ResponseLevel.hint);
      },
      (_) => context.respond(
        MessageBuilder(
          content:
              'Successfully changed event $eventId time to ${newTime.millisecondsSinceEpoch ~/ 1000}',
        ),
        level: ResponseLevel.hint,
      ),
    ).run();
  }),
);

final editHoursCommand = ChatCommand(
  'event_hours',
  'Use this to edit the amount of hours of the event',
  id('event_hours', (
    InteractionChatContext context,
    @Description('ID of the event to be edited') @Name('event_id') int eventId,
    @Description('The new time of this event') @Name('new_time') int newHours,
  ) async {
    context.acknowledge(level: ResponseLevel.hint);

    editHours(eventId, newHours).match(
      (error) {
        print(error.toString());
        context.respond(
            MessageBuilder(
              content:
                  'Unable to edit the amount of hours of this event, please try again',
            ),
            level: ResponseLevel.hint);
      },
      (_) => context.respond(
        MessageBuilder(
          content: 'Successfully changed event $eventId hours to $newHours',
        ),
        level: ResponseLevel.hint,
      ),
    ).run();
  }),
);
