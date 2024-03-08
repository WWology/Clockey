sealed class ScoreboardError {
  const ScoreboardError();

  String get message;
}

class ShowScoreboardError extends ScoreboardError {
  final Object error;
  final StackTrace stackTrace;
  const ShowScoreboardError(this.error, this.stackTrace);

  @override
  String get message {
    final message = '$error\n Stacktrace:\n $stackTrace';
    return message;
  }
}

class AddScoreError extends ScoreboardError {
  final Object error;
  final StackTrace stackTrace;
  const AddScoreError(this.error, this.stackTrace);

  @override
  String get message {
    final message = '$error\n Stacktrace:\n $stackTrace';
    return message;
  }
}
