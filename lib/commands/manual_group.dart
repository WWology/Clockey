import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../constants.dart';
import '../data/events/events.dart';

ChatGroup manualGroup = ChatGroup(
  'manual',
  'Command for manual Signups',
  children: [
    signUps,
    addGardenerCommand,
    removeGardenerCommand,
    addDeductionCommand,
  ],
);

final signUps = ChatCommand(
  'signup',
  'Manually add signups to an event',
  id(
    'signup',
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
      String type, [
      @Choices(gardenerMap)
      @Description('Gardener to work on the event')
      @Name('gardener1')
      String? gardener1,
      @Choices(gardenerMap)
      @Description('Gardener to work on the event')
      @Name('gardener2')
      String? gardener2,
      @Choices(gardenerMap)
      @Description('Gardener to work on the event')
      @Name('gardener3')
      String? gardener3,
      @Choices(gardenerMap)
      @Description('Gardener to work on the event')
      @Name('gardener4')
      String? gardener4,
    ]) async {
      final weCooEmoji = ReactionBuilder(
        name: 'OGwecoo',
        id: Snowflake(787697278190223370),
      );
      String replyMessage = "The people working on the ";

      final List<int> gardenerList = [
        if (gardener1 != null) mapGardenerToId(gardener1),
        if (gardener2 != null) mapGardenerToId(gardener2),
        if (gardener3 != null) mapGardenerToId(gardener3),
        if (gardener4 != null) mapGardenerToId(gardener4),
      ];

      await context.interaction.respondModal(_manualModal());
      final modalContext = await context.awaitModal(
        'manualModal',
        timeout: Duration(seconds: 60),
      );
      final eventName = modalContext['eventName']!;
      final eventType = EventType.getEventType(type);
      final eventTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(modalContext['eventTime']!) * 1000)
          .toUtc();
      final hours = int.parse(modalContext['hours']!);

      final event = Event(
        name: eventName,
        time: eventTime,
        type: eventType,
        gardeners: gardenerList,
        hours: hours,
      );

      if (eventType != EventType.Other) {
        replyMessage +=
            '$type game - $eventName, at <t:${modalContext['eventTime']}:F> are: ';
      } else {
        replyMessage +=
            '$type event - $eventName, at <t:${modalContext['eventTime']}:F> are: ';
      }

      for (final id in gardenerList) {
        replyMessage += '<@$id> ';
      }

      replyMessage +=
          '\n\nYou can add $hours hours of work to your invoice for the month';

      createEvent(event).match(
        (error) {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          modalContext.respond(
            MessageBuilder(
                content: 'Something has gone wrong, please try again'),
          );
        },
        (_) async {
          final message = await modalContext.respond(
            MessageBuilder(content: replyMessage),
          );

          message.react(weCooEmoji);
        },
      ).run();
    },
  ),
);

ModalBuilder _manualModal() {
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

  final hours = TextInputBuilder(
    customId: 'hours',
    style: TextInputStyle.short,
    label: 'How many hours is this event',
    isRequired: true,
  );

  final hoursRow = ActionRowBuilder(components: [hours]);

  components = [
    nameRow,
    timeRow,
    hoursRow,
  ];

  return ModalBuilder(
      customId: 'manualModal', title: 'Manual Modal', components: components);
}

final addGardenerCommand = ChatCommand(
  'add_gardener',
  'Add a gardener to an event',
  options: CommandOptions(
    defaultResponseLevel: ResponseLevel.hint,
  ),
  id(
    'add_gardener',
    (
      InteractionChatContext context,
      @Choices(gardenerMap)
      @Description('Gardener to be added')
      @Name('gardener')
      String gardener,
      int eventId,
    ) async {
      final gardenerId = mapGardenerToId(gardener);
      addGardener(eventId, gardenerId).match(
        (error) {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          context.respond(
            MessageBuilder(content: 'Unable to add gardener, please try again'),
          );
        },
        (event) => context.respond(
          MessageBuilder(
            content:
                'Added <@$gardenerId> to ${event.name} at <t:${event.time.millisecondsSinceEpoch ~/ 1000}:F>',
          ),
        ),
      ).run();
    },
  ),
);

final removeGardenerCommand = ChatCommand(
  'remove_gardener',
  'Remove a gardener from an event',
  options: CommandOptions(
    defaultResponseLevel: ResponseLevel.hint,
  ),
  id(
    'remove_gardener',
    (
      InteractionChatContext context,
      @Choices(gardenerMap)
      @Description('Gardener to be added')
      @Name('gardener')
      String gardener,
      int eventId,
    ) async {
      final gardenerId = mapGardenerToId(gardener);
      removeGardener(eventId, gardenerId).match(
        (error) {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          context.respond(
            MessageBuilder(
                content: 'Unable to remove gardener, please try again'),
          );
        },
        (event) => context.respond(
          MessageBuilder(
            content:
                'Removed <@$gardenerId> from ${event.name} at <t:${event.time.millisecondsSinceEpoch ~/ 1000}:F>',
          ),
        ),
      ).run();
    },
  ),
);

final addDeductionCommand = ChatCommand(
  'add_deduction',
  'Add a deduction for a gardener',
  options: CommandOptions(
    defaultResponseLevel: ResponseLevel.hint,
  ),
  id('add_deduction', (
    InteractionChatContext context,
    @Choices(gardenerMap)
    @Description('The gardener who will be deducted')
    @Name('gardener')
    String gardener,
    int eventId,
    int hours,
  ) async {
    final gardenerId = mapGardenerToId(gardener);
    addDeduction(eventId, gardenerId, hours).match(
      (error) {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        context.respond(
          MessageBuilder(
            content: 'Error while adding deduction, please try again',
          ),
        );
      },
      (event) => context.respond(
        MessageBuilder(
          content:
              'Added a $hours hour deduction to $gardener for ${event.name} at <t:${event.time.millisecondsSinceEpoch ~/ 1000}:F>',
        ),
      ),
    ).run();
  }),
);
