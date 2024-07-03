import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

ChatGroup nextGameGroup = ChatGroup(
  'next',
  'Command for next available games for OG',
  children: [nextDota, nextCS, nextRL],
);

final nextDota = ChatCommand(
  'dota',
  'Next Dota 2 game for OG',
  id(
    'dota',
    (InteractionChatContext context) async {
      try {
        final eventList = List.of(await context.guild!.scheduledEvents.list());

        eventList.sort(
            (a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));

        final event = eventList.firstWhere(
          (event) => event.name.contains("Dota"),
          orElse: () => throw StateError("No Dota event"),
        );

        await context.respond(MessageBuilder(
            content:
                'https://discord.com/events/689865753662455829/${event.id}'));
      } catch (error) {
        await context.respond(MessageBuilder(
          content: "No dota games planned currently",
        ));
      }
    },
  ),
);

final nextCS = ChatCommand(
  'cs',
  'Next CS2 game for OG',
  id(
    'cs',
    (InteractionChatContext context) async {
      try {
        final eventList = List.of(await context.guild!.scheduledEvents.list());

        eventList.sort(
            (a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));

        final event = eventList.firstWhere(
          (event) => event.name.contains("CS"),
          orElse: () => throw StateError("No CS event"),
        );

        await context.respond(MessageBuilder(
            content:
                'https://discord.com/events/689865753662455829/${event.id}'));
      } catch (error) {
        await context.respond(MessageBuilder(
          content: "No CS games planned currently",
        ));
      }
    },
  ),
);

final nextRL = ChatCommand(
  'rl',
  'Next RL Game for OG',
  id(
    'rl',
    (InteractionChatContext context) async {
      try {
        final eventList = List.of(await context.guild!.scheduledEvents.list());

        eventList.sort(
            (a, b) => a.scheduledStartTime.compareTo(b.scheduledStartTime));

        final event = eventList.firstWhere(
          (event) => event.name.contains("RL"),
          orElse: () => throw StateError("No RL event"),
        );

        await context.respond(MessageBuilder(
            content:
                'https://discord.com/events/689865753662455829/${event.id}'));
      } catch (error) {
        await context.respond(MessageBuilder(
          content: "No RL games planned currently",
        ));
      }
    },
  ),
);
