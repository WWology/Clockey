import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final giveaway = MessageCommand(
  'Roll Giveaway winners',
  options: CommandOptions(defaultResponseLevel: ResponseLevel.hint),
  id(
    'Roll Giveaway winners',
    (MessageContext context) async {
      String replyMessage = 'The giveaway winners are: ';
      final clockeyId = context.interaction.applicationId;
      final message = context.targetMessage;

      await context.interaction.respondModal(_giveawayModal());
      final modalContext = await context.awaitModal(
        'giveawayModal',
        timeout: Duration(seconds: 30),
      );

      final numberOfWinners = int.parse(modalContext['numberOfWinnersInput']!);

      //   List<User> peopleReacted = [];
      //   final reactions = message.reactions;
      //   for (final reaction in reactions) {
      //     final emoji = await reaction.emoji.get();
      //     final users = await message.manager
      //         .fetchReactions(message.id, ReactionBuilder.fromEmoji(emoji));
      //     peopleReacted.addAll(users);
      //   }

      final peopleReacted = await message.manager.fetchReactions(
        message.id,
        ReactionBuilder(
          name: 'OGpeepoYes',
          id: Snowflake(730890894814740541),
        ),
      );
      final ids = peopleReacted.map((user) => user.id.value).toList();

      // Remove the bots id from the potential gardener list
      if (ids.contains(clockeyId.value)) {
        ids.removeAt(ids.indexOf(clockeyId.value));
      }

      ids.shuffle();
      final winners = ids.take(numberOfWinners);

      for (final id in winners) {
        replyMessage += '<@$id> ';
      }

      await modalContext.respond(MessageBuilder(content: replyMessage));
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
