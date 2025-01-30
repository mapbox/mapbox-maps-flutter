import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class InteractionsController {
    private var cancelables = [String: AnyCancelable]()
    private let mapboxMap: MapboxMap

    init(withMapView mapView: MapView) {
        self.mapboxMap = mapView.mapboxMap
    }

    func addInteraction(messenger: SuffixBinaryMessenger, methodCall: FlutterMethodCall) {
        let listener = _InteractionsListener(binaryMessenger: messenger.messenger, messageChannelSuffix: messenger.suffix)
        guard let arguments = methodCall.arguments as? [String: Any],
              let interactionsList = arguments["interaction"] as? [Any?],
              let interaction = _InteractionPigeon.fromList(interactionsList),
              let featuresetDescriptor = FeaturesetDescriptor.fromList(interaction.featuresetDescriptor),
              let interactionType = _InteractionType.fromString(interaction.interactionType) else {
            return
        }
        let id = interaction.identifier
        let stopPropagation = interaction.stopPropagation
        let filterExpression = try? interaction.filter.flatMap { try $0.toExp() }
        let radius: CGFloat? = interaction.radius.flatMap { CGFloat($0) }

        switch interactionType {
        case .tAP:
            let cancelable = mapboxMap.addInteraction(
                TapInteraction(featuresetDescriptor.toMapFeaturesetDescriptor(), filter: filterExpression, radius: radius, action: { featuresetFeature, context in
                    listener.onInteraction(context: context.toFLTMapContentGestureContext(), feature: featuresetFeature.toFLTFeaturesetFeature(), interactionID: id) { _ in }
                    return stopPropagation
                })
            )
            cancelables[interaction.identifier] = AnyCancelable(cancelable)
        case .lONGTAP:
            let cancelable = mapboxMap.addInteraction(
                LongPressInteraction(featuresetDescriptor.toMapFeaturesetDescriptor(), filter: filterExpression, radius: radius, action: { featuresetFeature, context in
                    listener.onInteraction(context: context.toFLTMapContentGestureContext(), feature: featuresetFeature.toFLTFeaturesetFeature(), interactionID: id) { _ in }
                    return stopPropagation
                })
            )
            cancelables[interaction.identifier] = AnyCancelable(cancelable)
        }
    }

    func removeInteraction(methodCall: FlutterMethodCall) {
        guard let arguments = methodCall.arguments as? [String: Any],
            let interactionIdentifier = arguments["identifier"] as? String else {
            return
        }

        cancelables[interactionIdentifier]?.cancel()
        cancelables.removeValue(forKey: interactionIdentifier)
    }
}
