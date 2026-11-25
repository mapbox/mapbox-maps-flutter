import 'dart:async';

/// A class representing a cancelable operation or task.
///
/// This can be used to manage operations that may need to be
/// canceled before completion, such as asynchronous tasks or
/// long-running processes.
class Cancelable {
  final void Function() _cancel;

  Cancelable._(this._cancel);

  void cancel() {
    _cancel();
  }
}

extension AsCancelable on StreamSubscription {
  /// Cancels the subscription and returns a [Cancelable] object.
  Cancelable asCancelable() {
    return Cancelable._(cancel);
  }
}

/// A [Future] for an operation that you can cancel.
///
/// Await it or use it as a [Future]. Call [cancel] to stop the operation
/// before it completes.
class CancelableFuture<T> implements Future<T>, Cancelable {
  final Future<T> _future;
  final void Function() _onCancel;
  bool _isDone = false;
  bool _isCanceled = false;

  /// Creates a [CancelableFuture] that completes with [future].
  ///
  /// [onCancel] runs on the first call to [cancel], and only if [future]
  /// is not complete.
  CancelableFuture(Future<T> future, void Function() onCancel)
    : _future = future,
      _onCancel = onCancel {
    _future.then<void>((_) => _isDone = true, onError: (_) => _isDone = true);
  }

  @override
  void Function() get _cancel => cancel;

  /// Requests cancellation of the operation.
  ///
  /// Calls after the first call, or after the operation completes, do nothing.
  @override
  void cancel() {
    if (_isDone || _isCanceled) return;
    _isCanceled = true;
    _onCancel();
  }

  @override
  Stream<T> asStream() => _future.asStream();

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) =>
      _future.catchError(onError, test: test);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) => _future.then(onValue, onError: onError);

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      _future.whenComplete(action);
}
