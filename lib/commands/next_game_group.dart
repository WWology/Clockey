import 'package:get_it/get_it.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:puppeteer/puppeteer.dart';

import '../constants.dart';

const String ogDotaUrl = 'https://liquipedia.net/dota2/OG';
const String ogCSUrl = 'https://liquipedia.net/counterstrike/OG';
const String ogRLUrl = 'https://liquipedia.net/rocketleague/OG';

ChatGroup nextGameGroup = ChatGroup(
  'next',
  'Command for next available games for OG',
  children: [nextDota, nextCS, nextRL],
);

final nextDota = ChatCommand(
  'dota',
  'Next Dota game for OG',
  id(
    'dota',
    (InteractionChatContext context) async {
      context.acknowledge();
      bool inBotChannels = context.channel.id.value == botSpamChannelId ||
          context.channel.id.value == botStuffChannelId;

      try {
        // Navigate to OG's Dota page
        final browser = GetIt.I.get<Browser>();
        final page = await browser.newPage();
        await page.goto(ogDotaUrl, wait: Until.networkIdle);

        final opponent = await page.$eval<String>(
          '.team-template-team-short',
          /* js */
          '''
            function (matchTable) {
              return matchTable.lastElementChild.innerText;
            }
          ''',
        );

        final matchTimeUnix = await page.$eval<String>(
          '.timer-object-countdown-only',
          /* js */
          '''
            function (matchTime) {
              return matchTime.getAttribute('data-timestamp');
          }
          ''',
        );
        page.close();

        if (opponent != null && matchTimeUnix != 'error') {
          final embed = _gameEmbedBuilder(opponent, matchTimeUnix, 'Dota');

          if (inBotChannels) {
            context.respond(
              MessageBuilder(
                embeds: [embed],
              ),
            );
          } else {
            context.respond(
              MessageBuilder(
                content:
                    'OG vs $opponent - <t:$matchTimeUnix:F> in your local timezone - '
                    'For more information use /next dota in <#$botSpamChannelId>',
              ),
            );
          }
        }
      } catch (e) {
        if (inBotChannels) {
          final embed = _gameEmbedBuilder('', '', 'Dota', error: true);
          context.respond(MessageBuilder(embeds: [embed]));
        } else {
          context.respond(
            MessageBuilder(
                content: 'No games planned currently - '
                    'For more information use /next dota in <#$botSpamChannelId>'),
          );
        }
      }
    },
  ),
);

