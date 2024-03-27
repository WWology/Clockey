import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:puppeteer/puppeteer.dart';

import '../constants.dart';
import '../data/game/game.dart';

class GameChecker extends NyxxPlugin<NyxxGateway> {
  late final Timer timer;

  @override
  void afterConnect(NyxxGateway client) async {
    super.afterConnect(client);

    timer = Timer.periodic(const Duration(minutes: 15), (timer) {
      checkForDotaMatch(client);
      //   checkForCSMatch(client);
      checkForRLMatch(client);
    });
  }

  @override
  void afterClose() async {
    super.afterClose();

    var gameBox = Hive.box<Game>('gameBox');
    await gameBox.clear();
    timer.cancel();
  }
}

void checkForDotaMatch(
  NyxxGateway client,
) async {
  var gameBox = Hive.box<Game>('gameBox');
  await gameBox.clear();
  final dotaMatch = gameBox.get('Dota');
  final DateTime currentTime = DateTime.now();

  if (dotaMatch != null) {
    print(dotaMatch.alreadyPosted);
    // Check for conditions before posting
    if (!dotaMatch.alreadyPosted &&
        dotaMatch.time.difference(currentTime).inHours <= 1) {
      final embed = _gameEmbed(dotaMatch, 'Dota');

      await (client.channels[Snowflake(720994728937521193)]
              as PartialTextChannel)
          .sendMessage(MessageBuilder(embeds: [embed]));

      dotaMatch.alreadyPosted = true;
      await dotaMatch.save();
      return;
    } else if (currentTime.isAfter(dotaMatch.expiryTime)) {
      gameBox.delete('Dota');
      return;
    } else {
      return;
    }
  } else {
    const String ogDotaUrl = 'https://liquipedia.net/dota2/OG';
    final browser = GetIt.I.get<Browser>();
    final page = await browser.newPage();

    try {
      // Navigate to OG's Dota page
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

      final gameTimeUnix = await page.$eval<String>(
        '.timer-object-countdown-only',
        /* js */
        '''
        function (matchTime) {
          return matchTime.getAttribute('data-timestamp');
        }
        ''',
      );

      if (opponent != null && gameTimeUnix != 'error' && gameTimeUnix != null) {
        final gameTime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(gameTimeUnix) * 1000)
                .toUtc();

        final specialUrl = await page.$eval<String>(
          '.timer-object-countdown',
          /* js */
          '''
          function (matchUrl) {
            return matchUrl.firstElementChild.nextElementSibling.getAttribute('href');
          }
          ''',
        );
        if (specialUrl != null) {
          late final String streamUrl;
          final split = specialUrl.split('/');
          final platform = split.reversed.toList()[1];
          final channel = split.last;

          if (platform == 'twitch') {
            streamUrl = 'https://www.twitch.tv/$channel';
          } else {
            streamUrl = 'https://www.youtube.com/$channel';
          }

          final game = Game(
            name: 'OG vs $opponent',
            time: gameTime,
            streamUrl: streamUrl,
            expiryTime: gameTime.add(Duration(hours: 6)),
          );
          gameBox.put('Dota', game);
          await page.close();
        } else {
          GetIt.I.get<logger.Logger>().i('No streams found');
        }
      }
    } catch (error) {
      GetIt.I.get<logger.Logger>().e(error);
    }
  }
}

void checkForCSMatch(
  NyxxGateway client,
) async {
  var gameBox = Hive.box<Game>('gameBox');
  final csMatch = gameBox.get('CS');
  final DateTime currentTime = DateTime.now();

  if (csMatch != null) {
    print(csMatch);
    // Check for conditions before posting
    if (!csMatch.alreadyPosted &&
        csMatch.time.difference(currentTime).inHours <= 1) {
      final embed = _gameEmbed(csMatch, 'CS');

      await (client.channels[Snowflake(720994728937521193)]
              as PartialTextChannel)
          .sendMessage(MessageBuilder(embeds: [embed]));

      csMatch.alreadyPosted = true;
      await csMatch.save();
      return;
    } else if (currentTime.isAfter(csMatch.expiryTime)) {
      gameBox.delete('CS');
      return;
    } else {
      return;
    }
  } else {
    const String ogCSUrl = 'https://liquipedia.net/counterstrike/OG';
    final browser = GetIt.I.get<Browser>();
    final page = await browser.newPage();

    try {
      // Navigate to OG's CS page
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

      final gameTimeUnix = await page.$eval<String>(
        '.timer-object-countdown-only',
        /* js */
        '''
        function (matchTime) {
          return matchTime.getAttribute('data-timestamp');
        }
        ''',
      );

      if (opponent != null && gameTimeUnix != 'error' && gameTimeUnix != null) {
        final gameTime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(gameTimeUnix) * 1000)
                .toUtc();

        final specialUrl = await page.$eval<String>(
          '.timer-object-countdown',
          /* js */
          '''
          function (matchUrl) {
            return matchUrl.firstElementChild.nextElementSibling.getAttribute('href');
          }
          ''',
        );
        if (specialUrl != null) {
          late final String streamUrl;
          final split = specialUrl.split('/');
          final platform = split.reversed.toList()[1];
          final channel = split.last;

          if (platform == 'twitch') {
            streamUrl = 'https://www.twitch.tv/$channel';
          } else {
            streamUrl = 'https://www.youtube.com/$channel';
          }

          final game = Game(
            name: 'OG vs $opponent',
            time: gameTime,
            streamUrl: streamUrl,
            expiryTime: gameTime.add(Duration(hours: 6)),
          );
          gameBox.put('CS', game);
          await page.close();
        } else {
          GetIt.I.get<logger.Logger>().i('No streams found');
        }
      }
    } catch (error) {
      GetIt.I.get<logger.Logger>().e(error);
    }
  }
}

