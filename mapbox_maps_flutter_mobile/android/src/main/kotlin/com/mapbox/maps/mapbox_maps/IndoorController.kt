package com.mapbox.maps.mapbox_maps

import com.mapbox.common.Cancelable
import com.mapbox.maps.IndoorFloor
import com.mapbox.maps.IndoorManager
import com.mapbox.maps.IndoorState
import com.mapbox.maps.MapboxExperimental
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.pigeons.IndoorUpdatesStreamHandler
import com.mapbox.maps.mapbox_maps.pigeons.PigeonEventSink
import com.mapbox.maps.mapbox_maps.pigeons._IndoorMessenger
import io.flutter.plugin.common.BinaryMessenger

@OptIn(MapboxExperimental::class)
class IndoorController(
  private val mapboxMap: MapboxMap,
  messenger: BinaryMessenger,
  channelSuffix: String,
) : _IndoorMessenger {

  private var sink: PigeonEventSink<com.mapbox.maps.mapbox_maps.pigeons.IndoorState>? = null
  private var lastState =
    com.mapbox.maps.mapbox_maps.pigeons.IndoorState(floors = emptyList(), selectedFloorId = null)
  private var cancelable: Cancelable? = null

  init {
    val streamHandler = object : IndoorUpdatesStreamHandler() {
      override fun onListen(p0: Any?, sink: PigeonEventSink<com.mapbox.maps.mapbox_maps.pigeons.IndoorState>) {
        this@IndoorController.sink = sink
        sink.success(lastState)
      }

      override fun onCancel(p0: Any?) {
        sink = null
      }
    }
    IndoorUpdatesStreamHandler.register(messenger, streamHandler, channelSuffix)

    cancelable = mapboxMap.indoor.subscribeOnIndoorUpdated(object : IndoorManager.OnIndoorUpdatedCallback {
      override fun onIndoorUpdated(onIndoorUpdated: IndoorState) {
        lastState = onIndoorUpdated.toFLT()
        sink?.success(lastState)
      }
    })
  }

  override fun selectFloor(floorId: String?) {
    mapboxMap.indoor.selectFloor(floorId)
  }

  fun dispose() {
    cancelable?.cancel()
    cancelable = null
    sink = null
  }
}

private fun IndoorState.toFLT() = com.mapbox.maps.mapbox_maps.pigeons.IndoorState(
  floors = floors.map { it.toFLT() },
  selectedFloorId = selectedFloorId.takeUnless { it.isEmpty() },
)

private fun IndoorFloor.toFLT() = com.mapbox.maps.mapbox_maps.pigeons.IndoorFloor(id = id, name = name)