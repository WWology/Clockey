import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

ChatGroup manualGroup = ChatGroup(
  'manual',
  'Command for manual Signups',
);

final signUps = ChatCommand(
  'signup',
  'Manually add signups to an event',
  id('signup', (
    InteractionChatContext context, [
    @Description('Gardener to work on the event')
    @Name('gardener1')
    User? gardener1,
    @Description('Gardener to work on the event')
    @Name('gardener2')
    User? gardener2,
    @Description('Gardener to work on the event')
    @Name('gardener3')
    User? gardener3,
    @Description('Gardener to work on the event')
    @Name('gardener4')
    User? gardener4,
  ]) async {
    await context.respond(MessageBuilder(content: 'Not implemented yet'));
    //TODO add manual signup
  }),
);
