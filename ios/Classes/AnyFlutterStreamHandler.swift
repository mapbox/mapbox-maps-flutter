import Flutter

final class AnyFlutterStreamHandler: NSObject, FlutterStreamHandler {
    private(set) var eventSink: FlutterEventSink?
    var onCancelled: (() -> Void)?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = { value in
            DispatchQueue.main.async {
                events(value)
            }
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        onCancelled?()
        onCancelled = nil
        return nil
    }
}
