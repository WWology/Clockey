import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';

import '../constants.dart';
import '../data/game/game.dart';

class GameChecker extends NyxxPlugin<NyxxGateway> {
  late final Timer dotaTimer, csTimer, rlTimer;

  @override
  void afterConnect(NyxxGateway client) async {
    super.afterConnect(client);

    dotaTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      checkForDotaMatch(client);
    });

    await Future.delayed(const Duration(minutes: 5));

    csTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      checkForCSMatch(client);
    });

    await Future.delayed(const Duration(minutes: 5));

    rlTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      checkForRLMatch(client);
    });
  }

  @override
  void afterClose() async {
    super.afterClose();

    var gameBox = Hive.box<Game>('gameBox');
    await gameBox.clear();
    dotaTimer.cancel();
    csTimer.cancel();
    rlTimer.cancel();
  }
}

void checkForDotaMatch(
  NyxxGateway client,
) async {
  var gameBox = Hive.box<Game>('gameBox');
  final dotaMatch = gameBox.get('Dota');
  final DateTime currentTime = DateTime.now();

  if (dotaMatch != null) {
    print(dotaMatch.name);
    print(dotaMatch.alreadyPosted);
    // Check for conditions before posting
    if (!dotaMatch.alreadyPosted &&
        dotaMatch.time.difference(currentTime).inHours <= 1) {
      try {
        final embed = _gameEmbed(dotaMatch, 'Dota');

        await (client.channels[Snowflake(1218158154206937200)]
                as PartialTextChannel)
            .sendMessage(MessageBuilder(embeds: [embed]));

        dotaMatch.alreadyPosted = true;
        await dotaMatch.save();
        return;
      } catch (error) {
        GetIt.I.get<logger.Logger>().e(error);
        return;
      }
    } else if (currentTime.isAfter(dotaMatch.expiryTime)) {
      gameBox.delete('Dota');
      return;
    } else {
      return;
    }
  } else {
    try {
      // Todo, implement Liquipedia's api
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
    print(csMatch.name);
    print(csMatch.alreadyPosted);
    // Check for conditions before posting
    if (!csMatch.alreadyPosted &&
        csMatch.time.difference(currentTime).inHours <= 1) {
      try {
        final embed = _gameEmbed(csMatch, 'CS');

        await (client.channels[Snowflake(1218158154206937200)]
                as PartialTextChannel)
            .sendMessage(MessageBuilder(embeds: [embed]));

        csMatch.alreadyPosted = true;
        await csMatch.save();
        return;
      } catch (error) {
        GetIt.I.get<logger.Logger>().e(error);
        return;
      }
    } else if (currentTime.isAfter(csMatch.expiryTime)) {
      gameBox.delete('CS');
      return;
    } else {
      return;
    }
  } else {
    try {
      // Todo Implement Liquipedia's API
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
    print(rlMatch.name);
    print(rlMatch.alreadyPosted);
    // Check for conditions before posting
    if (!rlMatch.alreadyPosted &&
        rlMatch.time.difference(currentTime).inHours <= 1) {
      try {
        final embed = _gameEmbed(rlMatch, 'RL');

        await (client.channels[Snowflake(1218158154206937200)]
                as PartialTextChannel)
            .sendMessage(MessageBuilder(embeds: [embed]));

        rlMatch.alreadyPosted = true;
        await rlMatch.save();
        return;
      } catch (error) {
        GetIt.I.get<logger.Logger>().e(error);
      }
    } else if (currentTime.isAfter(rlMatch.expiryTime)) {
      gameBox.delete('RL');
      return;
    } else {
      return;
    }
  } else {
    try {
      // Todo Implement Liquipedia's API
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
    ],
  );
}
