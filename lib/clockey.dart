import 'package:cron/cron.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:supabase/supabase.dart';

import 'commands/commands.dart';
import 'env.dart';

void run() async {
  GetIt.I.registerSingleton<SupabaseClient>(
      SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey));
  GetIt.I.registerSingleton<logger.Logger>(logger.Logger());
  final browser = await puppeteer.launch();
  GetIt.I.registerSingleton<Browser>(browser);
  final commands = registerCommand();
  final client = await Nyxx.connectGateway(
    Env.clockeyToken,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [
      logging,
      cliIntegration,
      commands,
      pagination,
    ]),
  );

  Hive.init('./hive_boxes');
  await openHiveBoxes();
  client.onReady.listen((event) async {
    print('Clockey Ready ⏰');
  });

  pagination.onDisallowedUse.listen((event) async {
    await event.interaction.respond(
      MessageBuilder(content: "Only user of the command can use the buttons"),
      isEphemeral: true,
    );
  });
}

CommandsPlugin registerCommand() {
  final commands = CommandsPlugin(
    prefix: null,
    guild: Snowflake(Env.guildId),
    options: CommandsOptions(logErrors: true),
  );
  // Signup Commands
  commands.addCommand(cancel);
  commands.addCommand(editGroup);
  commands.addCommand(event);
  commands.addCommand(gardener);
  commands.addCommand(idCommand);
  commands.addCommand(invoice);
  commands.addCommand(manualGroup);

  // Prediction commands
  commands.addCommand(dotaBo);
  commands.addCommand(csBo);
  commands.addCommand(rlBo);
  commands.addCommand(deleteDota);
  commands.addCommand(deleteCS);
  commands.addCommand(deleteRL);
  commands.addCommand(clearCache);

  // General Commands
  commands.addCommand(giveaway);
  commands.addCommand(nextGameGroup);
  commands.addCommand(ping);
  commands.addCommand(showGroup);

  return commands;
}

void startCronJobs() {
  final cron = Cron();

  cron.schedule(Schedule.parse('*/5 * * * *'), () {
    // TODO run scheduled signups for RL
  });
}

Future<void> openHiveBoxes() async {
  await Hive.openBox<int>('dotaBox');
  await Hive.openBox<int>('csBox');
  await Hive.openBox<int>('rlBox');
}
