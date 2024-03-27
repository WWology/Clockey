import 'package:hive/hive.dart';

part 'game.g.dart';

@HiveType(typeId: 0)
class Game extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime time;

  @HiveField(2)
  final String streamUrl;

  @HiveField(3)
  final DateTime expiryTime;

  @HiveField(4)
  bool alreadyPosted = false;

  Game({
    required this.name,
    required this.time,
    required this.streamUrl,
    required this.expiryTime,
  });
}
