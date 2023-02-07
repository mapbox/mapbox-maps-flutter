package com.mapbox.maps.mapbox_maps

import io.flutter.plugin.common.BinaryMessenger
import java.nio.ByteBuffer

// BinaryMessenger that proxies all calls to another BinaryMessenger,
// but with a suffix appended to the channel name.
// Different map instances use different suffixes to avoid channel name conflicts.
class ProxyBinaryMessenger(
  private val messenger: BinaryMessenger,
  private val nameSuffix: String,
) : BinaryMessenger {

  override fun send(channel: String, message: ByteBuffer?) {
    messenger.send("$channel$nameSuffix", message)
  }

  override fun send(channel: String, message: ByteBuffer?, callback: BinaryMessenger.BinaryReply?) {
    messenger.send("$channel$nameSuffix", message, callback)
  }

  override fun setMessageHandler(channel: String, handler: BinaryMessenger.BinaryMessageHandler?) {
    messenger.setMessageHandler("$channel$nameSuffix", handler)
  }
}