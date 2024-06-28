Future<T> retry<T>(int retries, Future<T> Function() function,
    {Duration? delay = const Duration(milliseconds: 500)}) async {
  try {
    return await function();
  } catch (e) {
    if (retries > 1) {
      print("MMM retry");
      if (delay != null) {
        await Future.delayed(delay);
      }
      return retry(retries - 1, function);
    }
    rethrow;
  }
}
