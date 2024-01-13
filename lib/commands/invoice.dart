import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../data/events/events.dart';
import '../templates/templates.dart';

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
          context.respond(
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

          final invoiceHtml = await createHtml(invoiceData, user.id.value);

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
  String rlEventsWorked = '';
  String otherEventsWorked = '';
  String deductions = '';
  int totalHours = 0;

  final DateFormat dateFormat = DateFormat.yMMMd();

  for (final dotaEvent in invoiceData['Dota']!) {
    if (dotaEvent.deductions != null) {
      final int hours = dotaEvent.hours - dotaEvent.deductions![user.id.value]!;
      if (hours > 0) {
        dotaEventsWorked +=
            '${dotaEvent.name} at ${dateFormat.format(dotaEvent.time)} - $hours hours\n';

        totalHours += dotaEvent.hours - dotaEvent.deductions![user.id.value]!;
      }
    } else {
      dotaEventsWorked +=
          '${dotaEvent.name} at ${dateFormat.format(dotaEvent.time)} - ${dotaEvent.hours} hours\n';

      totalHours += dotaEvent.hours;
    }
  }

  for (final csEvent in invoiceData['CS']!) {
    if (csEvent.deductions != null) {
      final int hours = csEvent.hours - csEvent.deductions![user.id.value]!;
      if (hours > 0) {
        csEventsWorked +=
            '${csEvent.name} at ${dateFormat.format(csEvent.time)} - $hours hours\n';

        totalHours += csEvent.hours - csEvent.deductions![user.id.value]!;
      }
    } else {
      csEventsWorked +=
          '${csEvent.name} at ${dateFormat.format(csEvent.time)} - ${csEvent.hours} hours\n';

      totalHours += csEvent.hours;
    }
  }

  for (final rlEvent in invoiceData['RL']!) {
    if (rlEvent.deductions != null) {
      final int hours = rlEvent.hours - rlEvent.deductions![user.id.value]!;
      if (hours > 0) {
        rlEventsWorked +=
            '${rlEvent.name} at ${dateFormat.format(rlEvent.time)} - $hours hours\n';

        totalHours += rlEvent.hours - rlEvent.deductions![user.id.value]!;
      }
    } else {
      rlEventsWorked +=
          '${rlEvent.name} at ${dateFormat.format(rlEvent.time)} - ${rlEvent.hours} hours\n';

      totalHours += rlEvent.hours;
    }
  }

  for (final otherEvent in invoiceData['Other']!) {
    if (otherEvent.deductions != null) {
      final int hours =
          otherEvent.hours - otherEvent.deductions![user.id.value]!;
      if (hours > 0) {
        otherEventsWorked +=
            '${otherEvent.name} at ${dateFormat.format(otherEvent.time)} - $hours hours\n';

        totalHours += otherEvent.hours - otherEvent.deductions![user.id.value]!;
      }
    } else {
      otherEventsWorked +=
          '${otherEvent.name} at ${dateFormat.format(otherEvent.time)} - ${otherEvent.hours} hours\n';

      totalHours += otherEvent.hours;
    }
  }

  for (final deduction in invoiceData['Deductions']!) {
    deductions +=
        '${deduction.name} at ${dateFormat.format(deduction.time)} - ${deduction.deductions![user.id.value]!} hours \n';
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
      if (rlEventsWorked.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Rocket League',
          value: rlEventsWorked,
          isInline: false,
        ),
      if (otherEventsWorked.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Other',
          value: otherEventsWorked,
          isInline: false,
        ),
      if (deductions.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Deductions',
          value: deductions,
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
