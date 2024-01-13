import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../data/events/events.dart';

final event = ChatCommand(
  'event',
  'Create a new event for Gardeners to sign up',
  id(
    'event',
    (
      InteractionChatContext context,
      @Choices({
        'Dota': 'Dota',
        'CS': 'CS',
        'Rocket League': 'RL',
        'Other': 'Other',
      })
      @Description('The type of event')
      @Name('type')
      String eventType,
    ) async {
      String replyMessage = 'Hey <@&720253636797530203>\n\nI need up to ';
      final int numberOfGardeners, hours;

      await context.interaction.respondModal(_eventModal(eventType));
      final modalContext = await context.awaitModal('eventModal',
          timeout: Duration(seconds: 120));
      switch (EventType.getEventType(eventType)) {
        case EventType.Dota:
          numberOfGardeners = 4;
          hours = _getHours(modalContext['eventSeriesLength']!);
          break;
        case EventType.CS:
          numberOfGardeners = 2;
          hours = _getHours(modalContext['eventSeriesLength']!);
        case EventType.RL:
          numberOfGardeners = 0;
          hours = _getHours(modalContext['eventSeriesLength']!);
          break;
        case EventType.Other:
          numberOfGardeners = int.parse(modalContext['numberOfGardeners']!);
          hours = int.parse(modalContext['hours']!);
          break;
        case EventType.Unknown:
          await modalContext.respond(
            MessageBuilder(content: 'An error has occured, please try again'),
            level: ResponseLevel.hint,
          );
          return;
      }

      if (hours == 0) {
        await modalContext.respond(
          MessageBuilder(
              content:
                  'Wrong format for Series Length, Please use either Bo1 / Bo2 / Bo3 / Bo5'),
          level: ResponseLevel.hint,
        );
        return;
      }

      if (eventType != "Other") {
        replyMessage +=
            '$numberOfGardeners gardeners to work the $eventType game - ${modalContext['eventName']}, at <t:${modalContext['eventTime']}:F>'
            '\n\nPlease react below with a <:OGpeepoYes:730890894814740541> to sign up!'
            '\n\nAs this is a ${modalContext['eventSeriesLength']}, you will be able to add $hours hours of work to your invoice for the month';
      } else {
        replyMessage +=
            '$numberOfGardeners gardeners to work the $eventType event - ${modalContext['eventName']}, at <t:${modalContext['eventTime']}:F>'
            '\n\nPlease react below with a <:OGpeepoYes:730890894814740541> to sign up!'
            '\n\nYou will be able to add $hours hours of work to your invoice for the month';
      }

      final message = await context.respond(
        MessageBuilder(
          content: replyMessage,
          allowedMentions: AllowedMentions(
            parse: ['roles', 'users'],
          ),
        ),
      );

      message.react(
        ReactionBuilder(
          name: 'OGpeepoYes',
          id: Snowflake(730890894814740541),
        ),
      );
    },
  ),
);

int _getHours(String eventSeriesLength) {
  switch (eventSeriesLength) {
    case "Bo1":
      return 2;
    case "Bo2":
      return 3;
    case "Bo3":
      return 4;
    case "Bo5":
      return 4;
    default:
      return 0;
  }
}

ModalBuilder _eventModal(String eventType) {
  final List<ActionRowBuilder> components;

  final eventName = TextInputBuilder(
    customId: 'eventName',
    style: TextInputStyle.short,
    label: 'Event / Game name',
    isRequired: true,
    placeholder: 'OG vs <opp team name>',
  );

  final nameRow = ActionRowBuilder(components: [eventName]);

  final eventTime = TextInputBuilder(
    customId: 'eventTime',
    style: TextInputStyle.short,
    label: 'Event / Game time',
    isRequired: true,
    placeholder: 'Insert unix time here',
  );

  final timeRow = ActionRowBuilder(components: [eventTime]);

  final eventSeriesLength = TextInputBuilder(
    customId: 'eventSeriesLength',
    style: TextInputStyle.short,
    label: 'Game Series Length',
    isRequired: true,
    placeholder: 'Bo1 / Bo2 / Bo3 / Bo5',
  );

  final seriesRow = ActionRowBuilder(components: [eventSeriesLength]);

  final numberOfGardeners = TextInputBuilder(
    customId: 'numberOfGardeners',
    style: TextInputStyle.short,
    label: 'Number of Gardeners required',
    isRequired: true,
  );

  final gardenersRow = ActionRowBuilder(components: [numberOfGardeners]);

  final hours = TextInputBuilder(
    customId: 'hours',
    style: TextInputStyle.short,
    label: 'How many hours is this event',
    isRequired: true,
  );

  final hoursRow = ActionRowBuilder(components: [hours]);

  if (eventType == "Other") {
    components = [
      nameRow,
      timeRow,
      gardenersRow,
      hoursRow,
    ];
  } else {
    components = [
      nameRow,
      timeRow,
      seriesRow,
    ];
  }

  return ModalBuilder(
      customId: 'eventModal', title: 'Event Modal', components: components);
}
