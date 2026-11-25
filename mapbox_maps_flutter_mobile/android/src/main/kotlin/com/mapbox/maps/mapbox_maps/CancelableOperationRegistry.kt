package com.mapbox.maps.mapbox_maps

import com.mapbox.common.Cancelable
import com.mapbox.maps.mapbox_maps.pigeons._CancelableOperationMessenger

/**
 * Holds the native [Cancelable] of each running offline operation, keyed by operation id.
 * Use it on the main thread only.
 */
class CancelableOperationRegistry : _CancelableOperationMessenger {

  private val operations = HashMap<Long, Cancelable>()

  fun register(operationId: Long, cancelable: Cancelable) {
    operations[operationId] = cancelable
  }

  fun unregister(operationId: Long) {
    operations.remove(operationId)
  }

  /** Cancels the operation. An unknown or completed id does nothing. */
  override fun cancel(operationId: Long) {
    operations.remove(operationId)?.cancel()
  }

  fun cancelAll() {
    val pending = operations.values.toList()
    operations.clear()
    pending.forEach { it.cancel() }
  }
}