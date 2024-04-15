// This file is generated.
package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.mapbox_maps.toMap
import com.mapbox.maps.mapbox_maps.toPointsList
import com.mapbox.maps.mapbox_maps.toPolygon
import com.mapbox.maps.plugin.annotation.generated.PolygonAnnotationManager
import toFLTFillTranslateAnchor
import toFillTranslateAnchor

class PolygonAnnotationController(private val delegate: ControllerDelegate) : _PolygonAnnotationMessenger {
  private val annotationMap = mutableMapOf<String, com.mapbox.maps.plugin.annotation.generated.PolygonAnnotation>()
  private val managerCreateAnnotationMap = mutableMapOf<String, MutableList<String>>()

  override fun create(
    managerId: String,
    annotationOption: PolygonAnnotationOptions,
    callback: (Result<PolygonAnnotation>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager
      val annotation = manager.create(annotationOption.toPolygonAnnotationOptions())
      annotationMap[annotation.id] = annotation
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = mutableListOf(annotation.id)
      } else {
        managerCreateAnnotationMap[managerId]!!.add(annotation.id)
      }
      callback(Result.success(annotation.toFLTPolygonAnnotation()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun createMulti(
    managerId: String,
    annotationOptions: List<PolygonAnnotationOptions>,
    callback: (Result<List<PolygonAnnotation>>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager
      val annotations = manager.create(annotationOptions.map { it.toPolygonAnnotationOptions() })
      annotations.forEach {
        annotationMap[it.id] = it
      }
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = annotations.map { it.id }.toMutableList()
      } else {
        managerCreateAnnotationMap[managerId]!!.addAll(
          annotations.map { it.id }
            .toList()
        )
      }
      callback(Result.success(annotations.map { it.toFLTPolygonAnnotation() }.toMutableList()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun update(
    managerId: String,
    annotation: PolygonAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager

      if (!annotationMap.containsKey(annotation.id)) {
        callback(Result.failure(Throwable("Annotation has not been added on the map: $annotation.")))
        return
      }
      val originalAnnotation = updateAnnotation(annotation)

      manager.update(originalAnnotation)
      annotationMap[annotation.id] = originalAnnotation
      callback(Result.success(Unit))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun delete(
    managerId: String,
    annotation: PolygonAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager

      if (!annotationMap.containsKey(annotation.id)) {
        callback(Result.failure(Throwable("Annotation has not been added on the map: $annotation.")))
        return
      }

      manager.delete(
        annotationMap[annotation.id]!!
      )
      annotationMap.remove(annotation.id)
      managerCreateAnnotationMap[managerId]?.remove(annotation.id)
      callback(Result.success(Unit))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun deleteAll(managerId: String, callback: (Result<Unit>) -> Unit) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager
      managerCreateAnnotationMap[managerId]?.apply {
        forEach { annotationMap.remove(it) }
        clear()
      }
      manager.deleteAll()
      callback(Result.success(Unit))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  private fun updateAnnotation(annotation: PolygonAnnotation): com.mapbox.maps.plugin.annotation.generated.PolygonAnnotation {
    val originalAnnotation = annotationMap[annotation.id]!!
    annotation.geometry?.let {
      originalAnnotation.geometry = it.toPolygon()
    }
    annotation.fillSortKey?.let {
      originalAnnotation.fillSortKey = it
    }
    annotation.fillColor?.let {
      originalAnnotation.fillColorInt = it.toInt()
    }
    annotation.fillOpacity?.let {
      originalAnnotation.fillOpacity = it
    }
    annotation.fillOutlineColor?.let {
      originalAnnotation.fillOutlineColorInt = it.toInt()
    }
    annotation.fillPattern?.let {
      originalAnnotation.fillPattern = it
    }
    return originalAnnotation
  }

  override fun setFillAntialias(
    managerId: String,
    fillAntialias: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    manager.fillAntialias = fillAntialias
    callback(Result.success(Unit))
  }

  override fun getFillAntialias(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    if (manager.fillAntialias != null) {
      callback(Result.success(manager.fillAntialias!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setFillEmissiveStrength(
    managerId: String,
    fillEmissiveStrength: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    manager.fillEmissiveStrength = fillEmissiveStrength
    callback(Result.success(Unit))
  }

  override fun getFillEmissiveStrength(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    if (manager.fillEmissiveStrength != null) {
      callback(Result.success(manager.fillEmissiveStrength!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setFillTranslate(
    managerId: String,
    fillTranslate: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    manager.fillTranslate = fillTranslate.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getFillTranslate(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    if (manager.fillTranslate != null) {
      callback(Result.success(manager.fillTranslate!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setFillTranslateAnchor(
    managerId: String,
    fillTranslateAnchor: FillTranslateAnchor,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    manager.fillTranslateAnchor = fillTranslateAnchor.toFillTranslateAnchor()
    callback(Result.success(Unit))
  }

  override fun getFillTranslateAnchor(
    managerId: String,
    callback: (Result<FillTranslateAnchor?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    if (manager.fillTranslateAnchor != null) {
      callback(Result.success(manager.fillTranslateAnchor!!.toFLTFillTranslateAnchor()))
    } else {
      callback(Result.success(null))
    }
  }
}

fun com.mapbox.maps.plugin.annotation.generated.PolygonAnnotation.toFLTPolygonAnnotation(): PolygonAnnotation {
  return PolygonAnnotation(
    id = id,
    geometry = geometry.toMap(),
    fillSortKey = fillSortKey,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    fillColor = fillColorInt?.toUInt()?.toLong(),
    fillOpacity = fillOpacity,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    fillOutlineColor = fillOutlineColorInt?.toUInt()?.toLong(),
    fillPattern = fillPattern,
  )
}

fun PolygonAnnotationOptions.toPolygonAnnotationOptions(): com.mapbox.maps.plugin.annotation.generated.PolygonAnnotationOptions {
  val options = com.mapbox.maps.plugin.annotation.generated.PolygonAnnotationOptions()
  this.geometry?.let {
    options.withPoints(it.toPointsList())
  }
  this.fillSortKey?.let {
    options.withFillSortKey(it)
  }
  this.fillColor?.let {
    options.withFillColor(it.toInt())
  }
  this.fillOpacity?.let {
    options.withFillOpacity(it)
  }
  this.fillOutlineColor?.let {
    options.withFillOutlineColor(it.toInt())
  }
  this.fillPattern?.let {
    options.withFillPattern(it)
  }
  return options
}
// End of generated file.