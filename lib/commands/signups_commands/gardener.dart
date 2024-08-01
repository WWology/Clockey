import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

import '../../constants.dart';
import '../../data/events/events.dart';

//! Not used for now since gardeners will always be 1
// ModalBuilder _gardenerModal() {
//   final numberOfGardenersInput = TextInputBuilder(
//     customId: 'numberOfGardenersInput',
//     style: TextInputStyle.short,
//     label: 'Number of Gardeners to work this event',
//     isRequired: true,
//   );

//   final firstActionRow = ActionRowBuilder(components: [numberOfGardenersInput]);

//   return ModalBuilder(
//     customId: 'gardenerModal',
//     title: 'Gardener Modal',
//     components: [firstActionRow],
//   );
// }

final _weCooEmoji = ReactionBuilder(
  name: 'OGwecoo',
  id: Snowflake(787697278190223370),
);

SelectMenuBuilder _gardenerSelectMenu(
  List<int> ids,
  ComponentId gardenerSelectMenuId,
) {
  return SelectMenuBuilder(
    type: MessageComponentType.stringSelect,
    customId: gardenerSelectMenuId.toString(),
    minValues: 0,
    maxValues: 1,
    placeholder: 'Gardeners who reacted',
    options: _gardenerIdMap(ids),
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

List<SelectMenuOptionBuilder> _gardenerIdMap(List<int> ids) {
  List<SelectMenuOptionBuilder> gardenerMap = [];
  for (final id in ids) {
    switch (id) {
      case 293360731867316225:
        gardenerMap.add(SelectMenuOptionBuilder(label: 'Nik', value: 'Nik'));
        break;
      case 204923365205475329:
        gardenerMap.add(SelectMenuOptionBuilder(label: 'Kit', value: 'Kit'));
        break;
      case 754724309276164159:
        gardenerMap.add(SelectMenuOptionBuilder(label: 'WW', value: 'WW'));
        break;
      case 172360818715918337:
        gardenerMap
            .add(SelectMenuOptionBuilder(label: 'Bonteng', value: 'Bonteng'));
        break;
      case 332438787588227072:
        gardenerMap.add(SelectMenuOptionBuilder(label: 'Sam', value: 'Sam'));
        break;
    }
  }
  return gardenerMap;
}

final gardener = MessageCommand(
  'Roll Gardener',
  options: CommandOptions(defaultResponseLevel: ResponseLevel.hint),
  id('Gardener', (MessageContext context) async {
    final message = context.targetMessage;
    final user = context.user;

    // Check if message has already been processed
    final weCooReactions =
        await message.manager.fetchReactions(message.id, _weCooEmoji);

    if (weCooReactions.isNotEmpty) {
      await context.respond(
        MessageBuilder(
          content: 'This message has already been processed for signups',
        ),
        level: ResponseLevel.hint,
      );
      return;
    }

    String replyMessage = 'The people working ';
    final clockeyId = context.interaction.applicationId;
    final gooseyId = 825467569800347649;

    //! Not used for now since gardeners will always be 1
    // await context.interaction.respondModal(_gardenerModal());
    // final modalContext = await context.awaitModal('gardenerModal',
    //     timeout: Duration(seconds: 30));

    // final numberOfGardeners =
    //     int.parse(modalContext['numberOfGardenersInput']!);

    final gardenerReacted = await message.manager.fetchReactions(
      message.id,
      ReactionBuilder(
        name: 'OGpeepoYes',
        id: Snowflake(730890894814740541),
      ),
    );
    final ids = gardenerReacted
        .map((gardener) => gardener.id.value)
        .where((id) => id != clockeyId.value || id != gooseyId)
        .toList();

    // Generate select menu for Gardeners who reacted
    final gardenerSelectMenuId = ComponentId.generate(
      allowedUser: user.id,
      expirationTime: Duration(minutes: 2),
    );
    final gardenersSelectMenu = _gardenerSelectMenu(ids, gardenerSelectMenuId);
    final row = ActionRowBuilder(components: [gardenersSelectMenu]);

    await context.respond(
      MessageBuilder(
        content: 'Choose the Gardener to work this event',
        components: [row],
      ),
      level: ResponseLevel.hint,
    );

    // Get the selected Gardeners
    final gardeners =
        await context.awaitMultiSelection<String>(gardenerSelectMenuId);
    final gardenersWorking = gardeners.selected.map(mapGardenerToId).toList();

    // If there's no Gardener, then return an error and abort the command
    if (gardenersWorking.isEmpty) {
      await context.respond(
        MessageBuilder(content: 'An invalid choice has been made'),
        level: ResponseLevel.hint,
      );
      return;
    }

    _parseEvent(message, context).match(
      (error) async {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        await context.respond(
          MessageBuilder(
            content: 'Unable to parse event, please try again',
          ),
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

        replyMessage += '$eventName are: ';
        for (final id in gardenersWorking) {
          replyMessage += '<@$id> ';
        }

        createEvent(event).match(
          (error) async {
            GetIt.I.get<logger.Logger>().e(error.message, error: error);
            await context.respond(
              MessageBuilder(
                content: 'Something wrong has happened, please try again',
              ),
              level: ResponseLevel.hint,
            );
          },
          (_) async {
            final url = await message.url;
            Future.wait([
              context.respond(
                MessageBuilder(
                  content: '$replyMessage - $url',
                  allowedMentions: AllowedMentions(
                    parse: ['users'],
                  ),
                ),
                level: ResponseLevel.public,
              ),
              message.react(_weCooEmoji),
            ]);
          },
        ).run();
      },
    );
  }),
);
