import 'package:nyxx_commands/nyxx_commands.dart';

final editGroup =
    ChatGroup('edit', 'Group of Command used to edit events', children: []);

final editName = ChatCommand(
  'event_name',
  'Use this to edit name of the event',
  id(
      'event_name',
      (
        InteractionChatContext context,
        @Description('Gardener to be added') @Name('gardener') int eventId,
      ) async {}),
);
