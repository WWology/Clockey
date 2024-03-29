import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../data/scoreboard/add_score.dart';

final dotaAdd = ChatCommand(
  'dotaadd',
  'Add 1 point to the Dota Scoreboard',
  id(
    'dotaadd',
    (InteractionChatContext context, Role role) async {
      context.acknowledge();
      final memberManager = context.guild!.members;
      final memberList = await memberManager.list();

      final List<int> winnerList = [];

      for (final member in memberList) {
        if (member.roleIds.contains(role.id)) {
          winnerList.add(member.id.value);
        }
      }

      if (winnerList.isEmpty) {
        context.respond(
          MessageBuilder(
            content: 'No one was found in that role',
          ),
        );
        return;
      }

      addScore(winnerList, 'Dota').match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          context.respond(
            MessageBuilder(
              content: 'Error while adding the score, please try again',
            ),
          );
        },
        (_) {
          context.respond(
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
      context.acknowledge();
      final memberManager = context.guild!.members;
      final memberList = await memberManager.list();

      final List<int> winnerList = [];

      for (final member in memberList) {
        if (member.roleIds.contains(role.id)) {
          winnerList.add(member.id.value);
        }
      }

      if (winnerList.isEmpty) {
        context.respond(
          MessageBuilder(
            content: 'No one was found in that role',
          ),
        );
        return;
      }

      addScore(winnerList, 'CS').match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          context.respond(
            MessageBuilder(
              content: 'Error while adding the score, please try again',
            ),
          );
        },
        (_) {
          context.respond(
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
      context.acknowledge();
      final memberManager = context.guild!.members;
      final memberList = await memberManager.list();

      final List<int> winnerList = [];

      for (final member in memberList) {
        if (member.roleIds.contains(role.id)) {
          winnerList.add(member.id.value);
        }
      }

      if (winnerList.isEmpty) {
        context.respond(
          MessageBuilder(
            content: 'No one was found in that role',
          ),
        );
        return;
      }

      addScore(winnerList, 'RL').match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          context.respond(
            MessageBuilder(
              content: 'Error while adding the score, please try again',
            ),
          );
        },
        (_) {
          context.respond(
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
