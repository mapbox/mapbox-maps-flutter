import Flutter

final class AnyFlutterStreamHandler: NSObject, FlutterStreamHandler {
    private(set) var eventSink: FlutterEventSink?
    private let onCancel: (() -> Void)?

    /// Creates a handler. `onCancel` runs when the Dart side stops listening.
    init(onCancel: (() -> Void)? = nil) {
        self.onCancel = onCancel
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // Send on the main thread without an extra hop, so that events keep
        // their order relative to other main-thread messages, such as replies.
        eventSink = { value in
            if Thread.isMainThread {
                events(value)
            } else {
                DispatchQueue.main.async {
                    events(value)
                }
            }
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        onCancel?()
        return nil
    }
}
