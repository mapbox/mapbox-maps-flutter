package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.common.Cancelable
import com.mapbox.maps.ClickInteraction
import com.mapbox.maps.LongClickInteraction
import com.mapbox.maps.MapboxExperimental
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.extension.style.expressions.generated.Expression
import com.mapbox.maps.mapbox_maps.pigeons._InteractionPigeon
import com.mapbox.maps.mapbox_maps.pigeons._InteractionType
import com.mapbox.maps.mapbox_maps.pigeons._InteractionsListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall

class InteractionsController(private val mapboxMap: MapboxMap, private var context: Context) {
  private var cancelables = HashMap<String, Cancelable?>()

  @OptIn(MapboxExperimental::class)
  fun addInteraction(messenger: BinaryMessenger, channelSuffix: String, call: MethodCall) {
    val listener = _InteractionsListener(messenger, channelSuffix)
    val arguments: HashMap<String, Any> = call.arguments as? HashMap<String, Any> ?: return
    val interactionList = arguments["interaction"] as? List<Any?> ?: return
    val interaction = _InteractionPigeon.fromList(interactionList)
    val featuresetDescriptor = interaction.featuresetDescriptor?.let {
      com.mapbox.maps.mapbox_maps.pigeons.FeaturesetDescriptor.fromList(it)
    }
    val interactionType = _InteractionType.valueOf(interaction.interactionType)
    val stopPropagation = interaction.stopPropagation
    val id = interaction.identifier
    val filter = interaction.filter?.let { Expression.fromRaw(it) }
    val radius = interaction.radius

    // If there is a featuresetDescriptor add the interaction to that feature, including filter and radius if present
    val cancelable = if (featuresetDescriptor != null) {
      featuresetDescriptor.featuresetId?.let {
        when (interactionType) {
          _InteractionType.TAP -> mapboxMap.addInteraction(
            ClickInteraction.featureset(
              id = it,
              importId = featuresetDescriptor.importId,
              filter = filter,
              radius = radius
            ) { featuresetFeature, interactionContext ->
              listener.onInteraction(
                featuresetFeature.toFLTFeaturesetFeature(),
                interactionContext.toFLTMapContentGestureContext(context),
                id
              ) { _ -> }
              return@featureset stopPropagation
            }
          )

          _InteractionType.LONG_TAP -> mapboxMap.addInteraction(
            LongClickInteraction.featureset(
              id = it,
              importId = featuresetDescriptor.importId,
              filter = filter,
              radius = radius
            ) { featuresetFeature, interactionContext ->
              listener.onInteraction(
                featuresetFeature.toFLTFeaturesetFeature(),
                interactionContext.toFLTMapContentGestureContext(context),
                id
              ) { _ -> }
              return@featureset stopPropagation
            }
          )
        }
      } ?: featuresetDescriptor.layerId?.let {
        when (interactionType) {
          _InteractionType.TAP -> mapboxMap.addInteraction(
            ClickInteraction.layer(
              id = it,
              filter = filter,
              radius = radius
            ) { featuresetFeature, interactionContext ->
              listener.onInteraction(
                featuresetFeature.toFLTFeaturesetFeature(),
                interactionContext.toFLTMapContentGestureContext(context),
                id
              ) { _ -> }
              return@layer stopPropagation
            }
          )

          _InteractionType.LONG_TAP -> mapboxMap.addInteraction(
            LongClickInteraction.layer(
              id = it,
              filter = filter,
              radius = radius
            ) { featuresetFeature, interactionContext ->
              listener.onInteraction(
                featuresetFeature.toFLTFeaturesetFeature(),
                interactionContext.toFLTMapContentGestureContext(context),
                id
              ) { _ -> }
              return@layer stopPropagation
            }
          )
        }
      }
      // Otherwise add interactions to the whole map view
    } else {
      when (interactionType) {
        _InteractionType.TAP -> mapboxMap.addInteraction(
          ClickInteraction { interactionContext ->
            listener.onInteraction(null, interactionContext.toFLTMapContentGestureContext(context), id) { _ -> }
            return@ClickInteraction stopPropagation
          }
        )

        _InteractionType.LONG_TAP -> mapboxMap.addInteraction(
          LongClickInteraction { interactionContext ->
            listener.onInteraction(null, interactionContext.toFLTMapContentGestureContext(context), id) { _ -> }
            return@LongClickInteraction stopPropagation
          }
        )
      }
    }
    cancelables[id] = cancelable
  }

  fun removeInteraction(call: MethodCall) {
    val arguments: HashMap<String, Any> = call.arguments as? HashMap<String, Any> ?: return
    val interactionIdentifier = arguments["identifier"] as? String ?: return

    cancelables[interactionIdentifier]?.cancel()
    cancelables.remove(interactionIdentifier)
  }
}