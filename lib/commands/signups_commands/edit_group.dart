import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../data/events/update_event.dart';

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
  options: CommandOptions(defaultResponseLevel: ResponseLevel.hint),
  id('event_name', (
    InteractionChatContext context,
    @Description('Message ID for the event')
    @Name('message_id')
    String messageId,
    @Description('ID of the event to be edited') @Name('event_id') int eventId,
    @Description('The new name of the event') @Name('new_name') String newName,
  ) async {
    await context.acknowledge();
    final message =
        await context.channel.messages.fetch(Snowflake.parse(messageId));

    final oldName = message.content.substring(
      message.content.indexOf("-") + 2,
      message.content.indexOf(","),
    );

    final newMessage = message.content.replaceAll(oldName, newName);

    editName(eventId, newName).match(
      (error) async {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        await context.respond(
          MessageBuilder(
            content: 'Unable to edit the name of this event, please try again',
          ),
        );
      },
      (_) {
        Future.wait([
          message.update(MessageUpdateBuilder(content: newMessage)),
          context.respond(
            MessageBuilder(
              content:
                  'Successfully changed event $eventId name from $oldName to $newName',
            ),
          ),
        ]);
      },
    ).run();
  }),
);

final editTimeCommand = ChatCommand(
  'event_time',
  'Use this to edit the time of the event',
  options: CommandOptions(defaultResponseLevel: ResponseLevel.hint),
  id('event_time', (
    InteractionChatContext context,
    @Description('Message ID for the event')
    @Name('message_id')
    String messageId,
    @Description('ID of the event to be edited') @Name('event_id') int eventId,
    @Description('The new time of this event')
    @Name('new_time')
    String newTimeStamp,
  ) async {
    await context.acknowledge();
    final message =
        await context.channel.messages.fetch(Snowflake.parse(messageId));

    final oldUnixTime = int.parse(
      message.content.substring(
        message.content.indexOf('<t:') + 3,
        message.content.indexOf('<t:') + 13,
      ),
    );

    final newUnixTime = int.parse(newTimeStamp);

    final newTime =
        DateTime.fromMillisecondsSinceEpoch(newUnixTime * 1000).toUtc();

    final newMessage =
        message.content.replaceAll('$oldUnixTime', '$newUnixTime');

    editTime(eventId, newTime).match(
      (error) async {
        GetIt.I.get<logger.Logger>().e(error.message);
        await context.respond(
          MessageBuilder(
            content: 'Unable to edit the time of this event, please try again',
          ),
        );
      },
      (_) async {
        Future.wait(
          [
            message.update(MessageUpdateBuilder(content: newMessage)),
            context.respond(
              MessageBuilder(
                content:
                    'Successfully changed event $eventId time from <t:$oldUnixTime:F> to <t:$newUnixTime:F>',
              ),
            ),
          ],
        );
      },
    ).run();
  }),
);

final editHoursCommand = ChatCommand(
  'event_hours',
  'Use this to edit the amount of hours of the event',
  options: CommandOptions(defaultResponseLevel: ResponseLevel.hint),
  id('event_hours', (
    InteractionChatContext context,
    @Description('Message ID for the event')
    @Name('message_id')
    String messageId,
    @Description('ID of the event to be edited') @Name('event_id') int eventId,
    @Description('The new time of this event') @Name('new_hours') num newHours,
  ) async {
    await context.acknowledge();
    final message =
        await context.channel.messages.fetch(Snowflake.parse(messageId));

    final oldHours = num.parse(
      message.content
          .substring(message.content.indexOf("add") + 4)
          .split(' ')[0],
    );

    final newMessage = message.content
        .replaceFirst('$oldHours', '$newHours', message.content.indexOf('add'));
    editHours(eventId, newHours).match(
      (error) async {
        GetIt.I.get<logger.Logger>().e(error.message);
        await context.respond(
          MessageBuilder(
            content:
                'Unable to edit the amount of hours of this event, please try again',
          ),
        );
      },
      (_) {
        Future.wait([
          message.update(MessageUpdateBuilder(content: newMessage)),
          context.respond(
            MessageBuilder(
              content:
                  'Successfully changed event $eventId amount of hours from $oldHours to $newHours',
            ),
          ),
        ]);
      },
    ).run();
  }),
);
