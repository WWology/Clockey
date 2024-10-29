import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';

import '../data/game/game.dart';
import '../env.dart';

class GameChecker extends NyxxPlugin<NyxxGateway> {
  late final Timer dotaTimer, csTimer, rlTimer;

  @override
  void afterConnect(NyxxGateway client) async {
    super.afterConnect(client);
    final apiKey = {'authorization': 'Apikey ${Env.liquipediaApiKey}'};

    dotaTimer = Timer.periodic(const Duration(minutes: 6), (timer) {
      checkForDotaMatch(client, apiKey);
    });

    await Future.delayed(const Duration(minutes: 5));

    csTimer = Timer.periodic(const Duration(minutes: 6), (timer) {
      checkForCSMatch(client, apiKey);
    });

    await Future.delayed(const Duration(minutes: 5));

    rlTimer = Timer.periodic(const Duration(minutes: 6), (timer) {
      checkForRLMatch(client, apiKey);
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

void checkForDotaMatch(NyxxGateway client, Map<String, String> apiKey) async {
  var gameBox = Hive.box<Game>('gameBox');
  final dotaMatch = gameBox.get('Dota');
  final DateTime currentTime = DateTime.now();

  final ogGuild = await client.guilds.get(Snowflake(Env.guildId));
  final eventList = List.of(await ogGuild.scheduledEvents.list());
  if (dotaMatch != null) {
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
      final url = Uri.parse(
        'https://api.liquipedia.net/api/v3/match?wiki=dota2&conditions=%5B%5Bopponent%3A%3AOG%5D%5D&'
        'query=match2opponents%2C%20date%2C%20stream&limit=10&'
        'order=date%20DESC&'
        'rawstreams=true&streamurls=true',
      );

      final request = http.Request(
        'GET',
        url,
      );

      request.headers.addAll(apiKey);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      GetIt.I.get<logger.Logger>().e(error);
    }
  }
}

void checkForCSMatch(NyxxGateway client, Map<String, String> apiKey) async {
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
  Map<String, String> apiKey,
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
  const String ogDotaUrl = 'https://liquipedia.net/dota2/OG';
  const String ogCSUrl = 'https://liquipedia.net/counterstrike/OG';
  const String ogRLUrl = 'https://liquipedia.net/rocketleague/OG';

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
