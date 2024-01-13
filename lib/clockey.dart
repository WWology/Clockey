import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

import 'commands/commands.dart';
import 'env.dart';

void run() async {
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
      options: CommandsOptions(logErrors: true));
  commands.addCommand(cancel);
  commands.addCommand(event);
  commands.addCommand(gardener);
  commands.addCommand(giveaway);
  commands.addCommand(invoice);
  commands.addCommand(manualGroup);
  commands.addCommand(ping);

  return commands;
}
