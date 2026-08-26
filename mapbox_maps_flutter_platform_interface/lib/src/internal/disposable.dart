/// Anything that holds resources requiring an explicit cleanup signal.
abstract interface class Disposable {
  void dispose();
}

/// A collection of [Disposable]s disposed together.
final class DisposeBag implements Disposable {
  final _items = <Disposable>[];

  void add(Disposable item) => _items.add(item);

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    _items.clear();
  }
}

extension AddToDisposeBag<T extends Disposable> on T {
  /// Registers this disposable with [bag] and returns it, so the call
  /// can be chained inline (e.g. `LocationController(map).addToDisposeBag(bag)`).
  T addToDisposeBag(DisposeBag bag) {
    bag.add(this);
    return this;
  }
}
