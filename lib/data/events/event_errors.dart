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

class AddGardenerEventError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const AddGardenerEventError(this.error, this.stackTrace);
}

class RemoveGardenerEventError extends EventError {
  final Object error;
  final StackTrace stackTrace;
  const RemoveGardenerEventError(this.error, this.stackTrace);
}