final nextCS = ChatCommand(
  'cs',
  'Next CS game for OG',
  id(
    'cs',
    (InteractionChatContext context) async {
      context.acknowledge();
      bool inBotChannels = context.channel.id.value == botSpamChannelId ||
          context.channel.id.value == botStuffChannelId;

      try {
        // Navigate to OG's CS page
        final browser = GetIt.I.get<Browser>();
        final page = await browser.newPage();
        await page.goto(ogCSUrl, wait: Until.networkIdle);

        final opponent = await page.$eval<String>(
          '.team-template-team-short',
          /* js */
          '''
          function (matchTable) {
            return matchTable.lastElementChild.innerText;
          }
          ''',
        );

        final matchTimeUnix = await page.$eval<String>(
          '.timer-object-countdown-only',
          /* js */
          '''
          function (matchTime) {
            return matchTime.getAttribute('data-timestamp');
          }
          ''',
        );
        page.close();

        if (opponent != null && matchTimeUnix != 'error') {
          final embed = _gameEmbedBuilder(opponent, matchTimeUnix, 'CS');

          if (inBotChannels) {
            context.respond(
              MessageBuilder(
                embeds: [embed],
              ),
            );
          } else {
            context.respond(
              MessageBuilder(
                content:
                    'OG vs $opponent - <t:$matchTimeUnix:F> in your local timezone - '
                    'For more information use /next cs in <#$botSpamChannelId>',
              ),
            );
          }
        }
      } catch (e) {
        if (inBotChannels) {
          final embed = _gameEmbedBuilder('', '', 'CS', error: true);
          context.respond(MessageBuilder(embeds: [embed]));
        } else {
          context.respond(
            MessageBuilder(
              content: 'No games planned currently - '
                  'For more information use /next cs in <#$botSpamChannelId>',
            ),
          );
        }
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
      context.acknowledge();
      bool inBotChannels = context.channel.id.value == botSpamChannelId ||
          context.channel.id.value == botStuffChannelId;

      try {
        // Navigate to OG's Rocket League Page
        final browser = GetIt.I.get<Browser>();
        final page = await browser.newPage();
        await page.goto(ogRLUrl, wait: Until.networkIdle);

        // Get Opponent's team name
        final opponent = await page.$eval<String>(
          '.team-template-team-short',
          /* js */
          '''
          function (matchTable) {
            return matchTable.lastElementChild.innerText;
          }
          ''',
        );

        final matchTimeUnix = await page.$eval<String>(
          '.timer-object-countdown-only',
          /* js */
          '''
          function (matchTime) {
            return matchTime.getAttribute('data-timestamp');
          }
          ''',
        );
        page.close();

        if (opponent != null && matchTimeUnix != 'error') {
          final embed = _gameEmbedBuilder(opponent, matchTimeUnix, 'RL');

          if (inBotChannels) {
            context.respond(
              MessageBuilder(
                embeds: [embed],
              ),
            );
          } else {
            context.respond(
              MessageBuilder(
                content:
                    'OG vs $opponent - <t:$matchTimeUnix:F> in your local timezone - '
                    'For more information use /next rl in <#$botSpamChannelId>',
              ),
            );
          }
        }
      } catch (e) {
        if (inBotChannels) {
          final embed = _gameEmbedBuilder('', '', 'RL', error: true);
          context.respond(MessageBuilder(embeds: [embed]));
        } else {
          context.respond(
            MessageBuilder(
              content: 'No games planned currently - '
                  'For more information use /next rl in <#$botSpamChannelId>',
            ),
          );
        }
      }
    },
  ),
);

EmbedBuilder _gameEmbedBuilder(
  String? opponent,
  String? matchTimeUnix,
  String type, {
  bool error = false,
}) {
  late final String title, url, colour;
  switch (type) {
    case 'Dota':
      title = "OG's Dota next game";
      url = ogDotaUrl;
      colour = 'd7342a';
      break;
    case 'CS':
      title = "OG's CS next game";
      url = ogCSUrl;
      colour = 'f3a717';
      break;
    case 'RL':
      title = "OG's RL next game";
      url = ogRLUrl;
      colour = 'f7f7f7';
      break;
  }

  if (!error) {
    return EmbedBuilder(
      color: DiscordColor.parseHexString(colour),
      title: title,
      url: Uri.parse(url),
      thumbnail: EmbedThumbnailBuilder(
        url: Uri.parse(
          'https://liquipedia.net/commons/images/thumb'
          '/7/70/OG_RB_allmode.png/1200px-OG_RB_allmode.png',
        ),
      ),
      fields: [
        EmbedFieldBuilder(
          name: 'OG vs $opponent',
          value: '<t:$matchTimeUnix:F> - This is local to your timezone',
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Time remaining',
          value: '<t:$matchTimeUnix:R>',
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Notice',
          value: 'Please check Liquipedia by clicking the title of this '
              'embed for more information as the time might not be accurate',
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Links',
          value: "[OG Liquipedia]($url)",
          isInline: false,
        ),
      ],
      footer: EmbedFooterBuilder(
        text: "Data sourced from Liquipedia",
        iconUrl: Uri.parse(
          'https://liquipedia.net/commons/extensions/'
          'TeamLiquidIntegration/resources/pagelogo/liquipedia_icon_menu.png',
        ),
      ),
    );
  } else {
    return EmbedBuilder(
      color: DiscordColor.parseHexString(colour),
      title: title,
      url: Uri.parse(url),
      thumbnail: EmbedThumbnailBuilder(
        url: Uri.parse(
          'https://liquipedia.net/commons/images/thumb'
          '/7/70/OG_RB_allmode.png/1200px-OG_RB_allmode.png',
        ),
      ),
      fields: [
        EmbedFieldBuilder(
          name: 'Time Remaining',
          value: 'No games currently planned',
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Notice',
          value: 'Please check Liquipedia by clicking the title of this '
              'embed for more information as the time might not be accurate',
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Links',
          value: "[OG Liquipedia]($url)",
          isInline: false,
        ),
      ],
      footer: EmbedFooterBuilder(
        text: "Data sourced from Liquipedia",
        iconUrl: Uri.parse(
          'https://liquipedia.net/commons/extensions/'
          'TeamLiquidIntegration/resources/pagelogo/liquipedia_icon_menu.png',
        ),
      ),
    );
  }
}
