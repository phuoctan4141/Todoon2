abstract class BaseLocalDataSource<T> {
  Future<List<T>> getAll();
  Future<void> put(T item);
  Future<void> softDelete(String uid);
  Future<List<T>> getUnsynced();
}
