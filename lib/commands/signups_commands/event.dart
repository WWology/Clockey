import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../data/events/events.dart';

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
      String eventType, [
      @Description('Ping Gardeners or not')
      @Name('ping')
      bool shouldPing = true,
    ]) async {
      String replyMessage = 'Hey <@&720253636797530203>\n\nI need up to ';
      late final String name;
      final num numberOfGardeners, hours;
      late final Snowflake? eventChannelId;
      late final ScheduledEntityType scheduledEntityType;

      await context.interaction.respondModal(_eventModal(eventType));
      final modalContext = await context.awaitModal('eventModal',
          timeout: Duration(seconds: 120));
      switch (EventType.getEventType(eventType)) {
        case EventType.Dota:
          name = 'Dota - ${modalContext['eventName']!}';
          numberOfGardeners = 1;
          hours = _getHours(modalContext['eventSeriesLength']!);
          eventChannelId = Snowflake(738009797932351519);
          scheduledEntityType = ScheduledEntityType.voice;
          break;
        case EventType.CS:
          name = 'CS - ${modalContext['eventName']!}';
          numberOfGardeners = 1;
          hours = _getHours(modalContext['eventSeriesLength']!);
          eventChannelId = Snowflake(746618267434614804);
          scheduledEntityType = ScheduledEntityType.voice;
          break;
        case EventType.RL:
          name = 'Rocket League - ${modalContext['eventName']!}';
          numberOfGardeners = 1;
          hours = _getRlHours(modalContext['eventSeriesLength']!);
          eventChannelId = Snowflake(1194677990290894989);
          scheduledEntityType = ScheduledEntityType.voice;
          break;
        case EventType.Other:
          name = modalContext['eventName']!;
          numberOfGardeners = int.parse(modalContext['numberOfGardeners']!);
          hours = num.parse(modalContext['hours']!);
          eventChannelId = Snowflake(1186593338300842025);
          scheduledEntityType = ScheduledEntityType.stageInstance;
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
          allowedMentions: shouldPing
              ? AllowedMentions(parse: ['roles', 'users'])
              : AllowedMentions(parse: []),
        ),
      );
      Future.wait(
        [
          message.react(
            ReactionBuilder(
              name: 'OGpeepoYes',
              id: Snowflake(730890894814740541),
            ),
          ),
          context.guild!.scheduledEvents.create(
            ScheduledEventBuilder(
              channelId: eventChannelId,
              name: name,
              privacyLevel: PrivacyLevel.guildOnly,
              scheduledStartTime: DateTime.fromMillisecondsSinceEpoch(
                int.parse(modalContext['eventTime']!) * 1000,
              ).toUtc(),
              scheduledEndTime: null,
              type: scheduledEntityType,
            ),
          ),
        ],
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
      return 6;
    default:
      return 0;
  }
}

num _getRlHours(String eventSeriesLength) {
  switch (eventSeriesLength) {
    case "Bo3":
      return 0.5;
    case "Bo5":
    case "Bo7":
      return 1;
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
