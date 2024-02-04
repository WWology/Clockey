import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:supabase/supabase.dart';
import 'package:cron/cron.dart';

import 'commands/commands.dart';
import 'env.dart';

void run() async {
  GetIt.I.registerSingleton<SupabaseClient>(
      SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey));
  GetIt.I.registerSingleton<logger.Logger>(logger.Logger());
  final commands = registerCommand();
  final client = await Nyxx.connectGateway(
    Env.clockeyToken,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration, commands]),
  );

  client.onReady.listen((event) async {
    print('Clockey Ready ⏰');
  });
}

CommandsPlugin registerCommand() {
  final commands = CommandsPlugin(
    prefix: null,
    guild: Snowflake(Env.guildId),
    options: CommandsOptions(logErrors: true),
  );
  commands.addCommand(cancel);
  commands.addCommand(editGroup);
  commands.addCommand(event);
  commands.addCommand(gardener);
  commands.addCommand(giveaway);
  commands.addCommand(idCommand);
  commands.addCommand(invoice);
  commands.addCommand(manualGroup);
  commands.addCommand(ping);

  return commands;
}

void startCronJobs() {
  final cron = Cron();

  cron.schedule(Schedule.parse('*/5 * * * *'), () {
    // TODO run scheduled signups for RL
  });
}
