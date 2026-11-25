part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Starts host operations that the caller can cancel.
///
/// Each operation gets a unique id. The host keeps its native cancel handle
/// under this id, and [CancelableFuture.cancel] sends the id back to the host.
final class CancelableOperations {
  /// Creates an instance that sends cancel requests to [cancelOnHost].
  ///
  /// Use [instance] in the SDK. Operation ids are unique per instance only,
  /// so two instances on one host can cancel each other's operations.
  @visibleForTesting
  CancelableOperations(this._cancelOnHost);

  /// The instance for the host of the root isolate.
  static final CancelableOperations instance = CancelableOperations(
    _CancelableOperationMessenger(
      binaryMessenger: ServicesBinding.instance.defaultBinaryMessenger,
    ).cancel,
  );

  final Future<void> Function(int operationId) _cancelOnHost;
  // Starts from the clock, so ids stay unique across hot restarts while native
  // operations of the previous run can still complete.
  int _nextOperationId = DateTime.now().microsecondsSinceEpoch;

  /// Starts an operation and returns a future that the caller can cancel.
  ///
  /// The operation starts in a later microtask. [prepare] runs first, for
  /// example to set up a progress channel. Then [run] starts the host
  /// operation. A cancel before [run] starts skips the host operation, and the
  /// future fails with a [PlatformException] with code `CANCELED`. A cancel
  /// after [run] starts asks the host to cancel the operation.
  ///
  /// [onDone] runs once when the future completes, fails or is canceled.
  CancelableFuture<T> start<T>({
    Future<void> Function(int operationId)? prepare,
    required Future<T> Function(int operationId) run,
    void Function()? onDone,
  }) {
    final operationId = _nextOperationId++;
    var isCanceled = false;
    var isRunning = false;

    Future<T> execute() async {
      // Lets a cancel in the same synchronous turn skip the host calls.
      await Future<void>.value();
      if (!isCanceled && prepare != null) {
        await prepare(operationId);
      }
      if (isCanceled) {
        throw PlatformException(
          code: 'CANCELED',
          message: 'The operation was canceled.',
        );
      }
      isRunning = true;
      return run(operationId);
    }

    final future = execute().whenComplete(() => onDone?.call());
    return CancelableFuture(future, () {
      isCanceled = true;
      if (isRunning) {
        _cancelOnHost(operationId).catchError((Object _) {});
      }
    });
  }
}
