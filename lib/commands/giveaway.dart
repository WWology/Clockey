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

      await modalContext.acknowledge();
      final numberOfWinners = int.parse(modalContext['numberOfWinnersInput']!);

      List<User> peopleReacted = [];
      final reactions = message.reactions;
      for (final reaction in reactions) {
        if (reaction.emoji is TextEmoji) {
          final users = await message.manager.fetchReactions(message.id,
              ReactionBuilder.fromEmoji(reaction.emoji as TextEmoji));
          peopleReacted.addAll(users);
        } else {
          final users = await message.manager.fetchReactions(
            message.id,
            ReactionBuilder(name: 'emoji', id: reaction.emoji.id),
            limit: 100,
          );
          peopleReacted.addAll(users);
        }
      }

      final ids = peopleReacted.map((user) => user.id.value).toList();

      // Remove the bots id from the potential gardener list
      if (ids.contains(clockeyId.value)) {
        ids.removeAt(ids.indexOf(clockeyId.value));
      }

      ids.shuffle();
      final winners = ids.toSet().take(numberOfWinners);

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
