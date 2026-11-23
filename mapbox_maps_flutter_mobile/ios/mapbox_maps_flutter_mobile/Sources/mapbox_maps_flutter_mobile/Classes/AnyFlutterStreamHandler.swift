import Flutter

final class AnyFlutterStreamHandler: NSObject, FlutterStreamHandler {
    private(set) var eventSink: FlutterEventSink?

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
        return nil
    }
}
