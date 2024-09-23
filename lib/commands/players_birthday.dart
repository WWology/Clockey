import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final playerBirthday = ChatCommand(
  'player-birthday',
  "Register a player birthday in the Discord Events Tab",
  id(
    "player-birthday",
    (
      InteractionChatContext context,
      @Description(
        "Name of the player",
      )
      String name,
      @Description(
        "The date of the player's birthday, please use YYYY-MM-DD format",
      )
      String date,
      @Description(
        "Link for where fans can say Happy Birthday",
      )
      String link,
    ) async {
      await context.acknowledge();
      if (DateTime.tryParse(date) == null) {
        await context.respond(
          MessageBuilder(
            content: 'Start date format is invalid, please use YYYY-MM-DD',
          ),
        );
      }
      final start = DateTime.parse(date);
      final end = start.add(Duration(days: 1));

      final event = await context.guild!.scheduledEvents.create(
        ScheduledEventBuilder(
          type: ScheduledEntityType.external,
          channelId: null,
          name: "$name's birthday",
          metadata: EntityMetadata(location: link),
          privacyLevel: PrivacyLevel.guildOnly,
          scheduledStartTime: start,
          scheduledEndTime: end,
        ),
      );

      await context.respond(
        MessageBuilder(
          content:
              "$name's birthday event created in Discord Tab - https://discord.com/events/689865753662455829/${event.id}",
        ),
      );
    },
  ),
);
