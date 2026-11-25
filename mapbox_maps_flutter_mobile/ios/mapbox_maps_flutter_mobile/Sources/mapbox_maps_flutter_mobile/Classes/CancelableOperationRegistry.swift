import Flutter
import MapboxCommon

/// Keeps the native `Cancelable` of each running offline operation by its operation id.
/// Use this class only on the main thread.
final class CancelableOperationRegistry: _CancelableOperationMessenger {
    private var cancelables: [Int64: Cancelable] = [:]

    func register(operationId: Int64, cancelable: Cancelable) {
        cancelables[operationId] = cancelable
    }

    func unregister(operationId: Int64) {
        cancelables.removeValue(forKey: operationId)
    }

    /// Cancels the operation. An unknown or completed id has no effect.
    func cancel(operationId: Int64) throws {
        cancelables.removeValue(forKey: operationId)?.cancel()
    }

    /// Cancels all running operations.
    func cancelAll() {
        let pending = Array(cancelables.values)
        cancelables.removeAll()
        pending.forEach { $0.cancel() }
    }
}
