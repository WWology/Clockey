import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

String _getHours(String eventSeriesLength) {
  switch (eventSeriesLength.toLowerCase()) {
    case "bo1":
      return "2";
    case "bo2":
      return "3";
    case "bo3":
      return "4";
    case "bo5":
      return "6";
    default:
      return "";
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
      //
      [
      @Description('Ping Gardeners or not')
      @Name('ping')
      bool shouldPing = true,
    ]) async {
      String replyMessage = 'Hey <@&720253636797530203>\n\nI need ';

      late final String name, hours;
      late final Snowflake eventChannelId;
      late final ScheduledEntityType scheduledEntityType;

      await context.interaction.respondModal(_eventModal(eventType));
      final modalContext = await context.awaitModal('eventModal',
          timeout: Duration(seconds: 120));

      switch (eventType) {
        case "Dota":
          name = 'Dota - ${modalContext['eventName']!}';
          hours = _getHours(modalContext['eventSeriesLength']!);
          eventChannelId = Snowflake(738009797932351519);
          scheduledEntityType = ScheduledEntityType.voice;
          break;
        case "CS":
          name = 'CS - ${modalContext['eventName']!}';
          hours = _getHours(modalContext['eventSeriesLength']!);
          eventChannelId = Snowflake(746618267434614804);
          scheduledEntityType = ScheduledEntityType.voice;
          break;
        case "RL":
          name = 'RL - ${modalContext['eventName']!}';
          hours = "1";
          eventChannelId = Snowflake(1194677990290894989);
          scheduledEntityType = ScheduledEntityType.voice;
          break;
        case "Other":
          name = modalContext['eventName']!;
          hours = modalContext['hours']!;
          eventChannelId = Snowflake(1186593338300842025);
          scheduledEntityType = ScheduledEntityType.stageInstance;
          break;
      }

      if (hours == "") {
        await modalContext.respond(
          MessageBuilder(
              content:
                  'Wrong format for Series Length, Please use either Bo1 / Bo2 / Bo3 / Bo5 / Bo7'),
        );
        return;
      }

      if (eventType != "Other") {
        replyMessage +=
            '1 gardener to work the $eventType game - ${modalContext['eventName']}, at <t:${modalContext['eventTime']}:F>'
            '\n\nPlease react below with a <:OGpeepoYes:730890894814740541> to sign up!'
            '\n\nAs this is a ${modalContext['eventSeriesLength']}, you will be able to add $hours hours of work to your invoice for the month';
      } else {
        replyMessage +=
            '1 gardener to work the Other event - ${modalContext['eventName']}, at <t:${modalContext['eventTime']}:F>'
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

      await message.react(
        ReactionBuilder(
          name: 'OGpeepoYes',
          id: Snowflake(730890894814740541),
        ),
      );
      await context.guild!.scheduledEvents.create(
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
      );
    },
  ),
);
