import 'package:hive/hive.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final clearCache = ChatCommand(
  'clear_cache',
  'Clear the cache for prediction roles',
  id(
    'clear_cache',
    (InteractionChatContext context) async {
      await context.acknowledge();
      var dotaBox = Hive.box<int>('dotaBox');
      var csBox = Hive.box<int>('csBox');
      var rlBox = Hive.box<int>('rlBox');
      await (dotaBox.clear(), csBox.clear(), rlBox.clear()).wait;
      await context.respond(
        MessageBuilder(
          content: 'Cleared the cache for all prediction roles',
        ),
      );
    },
  ),
);
