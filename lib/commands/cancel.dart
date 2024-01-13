import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

import '../data/events/delete_event.dart';
import '../data/events/events.dart';

final cancel = MessageCommand(
  'Cancel this event',
  options: CommandOptions(
    defaultResponseLevel: ResponseLevel(
      hideInteraction: true,
      isDm: false,
      mention: null,
      preserveComponentMessages: false,
    ),
  ),
  id(
    'Cancel',
    (MessageContext context) async {
      final message = context.targetMessage;
      final weCooEmoji = ReactionBuilder(
        name: 'OGwecoo',
        id: Snowflake(787697278190223370),
      );

      // Check if message has already been processed
      final weCooReactions =
          await message.manager.fetchReactions(message.id, weCooEmoji);

      if (weCooReactions.isEmpty) {
        await context.respond(
          MessageBuilder(content: "This event hasn't been rolled yet"),
        );
        return;
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

      final confirm = await context.getConfirmation(
        MessageBuilder(
            content: 'Are you sure you want to cancel signups for this event?'),
        authorOnly: true,
        styles: {
          true: ButtonStyle.danger,
          false: ButtonStyle.secondary,
        },
        timeout: Duration(seconds: 30),
      );

      if (confirm) {
        getEventId(eventName, eventTime).flatMap(deleteEvent).match(
          (error) {
            print(error.toString());
            context.respond(
              MessageBuilder(
                content: 'Something has gone wrong, please try again',
              ),
            );
          },
          (_) async {
            Future.wait([
              context.respond(
                MessageBuilder(
                  content:
                      'Successfully cancelled signup for $eventName at <t:${eventUnixTime ~/ 1000}:F> - ${message.url}',
                ),
              ),
              message.manager.deleteReaction(
                message.id,
                weCooEmoji,
              )
            ]);
          },
        ).run();
      } else {
        await context.respond(
          MessageBuilder(
            content: 'Action cancelled',
            components: [],
          ),
        );
      }
    },
  ),
);
