part of '../mapbox_maps_flutter.dart';

/// A class representing a cancelable operation or task.
///
/// This can be used to manage operations that may need to be
/// canceled before completion, such as asynchronous tasks or
/// long-running processes.
class AnyCancelable {
  final void Function() cancel;

  AnyCancelable._({required this.cancel});
}

extension on StreamSubscription {
  /// Cancels the subscription and returns a [Cancelable] object.
  AnyCancelable asCancelable() {
    return AnyCancelable._(cancel: cancel);
  }
}
