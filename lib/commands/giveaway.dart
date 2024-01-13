import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final giveaway = MessageCommand(
  'Giveaway',
  id(
    'Roll Giveaway winners',
    (MessageContext context) async {
      String replyMessage = 'The giveaway winners are: ';

      final botID = context.interaction.applicationId;
      final message = context.targetMessage;
      final weCooEmoji = ReactionBuilder(
        name: 'OGwecoo',
        id: Snowflake(787697278190223370),
      );

      // Check if message has already been processed
      final weCooReactions = await message.manager.fetchReactions(
        message.id,
        weCooEmoji,
      );

      if (weCooReactions.isNotEmpty) {
        context.respond(
          MessageBuilder(
            content: 'This message has been processed for giveaways',
          ),
          level: ResponseLevel.hint,
        );
      }

      await context.interaction.respondModal(_giveawayModal());
      final modalContext = await context.awaitModal(
        'giveawayModal',
        timeout: Duration(seconds: 30),
      );

      final numberOfWinners = int.parse(modalContext['numberOfWinnersInput']!);
      final peopleReacted = await message.manager.fetchReactions(
        message.id,
        ReactionBuilder(
          name: 'OGpeepoYes',
          id: Snowflake(730890894814740541),
        ),
      );
      final ids = peopleReacted.map((user) => user.id).toList();

      // Remove the bot id from the potential winner list
      ids.removeAt(ids.indexOf(botID));
      ids.shuffle();
      final winners = ids.take(numberOfWinners);

      for (final id in winners) {
        replyMessage += '<@$id> ';
      }

      Future.wait([
        modalContext.respond(MessageBuilder(content: replyMessage)),
        message.react(weCooEmoji),
      ], eagerError: true);
    },
  ),
);

ModalBuilder _giveawayModal() {
  final numberOfWinnersInput = TextInputBuilder(
    customId: 'numberOfWinnersInput',
    style: TextInputStyle.short,
    label: 'Number of people to win the giveaway',
    isRequired: true,
  );

  final firstActionRow = ActionRowBuilder(components: [numberOfWinnersInput]);

  return ModalBuilder(
    customId: 'giveawayModal',
    title: 'Giveaway Modal',
    components: [firstActionRow],
  );
}
