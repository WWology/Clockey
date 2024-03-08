import 'package:nyxx_commands/nyxx_commands.dart';

final dotaAdd = ChatCommand(
  'dotaadd',
  'Add 1 point to the Dota scoreboard',
  id(
    'dotaadd',
    (InteractionChatContext context) async {
      context.acknowledge();
    },
  ),
);

final csAdd = ChatCommand(
  'csadd',
  'Add 1 point to the CS scoreboard',
  id(
    'csadd',
    (InteractionChatContext context) async {
      context.acknowledge();
    },
  ),
);

final rlAdd = ChatCommand(
  'rladd',
  'Add 1 point to the RL scoreboard',
  id(
    'rladd',
    (InteractionChatContext context) async {
      context.acknowledge();
    },
  ),
);
