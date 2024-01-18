sealed class EventError {
  const EventError();

  String get message;
}

class DeleteEventError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const DeleteEventError(this.error, this.stackTrace);

  @override
  String get message {
    final message = '$error\n StackTrace:\n $stackTrace';
    return message;
  }
}

class GetEventIdError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const GetEventIdError(this.error, this.stackTrace);

  @override
  String get message {
    final message = '$error\n StackTrace:\n $stackTrace';
    return message;
  }
}

class GetEventsError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const GetEventsError(this.error, this.stackTrace);

  @override
  String get message {
    final message = '$error\n StackTrace:\n $stackTrace';
    return message;
  }
}

class CreateEventError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const CreateEventError(this.error, this.stackTrace);

  @override
  String get message {
    final message = '$error\n StackTrace:\n $stackTrace';
    return message;
  }
}

class EditEventError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const EditEventError(this.error, this.stackTrace);

  @override
  String get message {
    final message = '$error\n StackTrace:\n $stackTrace';
    return message;
  }
}
