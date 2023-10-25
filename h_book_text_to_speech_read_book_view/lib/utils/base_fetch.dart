abstract class BaseFetch {
  Stream<dynamic> get stream;
  Future<void> onInit();
  Future<void> onFetch();
  Future<void> onLoadMore();
  Future<void> dispose();
}
