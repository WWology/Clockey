class Match {
  List<Result> result;

  Match({
    required this.result,
  });
}

class Result {
  DateTime date;
  Stream stream;
  String match2Id;
  String pagename;
  int namespace;
  List<Match2Opponent> match2Opponents;
  String wiki;

  Result({
    required this.date,
    required this.stream,
    required this.match2Id,
    required this.pagename,
    required this.namespace,
    required this.match2Opponents,
    required this.wiki,
  });
}

class Match2Opponent {
  int id;
  String type;
  String name;
  String template;
  String icon;
  int score;
  String status;
  int placement;
  List<Match2Player> match2Players;
  dynamic extradata;
  Teamtemplate teamtemplate;

  Match2Opponent({
    required this.id,
    required this.type,
    required this.name,
    required this.template,
    required this.icon,
    required this.score,
    required this.status,
    required this.placement,
    required this.match2Players,
    required this.extradata,
    required this.teamtemplate,
  });
}

class Match2Player {
  int id;
  int opid;
  String name;
  String displayname;
  String flag;
  dynamic extradata;

  Match2Player({
    required this.id,
    required this.opid,
    required this.name,
    required this.displayname,
    required this.flag,
    required this.extradata,
  });
}

class Teamtemplate {
  String template;
  String page;
  String name;
  String shortname;
  String bracketname;
  String image;
  String imagedark;
  String legacyimage;
  String legacyimagedark;
  String imageurl;
  String imagedarkurl;
  String legacyimageurl;
  String legacyimagedarkurl;

  Teamtemplate({
    required this.template,
    required this.page,
    required this.name,
    required this.shortname,
    required this.bracketname,
    required this.image,
    required this.imagedark,
    required this.legacyimage,
    required this.legacyimagedark,
    required this.imageurl,
    required this.imagedarkurl,
    required this.legacyimageurl,
    required this.legacyimagedarkurl,
  });
}

class Stream {
  String twitchEn1;
  String twitch;

  Stream({
    required this.twitchEn1,
    required this.twitch,
  });
}
