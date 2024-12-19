import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:supabase/supabase.dart';

import 'commands/commands.dart';
import 'env.dart';

void run() async {
  try {
    // Register Supabase
    GetIt.I.registerSingleton<SupabaseClient>(
        SupabaseClient(Env.supabaseUrl, Env.supabaseApiKey));
    GetIt.I.registerSingleton<logger.Logger>(logger.Logger());

    // Register Command
    final commands = registerCommand();

    // Start the bot
    final client = await Nyxx.connectGateway(
      Env.clockeyToken,
      GatewayIntents.allPrivileged,
      options: GatewayClientOptions(plugins: [
        logging,
        cliIntegration,
        commands,
        pagination,
        // GameChecker(),
      ]),
    );

    client.onReady.listen((event) async {
      print('events Ready ⏰');
    });

    pagination.onDisallowedUse.listen((event) async {
      await event.interaction.respond(
        MessageBuilder(content: "Only user of the command can use the buttons"),
        isEphemeral: true,
      );
    });
  } catch (error) {
    GetIt.I.get<logger.Logger>().e(error);
  }
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
  commands.addCommand(dotaAdd);
  commands.addCommand(csAdd);
  commands.addCommand(rlAdd);

  // General Commands
  commands.addCommand(playerBirthday);
  commands.addCommand(giveaway);
  commands.addCommand(nextGameGroup);
  commands.addCommand(ping);
  commands.addCommand(showGroup);

  return commands;
}
