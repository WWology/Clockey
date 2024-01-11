import 'package:fpdart/fpdart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../data/events/events.dart';

final gardener = MessageCommand(
  'Gardener',
  id('Gardener', (MessageContext context) async {
    String replyMessage = 'The people selected are: ';

    final botID = context.interaction.applicationId;
    final message = context.targetMessage;
    final weCooEmoji = ReactionBuilder(
      name: 'OGwecoo',
      id: Snowflake(787697278190223370),
    );

    // Check if message has already been processed
    final weCooReactions =
        await message.manager.fetchReactions(message.id, weCooEmoji);

    if (weCooReactions.isNotEmpty) {
      context.respond(
        MessageBuilder(
          content: 'This message has already been processed for signups',
        ),
        level: ResponseLevel.hint,
      );
      return;
    }

    await context.interaction.respondModal(_gardenerModal());
    final modalContext = await context.awaitModal('gardenerModal',
        timeout: Duration(seconds: 30));

    final numberOfGardeners =
        int.parse(modalContext['numberOfGardenersInput']!);

    final gardenerReacted = await message.manager.fetchReactions(
      message.id,
      ReactionBuilder(
        name: 'OGpeepoYes',
        id: Snowflake(730890894814740541),
      ),
    );
    final ids = gardenerReacted.map((gardener) => gardener.id.value).toList();

    // Remove the bot id from the potential gardener list
    ids.removeAt(ids.indexOf(botID.value));
    ids.shuffle();
    final gardenersWorking = ids.take(numberOfGardeners).toList();

    _parseEvent(message, context).match(
      (error) => context.respond(
        MessageBuilder(
            content: 'Something wrong has happened, please try again'),
      ),
      (parsedEvent) async {
        final (eventName, eventTime, eventType, hours) = parsedEvent;
        final event = Event(
          eventName: eventName,
          eventTime: eventTime,
          eventType: eventType,
          gardeners: gardenersWorking,
          hours: hours,
        );

        for (final id in gardenersWorking) {
          replyMessage += '<@$id> ';
        }

        createEvent(event).match(
          (eventError) => modalContext.respond(
            MessageBuilder(
              content: 'Something has gone wrong, please try again',
            ),
          ),
          (_) async {
            Future.wait([
              modalContext.respond(
                MessageBuilder(content: replyMessage),
              ),
              message.react(weCooEmoji)
            ]);
          },
        ).run();
      },
    );
  }),
);

ModalBuilder _gardenerModal() {
  final numberOfGardenersInput = TextInputBuilder(
    customId: 'numberOfGardenersInput',
    style: TextInputStyle.short,
    label: 'Number of Gardeners to work this event',
    isRequired: true,
  );

  final firstActionRow = ActionRowBuilder(components: [numberOfGardenersInput]);

  return ModalBuilder(
    customId: 'gardenerModal',
    title: 'Gardener Modal',
    components: [firstActionRow],
  );
}

class UnknownEventTypeError {
  const UnknownEventTypeError();
}

typedef EventDetails = (
  String,
  DateTime,
  EventType,
  int,
);

Either<UnknownEventTypeError, EventDetails> _parseEvent(
    Message message, MessageContext context) {
  final EventType eventType;

  if (message.content.contains('Dota')) {
    eventType = EventType.Dota;
  } else if (message.content.contains('CS')) {
    eventType = EventType.CS;
  } else if (message.content.contains('Rocket League')) {
    eventType = EventType.RL;
  } else if (message.content.contains('Other')) {
    eventType = EventType.Other;
  } else {
    context.respond(
        MessageBuilder(content: 'Something has gone wrong, please try again'));
    return Left(const UnknownEventTypeError());
  }

  final eventName = message.content.substring(
    message.content.indexOf("-") + 2,
    message.content.indexOf(","),
  );

  final eventUnixTime = int.parse(
        message.content.substring(
          message.content.indexOf('<t:') + 3,
          message.content.indexOf('<t:') + 13,
        ),
      ) *
      1000;

  final eventTime = DateTime.fromMillisecondsSinceEpoch(eventUnixTime).toUtc();

  final hours = int.parse(message.content[message.content.indexOf("add") + 4]);

  return Right((
    eventName,
    eventTime,
    eventType,
    hours,
  ));
}