void checkForRLMatch(
  NyxxGateway client,
) async {
  var gameBox = Hive.box<Game>('gameBox');
  final rlMatch = gameBox.get('RL');
  final DateTime currentTime = DateTime.now();

  if (rlMatch != null) {
    print(rlMatch.alreadyPosted);
    // Check for conditions before posting
    if (!rlMatch.alreadyPosted &&
        rlMatch.time.difference(currentTime).inHours <= 1) {
      final embed = _gameEmbed(rlMatch, 'RL');

      await (client.channels[Snowflake(720994728937521193)]
              as PartialTextChannel)
          .sendMessage(MessageBuilder(embeds: [embed]));

      rlMatch.alreadyPosted = true;
      await rlMatch.save();
      return;
    } else if (currentTime.isAfter(rlMatch.expiryTime)) {
      gameBox.delete('RL');
      return;
    } else {
      return;
    }
  } else {
    const String ogRLUrl = 'https://liquipedia.net/rocketleague/OG';
    final browser = GetIt.I.get<Browser>();
    final page = await browser.newPage();

    try {
      // Navigate to OG's RL page
      await page.goto(ogRLUrl, wait: Until.networkIdle);

      final opponent = await page.$eval<String>(
        '.team-template-team-short',
        /* js */
        '''
        function (matchTable) {
          return matchTable.lastElementChild.innerText;
        }
        ''',
      );

      final gameTimeUnix = await page.$eval<String>(
        '.timer-object-countdown-only',
        /* js */
        '''
        function (matchTime) {
          return matchTime.getAttribute('data-timestamp');
        }
        ''',
      );

      if (opponent != null && gameTimeUnix != 'error' && gameTimeUnix != null) {
        final gameTime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(gameTimeUnix) * 1000)
                .toUtc();

        final specialUrl = await page.$eval<String>(
          '.timer-object-countdown',
          /* js */
          '''
          function (matchUrl) {
            return matchUrl.firstElementChild.nextElementSibling.getAttribute('href');
          }
          ''',
        );
        if (specialUrl != null) {
          late final String streamUrl;
          final split = specialUrl.split('/');
          final platform = split.reversed.toList()[1];
          final channel = split.last;

          if (platform == 'twitch') {
            streamUrl = 'https://www.twitch.tv/$channel';
          } else {
            streamUrl = 'https://www.youtube.com/$channel';
          }

          final game = Game(
            name: 'OG vs $opponent',
            time: gameTime,
            streamUrl: streamUrl,
            expiryTime: gameTime.add(Duration(hours: 1)),
          );
          gameBox.put('RL', game);
          await page.close();
        } else {
          GetIt.I.get<logger.Logger>().i('No streams found');
        }
      }
    } catch (error) {
      GetIt.I.get<logger.Logger>().e(error);
    }
  }
}

EmbedBuilder _gameEmbed(Game game, String type) {
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

  return EmbedBuilder(
      title: title,
      color: DiscordColor.parseHexString(colour),
      url: Uri.parse(url),
      thumbnail: EmbedThumbnailBuilder(
        url: Uri.parse(
          'https://liquipedia.net/commons/images/thumb'
          '/7/70/OG_RB_allmode.png/1200px-OG_RB_allmode.png',
        ),
      ),
      fields: [
        EmbedFieldBuilder(
          name: game.name,
          value:
              '<t:${game.time.millisecondsSinceEpoch ~/ 1000}:F> - This is local to your timezone',
          isInline: false,
        ),
        EmbedFieldBuilder(
          name: 'Streams',
          value: game.streamUrl,
          isInline: false,
        )
      ]);
}
