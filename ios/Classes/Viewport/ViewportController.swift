import Foundation
import MapboxMaps
import Flutter
@_implementationOnly import MapboxCommon_Private.MBXLog_Internal

final class ViewportController: _ViewportManagerMessenger {
    private let viewportManager: ViewportManager
    private let binaryMessenger: FlutterBinaryMessenger
    private var stateRegistry: [Int64: ViewportState] = [:]
    private var transitionRegistry: [Int64: ViewportTransition] = [:]

    init(viewportManager: ViewportManager, binaryMessenger: FlutterBinaryMessenger) {
        self.viewportManager = viewportManager
        self.binaryMessenger = binaryMessenger
    }

    func getOptions() throws -> ViewportOptions {
        return viewportManager.options.toFLTOptions()
    }

    func setOptions(options: ViewportOptions) throws {
        viewportManager.options = options.toOptions()
    }

    // MARK: - OverviewViewportState

    func setupOverviewViewportState(options: _OverviewViewportStateOptions, identifier: Int64) throws {
        let state = viewportManager.makeOverviewViewportState(options: options.toOptions())

        stateRegistry[identifier] = state

        let stateController = OverviewViewportStateController(overviewState: state)
        _OverviewViewportMessengerSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: stateController,
            messageChannelSuffix: String(identifier)
        )
    }

    func teardownOverviewViewportState(identifier: Int64) throws {
        stateRegistry[identifier] = nil

        _OverviewViewportMessengerSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: nil,
            messageChannelSuffix: String(identifier)
        )
    }

    // MARK: - FollowPuckViewportState

    func setupFollowPuckViewportState(options: _FollowPuckViewportStateOptions, identifier: Int64) throws {
        let state = viewportManager.makeFollowPuckViewportState(options: options.toOptions())

        stateRegistry[identifier] = state

        let stateController = FollowPuckViewportStateController(state: state)
        _FollowPuckViewportMessengerSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: stateController,
            messageChannelSuffix: String(identifier)
        )
    }

    func teardownFollowPuckViewportState(identifier: Int64) throws {
        stateRegistry[identifier] = nil

        _FollowPuckViewportMessengerSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: nil,
            messageChannelSuffix: String(identifier)
        )
    }

    // MARK: - Built-in transitions

    func setupDefaultTransition(options: _DefaultViewportTransitionOptions, identifier: Int64) throws {
        let transition = viewportManager.makeDefaultViewportTransition(options: options.toOptions())

        transitionRegistry[identifier] = transition

        let transitionController = DefaultViewportTransitionController(transition: transition)
        _DefaultViewportTransitionMessengerSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: transitionController,
            messageChannelSuffix: String(identifier)
        )
    }

    func teardownDefaultTransition(identifier: Int64) throws {
        transitionRegistry[identifier] = nil

        _DefaultViewportTransitionMessengerSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: nil,
            messageChannelSuffix: String(identifier)
        )
    }

    func setupImmediateTransition(identifier: Int64) throws {
        let transition = viewportManager.makeImmediateViewportTransition()

        transitionRegistry[identifier] = transition
    }

    func teardownImmediateTransition(identifier: Int64) throws {
        transitionRegistry[identifier] = nil
    }

    // MARK: - ViewportManager

    func transition(toViewportIdentifier: Int64, transitionIdentifier: Int64?, completionIdentifier: Int64?) throws {
        guard let state = stateRegistry[toViewportIdentifier] else {
            Log.error(forMessage: "No viewport state found for \(toViewportIdentifier)", category: "Viewport")
            return
        }
        let transition: ViewportTransition?
        if let transitionIdentifier {
            transition = transitionRegistry[transitionIdentifier]
            if transition == nil {
                Log.error(forMessage: "No viewport transition found for \(transitionIdentifier)", category: "Viewport")
            }
        } else {
            transition = nil
        }

        viewportManager.transition(to: state, transition: transition) { _ in
            // TODO: pass the message to completion handler
        }
    }
}

extension ViewportOptions {
    func toOptions() -> MapboxMaps.ViewportOptions {
        return .init(transitionsToIdleUponUserInteraction: transitionsToIdleUponUserInteraction)
    }
}

extension MapboxMaps.ViewportOptions {
    func toFLTOptions() -> ViewportOptions {
        return .init(transitionsToIdleUponUserInteraction: transitionsToIdleUponUserInteraction)
    }
}
