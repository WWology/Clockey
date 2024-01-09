import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final ping = ChatCommand(
  'ping',
  "Ping the bot to know it's status",
  id(
    'ping',
    (InteractionChatContext context) => context.respond(
      MessageBuilder(content: "Pong! I'm awake ⏰"),
    ),
  ),
);
