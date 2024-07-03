import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as logger;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

final dotaBo = ChatCommand(
  'dotabo',
  'Create Dota roles',
  id(
    'dotabo',
    (
      InteractionChatContext context,
      @Name('series_length') int seriesLength,
    ) async {
      await context.acknowledge();

      final roleManager = context.guild!.roles;

      if (seriesLength == 1) {
        try {
          final rolesToBeCreated = [
            'D1-0',
            'D0-1',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a Dota Bo1'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 2) {
        try {
          final rolesToBeCreated = [
            'D2-0',
            'D1-1',
            'D0-2',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a Dota Bo2'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 3) {
        try {
          final rolesToBeCreated = [
            'D2-0',
            'D2-1',
            'D1-2',
            'D0-2',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a Dota Bo3'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 5) {
        try {
          final rolesToBeCreated = [
            'D3-0',
            'D3-1',
            'D3-2',
            'D2-3',
            'D1-3',
            'D0-3',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a Dota Bo5'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }
    },
  ),
);

final csBo = ChatCommand(
  'csbo',
  'Create CS roles',
  id(
    'csbo',
    (
      InteractionChatContext context,
      @Name('series_length') int seriesLength,
    ) async {
      await context.acknowledge();

      final roleManager = context.guild!.roles;

      if (seriesLength == 1) {
        try {
          final rolesToBeCreated = [
            'CS1-0',
            'CS0-1',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a CS Bo1'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 2) {
        try {
          final rolesToBeCreated = [
            'CS2-0',
            'CS1-1',
            'CS0-2',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a CS Bo2'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 3) {
        try {
          final rolesToBeCreated = [
            'CS2-0',
            'CS2-1',
            'CS1-2',
            'CS0-2',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a CS Bo3'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 5) {
        try {
          final rolesToBeCreated = [
            'CS3-0',
            'CS3-1',
            'CS3-2',
            'CS2-3',
            'CS1-3',
            'CS0-3',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a CS Bo5'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }
    },
  ),
);

final rlBo = ChatCommand(
  'rlbo',
  'Create RL roles',
  id(
    'rlbo',
    (
      InteractionChatContext context,
      @Name('series_length') int seriesLength,
    ) async {
      await context.acknowledge();

      final roleManager = context.guild!.roles;

      if (seriesLength == 1) {
        try {
          final rolesToBeCreated = [
            'RL1-0',
            'RL0-1',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a RL Bo1'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 2) {
        try {
          final rolesToBeCreated = [
            'RL2-0',
            'RL1-1',
            'RL0-2',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a RL Bo2'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 3) {
        try {
          final rolesToBeCreated = [
            'RL2-0',
            'RL2-1',
            'RL1-2',
            'RL0-2',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a RL Bo3'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 5) {
        try {
          final rolesToBeCreated = [
            'RL3-0',
            'RL3-1',
            'RL3-2',
            'RL2-3',
            'RL1-3',
            'RL0-3',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a RL Bo5'),
          );
        } catch (error) {
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 7) {
        try {
          final rolesToBeCreated = [
            'RL4-0',
            'RL4-1',
            'RL4-2',
            'RL4-3',
            'RL3-4',
            'RL2-4',
            'RL1-4',
            'RL0-4',
          ];

          for (final roleName in rolesToBeCreated) {
            await roleManager.create(RoleBuilder(name: roleName));
          }

          await context.respond(
            MessageBuilder(content: 'I have created roles for a RL Bo7'),
          );
        } catch (error) {
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }
    },
  ),
);

final deleteDota = ChatCommand(
  'deletedota',
  'Delete Dota roles for prediction',
  id(
    'deletedota',
    (
      InteractionChatContext context,
      @Name('series_length') int seriesLength,
    ) async {
      await context.acknowledge();
      final roleManager = context.guild!.roles;

      if (seriesLength == 1) {
        try {
          final rolesToBeDeleted = [
            'D1-0',
            'D0-1',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a Dota Bo1'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 2) {
        try {
          final rolesToBeDeleted = [
            'D2-0',
            'D1-1',
            'D0-2',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a Dota Bo2'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 3) {
        try {
          final rolesToBeDeleted = [
            'D2-0',
            'D2-1',
            'D1-2',
            'D0-2',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a Dota Bo3'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 5) {
        try {
          final rolesToBeDeleted = [
            'D3-0',
            'D3-1',
            'D3-2',
            'D2-3',
            'D1-3',
            'D0-3',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a Dota Bo5'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }
    },
  ),
);

final deleteCS = ChatCommand(
  'deletecs',
  'Delete CS roles for prediction',
  id(
    'deletecs',
    (
      InteractionChatContext context,
      @Name('series_length') int seriesLength,
    ) async {
      await context.acknowledge();
      final roleManager = context.guild!.roles;

      if (seriesLength == 1) {
        try {
          final rolesToBeDeleted = [
            'CS1-0',
            'CS0-1',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a CS Bo1'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 2) {
        try {
          final rolesToBeDeleted = [
            'CS2-0',
            'CS1-1',
            'CS0-2',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a CS Bo2'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 3) {
        try {
          final rolesToBeDeleted = [
            'CS2-0',
            'CS2-1',
            'CS1-2',
            'CS0-2',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a CS Bo3'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 5) {
        try {
          final rolesToBeDeleted = [
            'CS3-0',
            'CS3-1',
            'CS3-2',
            'CS2-3',
            'CS1-3',
            'CS0-3',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a CS Bo5'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }
    },
  ),
);

final deleteRL = ChatCommand(
  'deleterl',
  'Delete RL roles for prediction',
  id(
    'deleterl',
    (
      InteractionChatContext context,
      @Name('series_length') int seriesLength,
    ) async {
      await context.acknowledge();
      final roleManager = context.guild!.roles;

      if (seriesLength == 1) {
        try {
          final rolesToBeDeleted = [
            'RL1-0',
            'RL0-1',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a RL Bo1'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 2) {
        try {
          final rolesToBeDeleted = [
            'RL2-0',
            'RL1-1',
            'RL0-2',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a RL Bo2'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 3) {
        try {
          final rolesToBeDeleted = [
            'RL2-0',
            'RL2-1',
            'RL1-2',
            'RL0-2',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a RL Bo3'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 5) {
        try {
          final rolesToBeDeleted = [
            'RL3-0',
            'RL3-1',
            'RL3-2',
            'RL2-3',
            'RL1-3',
            'RL0-3',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a RL Bo5'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }

      if (seriesLength == 7) {
        try {
          final rolesToBeDeleted = [
            'RL4-0',
            'RL4-1',
            'RL4-2',
            'RL4-3',
            'RL3-4',
            'RL2-4',
            'RL1-4',
            'RL0-4',
          ];

          final List<Snowflake> roleIds = [];

          for (final role in roleManager.cache.values) {
            if (rolesToBeDeleted.contains(role.name)) {
              roleIds.add(role.id);
            }
          }

          for (final roleId in roleIds) {
            await roleManager.delete(roleId);
          }

          await context.respond(
            MessageBuilder(content: 'Deleted the roles for a RL Bo7'),
          );
        } catch (error) {
          GetIt.I.get<logger.Logger>().e(error);
          await context.respond(
            MessageBuilder(
              content: 'Something wrong has occured, please try again',
            ),
          );
        }
      }
    },
  ),
);
