package com.mapbox.maps.mapbox_maps

import android.os.Debug
import com.mapbox.maps.mapbox_maps.pigeons.MemoryStatistics
import com.mapbox.maps.mapbox_maps.pigeons.MemoryStatisticsApi

class MemoryStatisticsController : MemoryStatisticsApi {
  override fun getMemoryStatistics(): MemoryStatistics {
    val runtime = Runtime.getRuntime()

    // Force garbage collection to get more accurate memory readings
    System.gc()

    // Java heap memory
    val maxMemory = runtime.maxMemory()
    val totalMemory = runtime.totalMemory()
    val freeMemory = runtime.freeMemory()
    val usedMemory = totalMemory - freeMemory

    // Native heap memory (this is where Mapbox native code allocates)
    val memoryInfo = Debug.MemoryInfo()
    Debug.getMemoryInfo(memoryInfo)

    // Native heap size and allocated bytes
    val nativeHeapSize = memoryInfo.nativePss.toLong() * 1024 // Convert KB to bytes
    val nativeHeapAllocated = Debug.getNativeHeapAllocatedSize()

    return MemoryStatistics(
      usedMemoryBytes = usedMemory,
      totalMemoryBytes = totalMemory,
      freeMemoryBytes = freeMemory,
      maxMemoryBytes = maxMemory,
      nativeHeapBytes = nativeHeapSize,
      nativeHeapAllocatedBytes = nativeHeapAllocated
    )
  }
}