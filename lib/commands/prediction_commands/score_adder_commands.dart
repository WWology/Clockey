import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

import '../../data/scoreboard/add_score.dart';

final dotaAdd = ChatCommand(
  'dotaadd',
  'Add 1 point to the Dota Scoreboard',
  id(
    'dotaadd',
    (InteractionChatContext context, Role role) async {
      await context.acknowledge();
      final memberManager = context.guild!.members;
      final members = memberManager.stream(pageSize: 1000);

      final List<int> winnerList = [];

      await for (final member in members) {
        if (member.roleIds.contains(role.id)) {
          winnerList.add(member.id.value);
        }
      }

      if (winnerList.isEmpty) {
        await context.respond(
          MessageBuilder(
            content: 'No one was found in that role',
          ),
        );
        return;
      }

      addScore(winnerList, 'Dota').match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          await context.respond(
            MessageBuilder(
              content: 'Error while adding the score, please try again',
            ),
          );
        },
        (_) async {
          await context.respond(
            MessageBuilder(
              content:
                  'I have added the score for ${winnerList.length} users to the Dota scoreboard',
            ),
          );
        },
      ).run();
    },
  ),
);
final csAdd = ChatCommand(
  'csadd',
  'Add 1 point to the CS Scoreboard',
  id(
    'csadd',
    (InteractionChatContext context, Role role) async {
      await context.acknowledge();
      final memberManager = context.guild!.members;
      final members = memberManager.stream(pageSize: 1000);

      final List<int> winnerList = [];

      await for (final member in members) {
        if (member.roleIds.contains(role.id)) {
          winnerList.add(member.id.value);
        }
      }

      if (winnerList.isEmpty) {
        await context.respond(
          MessageBuilder(
            content: 'No one was found in that role',
          ),
        );
        return;
      }

      addScore(winnerList, 'CS').match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          await context.respond(
            MessageBuilder(
              content: 'Error while adding the score, please try again',
            ),
          );
        },
        (_) async {
          await context.respond(
            MessageBuilder(
              content:
                  'I have added the score for ${winnerList.length} users to the CS scoreboard',
            ),
          );
        },
      ).run();
    },
  ),
);

final rlAdd = ChatCommand(
  'rladd',
  'Add 1 point to the RL Scoreboard',
  id(
    'rladd',
    (InteractionChatContext context, Role role) async {
      await context.acknowledge();
      final memberManager = context.guild!.members;
      final members = memberManager.stream(pageSize: 1000);

      final List<int> winnerList = [];

      await for (final member in members) {
        if (member.roleIds.contains(role.id)) {
          winnerList.add(member.id.value);
        }
      }

      if (winnerList.isEmpty) {
        await context.respond(
          MessageBuilder(
            content: 'No one was found in that role',
          ),
        );
        return;
      }

      addScore(winnerList, 'RL').match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          await context.respond(
            MessageBuilder(
              content: 'Error while adding the score, please try again',
            ),
          );
        },
        (_) async {
          await context.respond(
            MessageBuilder(
              content:
                  'I have added the score for ${winnerList.length} users to the RL scoreboard',
            ),
          );
        },
      ).run();
    },
  ),
);
