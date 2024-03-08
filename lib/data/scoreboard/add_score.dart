import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'scoreboard_errors.dart';

TaskEither<AddScoreError, Unit> addScore(List<int> userIds, String tableName) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();

        for (final id in userIds) {
          await supabase.from(tableName).upsert({'id': id, 'score': 1});
        }
        return unit;
      },
      AddScoreError.new,
    );
