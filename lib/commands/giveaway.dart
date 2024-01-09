import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

final giveaway = MessageCommand(
  'Giveaway',
  id(
    'Giveaway',
    (MessageContext context) async {
      String replyMessage = 'The giveaway winners are: ';

      final botID = context.interaction.applicationId;
      final message = context.targetMessage;
      final thumbsUpEmoji = context.client.getTextEmoji('👍');

      // Check if message has already been processed
      final thumbsUpReactions = await message.manager.fetchReactions(
        message.id,
        ReactionBuilder.fromEmoji(thumbsUpEmoji),
      );

      if (thumbsUpReactions.isNotEmpty) {
        context.respond(
          MessageBuilder(
            content: 'This message has been processed for giveaways',
          ),
          level: ResponseLevel.hint,
        );
      }

      await context.interaction.respondModal(_giveawayModal());
      context
          .awaitModal('giveawayModal', timeout: Duration(seconds: 30))
          .then((ModalContext modalContext) async {
        final numberOfWinners =
            int.parse(modalContext['numberOfWinnersInput']!);
        final peopleReacted = await message.manager.fetchReactions(
          message.id,
          ReactionBuilder(
              name: 'ruggahPain', id: Snowflake(951843834554376262)),
        );
        final ids = peopleReacted.map((user) => user.id).toList();

        // Remove the bot id from the potential winner list
        ids.removeAt(ids.indexOf(botID));
        ids.shuffle();
        final winners = ids.take(numberOfWinners);

        for (final id in winners) {
          replyMessage += '<@$id> ';
        }

        await Future.wait([
          modalContext.respond(MessageBuilder(content: replyMessage)),
          message.react(
            ReactionBuilder.fromEmoji(thumbsUpEmoji),
          ),
        ], eagerError: true);
      }).catchError(
        (err) {
          print('giveaway command error: $err');
        },
      );
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
