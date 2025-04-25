part of '../mapbox_maps_flutter.dart';

/// A class representing a cancelable operation or task.
///
/// This can be used to manage operations that may need to be
/// canceled before completion, such as asynchronous tasks or
/// long-running processes.
class Cancelable {
  final void Function() cancel;

  Cancelable._({required this.cancel});
}

extension on StreamSubscription {
  /// Cancels the subscription and returns a [Cancelable] object.
  Cancelable asCancelable() {
    return Cancelable._(cancel: cancel);
  }
}
