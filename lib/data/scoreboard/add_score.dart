import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'scoreboard_errors.dart';

TaskEither<AddScoreError, Unit> addScore(List<int> userIds, String type) =>
    TaskEither.tryCatch(
      () async {
        late final String rpc;
        final supabase = GetIt.I.get<SupabaseClient>();

        switch (type) {
          case 'Dota':
            rpc = 'add_dota';
            break;
          case 'CS':
            rpc = 'add_cs';
            break;
          case 'RL':
            rpc = 'add_rl';
            break;
        }

        for (final id in userIds) {
          await supabase.rpc(
            rpc,
            params: {
              'member_id': id,
            },
          );
        }
        return unit;
      },
      AddScoreError.new,
    );
