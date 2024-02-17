import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:puppeteer/puppeteer.dart';

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

      // Navigate to OG's Dota page
      final browser = await puppeteer.launch();
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

      final embed = _gameEmbedBuilder(opponent, matchTimeUnix, 'Dota');
      await browser.close();

      if (context.channel.id.value == 721391448812945480 ||
          context.channel.id.value == 720994728937521193) {
        context.respond(
          MessageBuilder(
            embeds: [embed],
          ),
        );
      } else {
        if (opponent != null && matchTimeUnix != 'error') {
          context.respond(
            MessageBuilder(
              content:
                  'OG vs $opponent - <t:$matchTimeUnix:F> in your local timezone - '
                  'For more information use /next dota in <#721391448812945480>',
            ),
          );
        } else {
          context.respond(
            MessageBuilder(
              content: 'No games planned currently - '
                  'For more information use /next dota in <#721391448812945480>',
            ),
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

      // Navigate to OG's CS page
      final browser = await puppeteer.launch();
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

      final embed = _gameEmbedBuilder(opponent, matchTimeUnix, 'CS');
      await browser.close();
      if (context.channel.id.value == 721391448812945480 ||
          context.channel.id.value == 720994728937521193) {
        context.respond(
          MessageBuilder(
            embeds: [embed],
          ),
        );
      } else {
        if (opponent != null && matchTimeUnix != 'error') {
          context.respond(
            MessageBuilder(
              content:
                  'OG vs $opponent - <t:$matchTimeUnix:F> in your local timezone - '
                  'For more information use /next cs in <#721391448812945480>',
            ),
          );
        } else {
          context.respond(
            MessageBuilder(
              content: 'No games planned currently - '
                  'For more information use /next cs in <#721391448812945480>',
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

      // Navigate to OG's Rocket League Page
      final browser = await puppeteer.launch();
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

      final embed = _gameEmbedBuilder(opponent, matchTimeUnix, 'RL');

      await browser.close();
      if (context.channel.id.value == 721391448812945480 ||
          context.channel.id.value == 720994728937521193) {
        context.respond(
          MessageBuilder(
            embeds: [embed],
          ),
        );
      } else {
        if (opponent != null && matchTimeUnix != 'error') {
          context.respond(
            MessageBuilder(
              content:
                  'OG vs $opponent - <t:$matchTimeUnix:F> in your local timezone - '
                  'For more information use /next rl in <#721391448812945480>',
            ),
          );
        } else {
          context.respond(
            MessageBuilder(
              content: 'No games planned currently - '
                  'For more information use /next rl in <#721391448812945480>',
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
  String type,
) {
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

  if (opponent != null && matchTimeUnix != 'error') {
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
