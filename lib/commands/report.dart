import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import '../data/events/events.dart';

final report = ChatCommand(
  'report',
  'Budget Report for Gardeners',
  options: CommandOptions(defaultResponseLevel: ResponseLevel.hint),
  id('report', (
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
    if (DateTime.tryParse(startDate) == null) {
      await context.respond(
        MessageBuilder(
          content: 'Start date format is invalid, please use YYYY-MM-DD',
        ),
      );
    }
    final start = DateTime.parse(startDate);

    late final DateTime end;
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

    getReport(start: start, end: end).match(
      (error) {
        GetIt.I.get<logger.Logger>().e(error.message, error: error);
        context.respond(
          MessageBuilder(
            content:
                'Something wrong has happened while generating report, please try again',
          ),
        );
      },
      (events) async {},
    ).run();
  }),
);

EmbedBuilder _generateReportEmbed(
  Map<String, List<Event>> invoiceData,
  User user,
  DateTime start,
  DateTime end, {
  Member? member,
}) {
  String dotaEvents = '';
  String csEvents = '';
  String rlEvents = '';
  String otherEvents = '';
  String deductions = '';
  int totalHours = 0;

  final DateFormat dateFormat = DateFormat.yMMMd();

  for (final dotaEvent in invoiceData['Dota']!) {
    dotaEvents +=
        '${dotaEvent.name} at ${dateFormat.format(dotaEvent.time)} - ${dotaEvent.hours} hours\n';

    totalHours += dotaEvent.hours;
  }

  for (final csEvent in invoiceData['CS']!) {
    csEvents +=
        '${csEvent.name} at ${dateFormat.format(csEvent.time)} - ${csEvent.hours} hours\n';

    totalHours += csEvent.hours;
  }

  for (final rlEvent in invoiceData['RL']!) {
    rlEvents +=
        '${rlEvent.name} at ${dateFormat.format(rlEvent.time)} - ${rlEvent.hours} hours\n';

    totalHours += rlEvent.hours;
  }

  for (final otherEvent in invoiceData['Other']!) {
    otherEvents +=
        '${otherEvent.name} at ${dateFormat.format(otherEvent.time)} - ${otherEvent.hours} hours\n';

    totalHours += otherEvent.hours;
  }

  for (final deduction in invoiceData['Deductions']!) {
    deductions +=
        '${deduction.name} at ${dateFormat.format(deduction.time)} - ${deduction.deductions![user.id.value]!} hours \n';

    totalHours -= deduction.hours;
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
      if (dotaEvents.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Dota',
          value: dotaEvents,
          isInline: false,
        ),
      if (csEvents.isNotEmpty)
        EmbedFieldBuilder(
          name: 'CS',
          value: csEvents,
          isInline: false,
        ),
      if (rlEvents.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Rocket League',
          value: rlEvents,
          isInline: false,
        ),
      if (otherEvents.isNotEmpty)
        EmbedFieldBuilder(
          name: 'Other',
          value: otherEvents,
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
