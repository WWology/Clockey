import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

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

    Future.wait([
      message.update(MessageUpdateBuilder(content: newMessage)),
      context.respond(
        MessageBuilder(
          content: 'Successfully changed event name from $oldName to $newName',
        ),
      ),
    ]);
  }),
);

final editTimeCommand = ChatCommand(
  'event_time',
  'Use this to edit the time of the event',
  options: CommandOptions(defaultResponseLevel: ResponseLevel.hint),
  id(
    'event_time',
    (
      InteractionChatContext context,
      @Description('Message ID for the event')
      @Name('message_id')
      String messageId,
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

      final newMessage =
          message.content.replaceAll('$oldUnixTime', '$newUnixTime');

      Future.wait(
        [
          message.update(MessageUpdateBuilder(content: newMessage)),
          context.respond(
            MessageBuilder(
              content:
                  'Successfully changed event time from <t:$oldUnixTime:F> to <t:$newUnixTime:F>',
            ),
          ),
        ],
      );
    },
  ),
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
    @Description('The new duration of this event')
    @Name('new_hours')
    int newHours,
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

    Future.wait([
      message.update(MessageUpdateBuilder(content: newMessage)),
      context.respond(
        MessageBuilder(
          content:
              'Successfully changed event amount of hours from $oldHours to $newHours',
        ),
      ),
    ]);
  }),
);
