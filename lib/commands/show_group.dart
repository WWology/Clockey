import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:tabular/tabular.dart';

import '../data/scoreboard/scoreboard.dart';

ChatGroup showGroup = ChatGroup(
  'show',
  'Command to show scoreboard',
  children: [showDota, showCS, showRL],
);

final showDota = ChatCommand(
  'dota',
  'Show Dota 2 Scoreboard',
  id('dota', (InteractionChatContext context) async {
    await context.acknowledge(
      level: ResponseLevel(
        hideInteraction: false,
        isDm: false,
        mention: false,
        preserveComponentMessages: true,
      ),
    );

    getScores('dota_scoreboard').match(
      (error) async {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        await context.respond(
          MessageBuilder(
            content: 'Something wrong has occurred, please try again',
          ),
        );
      },
      (scores) async {
        final memberManager = context.guild!.members;

        // Building the Page Buttons
        final backEmoji = context.client.getTextEmoji('◀️');
        final nextEmoji = context.client.getTextEmoji('▶️');

        await context.respond(
          await pagination.builders(
            await _paginatedScoreBuilder(scores, memberManager, 'RL'),
            options: PaginationOptions(
              nextEmoji: nextEmoji,
              nextStyle: ButtonStyle.primary,
              nextLabel: '',
              previousEmoji: backEmoji,
              previousStyle: ButtonStyle.primary,
              previousLabel: '',
              showJumpToEnds: false,
              showPageIndex: false,
            ),
          ),
        );
      },
    ).run();
  }),
);

final showCS = ChatCommand(
  'cs',
  'Show CS2 Scoreboard',
  id('cs', (
    InteractionChatContext context, [
    @Name('user') User? user,
  ]) async {
    await context.acknowledge(
      level: ResponseLevel(
        hideInteraction: false,
        isDm: false,
        mention: false,
        preserveComponentMessages: true,
      ),
    );

    getScores('cs_scoreboard').match(
      (error) async {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        await context.respond(
          MessageBuilder(
            content: 'Something wrong has occurred, please try again',
          ),
        );
      },
      (scores) async {
        final memberManager = context.guild!.members;

        // Building the Page Buttons
        final backEmoji = context.client.getTextEmoji('◀️');
        final nextEmoji = context.client.getTextEmoji('▶️');

        await context.respond(
          await pagination.builders(
            await _paginatedScoreBuilder(scores, memberManager, 'CS'),
            options: PaginationOptions(
              nextEmoji: nextEmoji,
              nextStyle: ButtonStyle.primary,
              nextLabel: '',
              previousEmoji: backEmoji,
              previousStyle: ButtonStyle.primary,
              previousLabel: '',
              showJumpToEnds: false,
              showPageIndex: false,
            ),
          ),
        );
      },
    ).run();
  }),
);

final showRL = ChatCommand(
  'rl',
  'Show Rocket League Scoreboard',
  id(
    'rl',
    (
      InteractionChatContext context, [
      @Name('user') User? user,
    ]) async {
      await context.acknowledge(
        level: ResponseLevel(
          hideInteraction: false,
          isDm: false,
          mention: false,
          preserveComponentMessages: true,
        ),
      );

      getScores('rl_scoreboard').match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occurred, please try again',
            ),
          );
        },
        (scores) async {
          final memberManager = context.guild!.members;

          // Building the Page Buttons
          final backEmoji = context.client.getTextEmoji('◀️');
          final nextEmoji = context.client.getTextEmoji('▶️');

          await context.respond(
            await pagination.builders(
              await _paginatedScoreBuilder(scores, memberManager, 'RL'),
              options: PaginationOptions(
                nextEmoji: nextEmoji,
                nextStyle: ButtonStyle.primary,
                nextLabel: '',
                previousEmoji: backEmoji,
                previousStyle: ButtonStyle.primary,
                previousLabel: '',
                showJumpToEnds: false,
                showPageIndex: true,
              ),
            ),
          );
        },
      ).run();
    },
  ),
);

EmbedBuilder _scoreEmbed(
  String type,
  String scoreboard,
  int totalPage,
) {
  late final String title, colour;
  switch (type) {
    case 'Dota':
      title = 'Dota prediction leaderboard';
      colour = 'd7342a';
      break;
    case 'CS':
      title = "CS prediction leaderboard";
      colour = 'f3a717';
      break;
    case 'RL':
      title = "RL prediction leaderboard";
      colour = 'f7f7f7';
      break;
  }
  return EmbedBuilder(
      title: title,
      color: DiscordColor.parseHexString(colour),
      author: EmbedAuthorBuilder(
        name: 'OG',
        iconUrl: Uri.parse(
          'https://liquipedia.net/commons/images/thumb/7/70/OG_RB_allmode.png/1200px-OG_RB_allmode.png',
        ),
      ),
      fields: [
        EmbedFieldBuilder(
          name: '',
          value: '```$scoreboard\n```',
          isInline: true,
        ),
        EmbedFieldBuilder(
          name: "Can't see yourself?",
          value:
              'Use /show ${type.toLowerCase()} @yourself to see where you stand',
          isInline: false,
        ),
      ]);
}

Future<String> _scoreboard(
  List<Score> scores,
  MemberManager memberManager,
  int page,
) async {
  final List<List<dynamic>> scoreboard = [
    ['Rank', 'Name', 'Score']
  ];
  final offset = (page - 1) * 10;
  int rank = (page - 1) * 10 + 1;

  for (final score in scores.skip(offset).take(10)) {
    try {
      final member = await memberManager.get(Snowflake.parse(score.id));
      String name = member.nick ?? member.user!.username;

      if (name.length > 12) {
        name = '${name.substring(0, 9)}...';
      }

      scoreboard.add([
        rank,
        name,
        score.score,
      ]);
      rank++;
    } catch (error) {
      GetIt.I
          .get<logger.Logger>()
          .i('${score.id} is no longer part of the server');
    }
  }

  return tabular(
    scoreboard,
    style: Style.markdown,
    border: Border.vertical,
    align: {'Name': Side.center},
  );
}

Future<List<MessageBuilder>> _paginatedScoreBuilder(
  List<Score> scores,
  MemberManager memberManager,
  String type,
) async {
  List<MessageBuilder> paginatedScore = [];

  final int totalPage = scores.length ~/ 10 + 1;

  for (int i = 0; i < totalPage; i++) {
    final scoreboard = await _scoreboard(scores, memberManager, i + 1);
    final scoreEmbed = _scoreEmbed(type, scoreboard, totalPage);
    paginatedScore.add(
      MessageBuilder(
        embeds: [scoreEmbed],
      ),
    );
  }

  return paginatedScore;
}
