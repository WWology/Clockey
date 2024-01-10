sealed class EventError {
  const EventError();
}

class DeleteEventError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const DeleteEventError(this.error, this.stackTrace);
}

class GetEventIdError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const GetEventIdError(this.error, this.stackTrace);
}

class GetEventsError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const GetEventsError(this.error, this.stackTrace);
}

class CreateEventError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const CreateEventError(this.error, this.stackTrace);
}
