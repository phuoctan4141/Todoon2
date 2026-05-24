enum RepositoryEventType {
  add,
  update,
  delete,
  get,
  syncStarted,
  syncCompleted,
  syncFailed,
}

class RepositoryEvents<T> {
  final RepositoryEventType type;
  final DateTime timestamp;
  final String? message;

  RepositoryEvents({required this.type, DateTime? timestamp, this.message})
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'RepositoryEvents(type: $type, timestamp: $timestamp, message: $message)';
}

abstract class BaseRepository<T> {
  Stream<RepositoryEvents<T>> get eventStream;

  void dispatchEvent(RepositoryEvents<T> event);

  void dispose();
}
