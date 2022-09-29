import Foundation

protocol QueryDebouncerDelegate: AnyObject {
    func queryDebouncer(_ debouncer: QueryDebouncer, didUpdateQuery query: String)
}

final class QueryDebouncer {

    var query: String {
        didSet {
            delegate?.queryDebouncer(self, didUpdateQuery: query)
        }
    }
    let delay: TimeInterval
    weak var delegate: QueryDebouncerDelegate?
    private weak var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }

    init(query: String, delay: TimeInterval) {
        self.query = query
        self.delay = delay
    }

    deinit {
        timer?.invalidate()
    }

    func updateQuery(_ value: String) {
        timer = Timer.scheduledTimer(
            timeInterval: delay,
            target: self,
            selector: #selector(processUpdate),
            userInfo: value,
            repeats: false)
    }

    @objc private func processUpdate(_ timer: Timer) {
        query = timer.userInfo as! String
    }
}
