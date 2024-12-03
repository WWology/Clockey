import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../../data/events/events.dart';
import '../../templates/templates.dart';

final invoice = ChatCommand(
  'invoice',
  'Generate invoice',
  id(
    'invoice',
    (
      InteractionChatContext context,
      @Description(
        'The start date of the invoice, please use YYYY-MM-DD format',
      )
      String startDate, [
      @Description(
        'The end date of this invoice, please use YYYY-MM-DD format',
      )
      String? endDate,
    ]) async {
      final DateTime end;

      await context.acknowledge();
      final user = context.user;
      final member = context.member;

      if (DateTime.tryParse(startDate) == null) {
        await context.respond(
          MessageBuilder(
            content: 'Start date format is invalid, please use YYYY-MM-DD',
          ),
        );
      }
      final start = DateTime.parse(startDate);

      if (endDate != null) {
        if (DateTime.tryParse(endDate) == null) {
          await context.respond(
            MessageBuilder(
              content: 'End date format is invalid, please use YYYY-MM-DD',
            ),
          );
        }
        end = DateTime.parse(endDate);
      } else {
        end = DateTime.now();
      }

      getEvents(
        start: start,
        end: end,
        gardenerID: context.user.id.value,
      ).match(
        (error) async {
          GetIt.I.get<logger.Logger>().e(error.message, error: error);
          await context.respond(
            MessageBuilder(
              content: 'Something has gone wrong, please try again',
            ),
          );
        },
        (invoiceData) async {
          final invoiceEmbed = _generateInvoiceEmbed(
            invoiceData,
            user,
            start,
            end,
            member: member,
          );

          final invoiceHtml =
              await createInvoiceHtml(invoiceData, user.id.value);

          final converterButton = ButtonBuilder.link(
            url: Uri.parse('https://wordtohtml.net/convert/html-to-docx'),
            label: 'Convert HTML Here',
          );

          final row = ActionRowBuilder(components: [converterButton]);

          await context.respond(
            MessageBuilder(
              embeds: [invoiceEmbed],
              attachments: [
                AttachmentBuilder(
                    data: invoiceHtml.readAsBytesSync(),
                    fileName: 'invoice.html'),
              ],
              components: [row],
            ),
          );
        },
      ).run();
    },
  ),
  options: CommandOptions(
    defaultResponseLevel: ResponseLevel(
      hideInteraction: true,
      isDm: false,
      mention: null,
      preserveComponentMessages: false,
    ),
  ),
);

EmbedBuilder _generateInvoiceEmbed(
  Map<String, List<Event>> invoiceData,
  User user,
  DateTime start,
  DateTime end, {
  Member? member,
}) {
  String dotaEventsWorked = '';
  String csEventsWorked = '';
  String otherEventsWorked = '';
  num totalHours = 0;

  final DateFormat dateFormat = DateFormat.yMMMd();

  for (final dotaEvent in invoiceData['Dota']!) {
    dotaEventsWorked +=
        '${dotaEvent.name} at ${dateFormat.format(dotaEvent.time)} - ${dotaEvent.hours} hours\n';

    totalHours += dotaEvent.hours;
  }

  for (final csEvent in invoiceData['CS']!) {
    csEventsWorked +=
        '${csEvent.name} at ${dateFormat.format(csEvent.time)} - ${csEvent.hours} hours\n';

    totalHours += csEvent.hours;
  }

  for (final otherEvent in invoiceData['Other']!) {
    otherEventsWorked +=
        '${otherEvent.name} at ${dateFormat.format(otherEvent.time)} - ${otherEvent.hours} hours\n';

    totalHours += otherEvent.hours;
  }

  return EmbedBuilder(
    color: DiscordColor.parseHexString('0099ff'),
    title:
        '${DateFormat.MMMM().format(start)} - ${DateFormat.MMMM().format(end)}',
    author: EmbedAuthorBuilder(
      name: member?.nick ?? user.globalName ?? user.username,
      iconUrl: member?.avatar?.url ?? user.avatar.url,
    ),
    fields: [
      if (dotaEventsWorked.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Dota',
          value: dotaEventsWorked,
          isInline: false,
        ),
      if (csEventsWorked.isNotEmpty)
        EmbedFieldBuilder(
          name: 'CS',
          value: csEventsWorked,
          isInline: false,
        ),
      if (otherEventsWorked.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Other',
          value: otherEventsWorked,
          isInline: false,
        ),
      EmbedFieldBuilder(
        name: 'Total Hours',
        value: '$totalHours',
        isInline: false,
      )
    ],
    timestamp: DateTime.timestamp(),
  );
}
