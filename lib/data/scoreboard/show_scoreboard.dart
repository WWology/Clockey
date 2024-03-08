import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase/supabase.dart';

import 'score.dart';
import 'scoreboard_errors.dart';

typedef Scoreboard = List<Score>;
TaskEither<ScoreboardError, Scoreboard> getScores(
  String tableName,
) =>
    TaskEither.tryCatch(
      () async {
        final supabase = GetIt.I.get<SupabaseClient>();
        final scores = await supabase
            .from(tableName)
            .select()
            .order('score', ascending: false)
            .withConverter((scores) => scores.map(Score.fromJson).toList());
        return scores;
      },
      ShowScoreboardError.new,
    );
