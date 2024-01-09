import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:supabase/supabase.dart';

import '../data/events/events.dart';
import '../env.dart';

final gardener = MessageCommand(
  'Gardener',
  id('Gardener', (MessageContext context) async {
    final supabase = SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey);
    String replyMessage = 'The people selected are: ';

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
          content: 'This message has already been processed for signups',
        ),
        level: ResponseLevel.hint,
      );
      return;
    }

    await context.interaction.respondModal(_gardenerModal());
    context
        .awaitModal('gardenerModal', timeout: Duration(seconds: 30))
        .then((ModalContext modalContext) async {
      final numberOfGardeners =
          int.parse(modalContext['numberOfGardenersInput']!);
      final gardenerReacted = await message.manager.fetchReactions(
        message.id,
        ReactionBuilder(name: 'ruggahPain', id: Snowflake(951843834554376262)),
      );
      final ids = gardenerReacted.map((gardener) => gardener.id.value).toList();

      // Remove the bot id from the potential gardener list
      ids.removeAt(ids.indexOf(botID.value));
      ids.shuffle();
      final gardenersWorking = ids.take(numberOfGardeners).toList();

      final (eventName, eventTime, eventType, hours) =
          _parseEvent(message, context);

      final event = Event(
        eventName: eventName,
        eventTime: eventTime,
        eventType: eventType,
        gardeners: gardenersWorking,
        hours: hours,
      );

      for (final id in gardenersWorking) {
        replyMessage += '<@$id> ';
      }

      Future.wait(
        [
          modalContext.respond(MessageBuilder(content: replyMessage)),
          message.react(
            ReactionBuilder.fromEmoji(thumbsUpEmoji),
          ),
          supabase.from('clockey').insert(event)
        ],
        eagerError: true,
      );
    }).catchError((err) {
      print('gardener command error: $err');
    });
  }),
);

ModalBuilder _gardenerModal() {
  final numberOfGardenersInput = TextInputBuilder(
    customId: 'numberOfGardenersInput',
    style: TextInputStyle.short,
    label: 'Number of Gardeners to work this event',
    isRequired: true,
  );

  final firstActionRow = ActionRowBuilder(components: [numberOfGardenersInput]);

  return ModalBuilder(
    customId: 'gardenerModal',
    title: 'Gardener Modal',
    components: [firstActionRow],
  );
}

class UnknownEventError {
  const UnknownEventError();
}

(
  String eventName,
  DateTime eventTime,
  EventType eventType,
  int hours,
) _parseEvent(Message message, MessageContext context) {
  final EventType eventType;

  if (message.content.contains('Dota')) {
    eventType = EventType.Dota;
  } else if (message.content.contains('CS')) {
    eventType = EventType.CS;
  } else if (message.content.contains('Rocket League')) {
    eventType = EventType.RL;
  } else if (message.content.contains('Other')) {
    eventType = EventType.Other;
  } else {
    context.respond(
        MessageBuilder(content: 'Something has gone wrong, please try again'));
    throw const UnknownEventError();
  }

  final eventName = message.content.substring(
    message.content.indexOf("-") + 2,
    message.content.indexOf(","),
  );

  final eventUnixTime = int.parse(
        message.content.substring(
          message.content.indexOf('<t:') + 3,
          message.content.indexOf('<t:') + 13,
        ),
      ) *
      1000;

  final eventTime = DateTime.fromMillisecondsSinceEpoch(eventUnixTime).toUtc();

  final hours = int.parse(message.content[message.content.indexOf("add") + 4]);

  return (
    eventName,
    eventTime,
    eventType,
    hours,
  );
}
