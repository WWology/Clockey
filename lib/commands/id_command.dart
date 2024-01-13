import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../data/events/events.dart';

final idCommand = MessageCommand(
  'Get event ID',
  (MessageContext context) async {
    context.acknowledge();
    final message = context.targetMessage;

    final weCooEmoji = ReactionBuilder(
      name: 'OGwecoo',
      id: Snowflake(787697278190223370),
    );
    final weCooReactions =
        await message.manager.fetchReactions(message.id, weCooEmoji);

    if (weCooReactions.isEmpty) {
      await context.respond(
        MessageBuilder(
          content:
              'This event has not been processed yet so it does not have an id',
        ),
        level: ResponseLevel.hint,
      );
    }

    final String eventName = message.content.substring(
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

    getEventId(eventName, eventTime).match(
      (error) {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        context.respond(
          MessageBuilder(
            content: 'Something has gone wrong, please try again',
          ),
        );
      },
      (id) => context.respond(
        MessageBuilder(
          content:
              'The ID for the event $eventName at <t:${eventUnixTime ~/ 1000} is: $id',
        ),
      ),
    ).run();
  },
);
