import 'package:nyxx_commands/nyxx_commands.dart';

ChatGroup showGroup = ChatGroup(
  'show',
  'Command to show scoreboard',
  children: [showDota, showCS, showRL],
);

final showDota = ChatCommand(
  'dota',
  'Show Dota 2 Scoreboard',
  id('dota', (InteractionChatContext context) async {}),
);

final showCS = ChatCommand(
  'cs',
  'Show CS2 Scoreboard',
  id('cs', (InteractionChatContext context) async {}),
);

final showRL = ChatCommand(
  'rl',
  'Show Rocket League Scoreboard',
  id('rl', (InteractionChatContext context) async {}),
);
