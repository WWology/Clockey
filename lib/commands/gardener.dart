import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

import '../data/events/events.dart';

final gardener = MessageCommand(
  'Roll Gardener',
  id('Gardener', (MessageContext context) async {
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
    String replyMessage = 'The people selected are: ';
    final clockeyId = context.interaction.applicationId;
    final gooseyId = 825467569800347649;

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

    // Remove the bots id from the potential gardener list
    if (ids.contains(clockeyId.value)) {
      ids.removeAt(ids.indexOf(clockeyId.value));
    }

    if (ids.contains(gooseyId)) {
      ids.removeAt(ids.indexOf(gooseyId));
    }

    ids.shuffle();
    final gardenersWorking = ids.take(numberOfGardeners).toList();

    _parseEvent(message, context).match(
      (error) {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        context.respond(
          MessageBuilder(content: 'Unable to parse event, please try again'),
          level: ResponseLevel.hint,
        );
      },
      (parsedEvent) async {
        final (eventName, eventTime, eventType, hours) = parsedEvent;
        final event = Event(
          name: eventName,
          time: eventTime,
          type: eventType,
          gardeners: gardenersWorking,
          hours: hours,
        );

        for (final id in gardenersWorking) {
          replyMessage += '<@$id> ';
        }

        createEvent(event).match(
          (error) async {
            GetIt.I.get<logger.Logger>().e(error.message, error: error);
            modalContext.respond(
              MessageBuilder(
                content: 'Something wrong has happened, please try again',
              ),
              level: ResponseLevel.hint,
            );
          },
          (_) async {
            final url = await message.url;
            Future.wait([
              modalContext.respond(
                MessageBuilder(content: '$replyMessage - $url'),
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

class ParsingEventError {
  final Object error;
  final StackTrace stackTrace;
  const ParsingEventError(this.error, this.stackTrace);

  String get message {
    final message = '$error\n StackTrace:\n $stackTrace';
    return message;
  }
}

typedef EventDetails = (
  String,
  DateTime,
  EventType,
  num,
);

Either<ParsingEventError, EventDetails> _parseEvent(
  Message message,
  MessageContext context,
) =>
    Either.tryCatch(
      () {
        final EventType eventType;

        if (message.content.contains('Dota')) {
          eventType = EventType.Dota;
        } else if (message.content.contains('CS')) {
          eventType = EventType.CS;
        } else if (message.content.contains('RL')) {
          eventType = EventType.RL;
        } else if (message.content.contains('Other')) {
          eventType = EventType.Other;
        } else {
          throw FormatException('UnknownEventType');
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

        final eventTime =
            DateTime.fromMillisecondsSinceEpoch(eventUnixTime).toUtc();

        final hours = num.parse(
          message.content
              .substring(message.content.indexOf("add") + 4)
              .split(' ')[0],
        );

        return (
          eventName,
          eventTime,
          eventType,
          hours,
        );
      },
      ParsingEventError.new,
    );
