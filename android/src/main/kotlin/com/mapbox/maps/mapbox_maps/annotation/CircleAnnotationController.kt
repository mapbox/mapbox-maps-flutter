// This file is generated.
package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.annotation.generated.CircleAnnotationManager
import toCirclePitchAlignment
import toCirclePitchScale
import toCircleTranslateAnchor
import toFLTCirclePitchAlignment
import toFLTCirclePitchScale
import toFLTCircleTranslateAnchor

class CircleAnnotationController(private val delegate: ControllerDelegate) : _CircleAnnotationMessenger {
  private val annotationMap = mutableMapOf<String, com.mapbox.maps.plugin.annotation.generated.CircleAnnotation>()
  private val managerCreateAnnotationMap = mutableMapOf<String, MutableList<String>>()

  override fun create(
    managerId: String,
    annotationOption: CircleAnnotationOptions,
    callback: (Result<CircleAnnotation>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as CircleAnnotationManager
      val annotation = manager.create(annotationOption.toCircleAnnotationOptions())
      annotationMap[annotation.id] = annotation
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = mutableListOf(annotation.id)
      } else {
        managerCreateAnnotationMap[managerId]!!.add(annotation.id)
      }
      callback(Result.success(annotation.toFLTCircleAnnotation()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun createMulti(
    managerId: String,
    annotationOptions: List<CircleAnnotationOptions>,
    callback: (Result<List<CircleAnnotation>>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as CircleAnnotationManager
      val annotations = manager.create(annotationOptions.map { it.toCircleAnnotationOptions() })
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
      callback(Result.success(annotations.map { it.toFLTCircleAnnotation() }.toMutableList()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun update(
    managerId: String,
    annotation: CircleAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as CircleAnnotationManager

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
    annotation: CircleAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as CircleAnnotationManager

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
      val manager = delegate.getManager(managerId) as CircleAnnotationManager
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

  private fun updateAnnotation(annotation: CircleAnnotation): com.mapbox.maps.plugin.annotation.generated.CircleAnnotation {
    val originalAnnotation = annotationMap[annotation.id]!!
    annotation.geometry?.let {
      originalAnnotation.geometry = it
    }
    annotation.circleSortKey?.let {
      originalAnnotation.circleSortKey = it
    }
    annotation.circleBlur?.let {
      originalAnnotation.circleBlur = it
    }
    annotation.circleColor?.let {
      originalAnnotation.circleColorInt = it.toInt()
    }
    annotation.circleOpacity?.let {
      originalAnnotation.circleOpacity = it
    }
    annotation.circleRadius?.let {
      originalAnnotation.circleRadius = it
    }
    annotation.circleStrokeColor?.let {
      originalAnnotation.circleStrokeColorInt = it.toInt()
    }
    annotation.circleStrokeOpacity?.let {
      originalAnnotation.circleStrokeOpacity = it
    }
    annotation.circleStrokeWidth?.let {
      originalAnnotation.circleStrokeWidth = it
    }
    return originalAnnotation
  }

  override fun setCircleSortKey(
    managerId: String,
    circleSortKey: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleSortKey = circleSortKey
    callback(Result.success(Unit))
  }

  override fun getCircleSortKey(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleSortKey
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleBlur(
    managerId: String,
    circleBlur: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleBlur = circleBlur
    callback(Result.success(Unit))
  }

  override fun getCircleBlur(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleBlur
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleColor(
    managerId: String,
    circleColor: Long,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleColorInt = circleColor.toInt()
    callback(Result.success(Unit))
  }

  override fun getCircleColor(
    managerId: String,
    callback: (Result<Long?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleColorInt
    if (value != null) {
      callback(Result.success(value.toUInt().toLong()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleEmissiveStrength(
    managerId: String,
    circleEmissiveStrength: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleEmissiveStrength = circleEmissiveStrength
    callback(Result.success(Unit))
  }

  override fun getCircleEmissiveStrength(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleEmissiveStrength
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleOpacity(
    managerId: String,
    circleOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleOpacity = circleOpacity
    callback(Result.success(Unit))
  }

  override fun getCircleOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleOpacity
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCirclePitchAlignment(
    managerId: String,
    circlePitchAlignment: CirclePitchAlignment,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circlePitchAlignment = circlePitchAlignment.toCirclePitchAlignment()
    callback(Result.success(Unit))
  }

  override fun getCirclePitchAlignment(
    managerId: String,
    callback: (Result<CirclePitchAlignment?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circlePitchAlignment
    if (value != null) {
      callback(Result.success(value.toFLTCirclePitchAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCirclePitchScale(
    managerId: String,
    circlePitchScale: CirclePitchScale,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circlePitchScale = circlePitchScale.toCirclePitchScale()
    callback(Result.success(Unit))
  }

  override fun getCirclePitchScale(
    managerId: String,
    callback: (Result<CirclePitchScale?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circlePitchScale
    if (value != null) {
      callback(Result.success(value.toFLTCirclePitchScale()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleRadius(
    managerId: String,
    circleRadius: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleRadius = circleRadius
    callback(Result.success(Unit))
  }

  override fun getCircleRadius(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleRadius
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleStrokeColor(
    managerId: String,
    circleStrokeColor: Long,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleStrokeColorInt = circleStrokeColor.toInt()
    callback(Result.success(Unit))
  }

  override fun getCircleStrokeColor(
    managerId: String,
    callback: (Result<Long?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleStrokeColorInt
    if (value != null) {
      callback(Result.success(value.toUInt().toLong()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleStrokeOpacity(
    managerId: String,
    circleStrokeOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleStrokeOpacity = circleStrokeOpacity
    callback(Result.success(Unit))
  }

  override fun getCircleStrokeOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleStrokeOpacity
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleStrokeWidth(
    managerId: String,
    circleStrokeWidth: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleStrokeWidth = circleStrokeWidth
    callback(Result.success(Unit))
  }

  override fun getCircleStrokeWidth(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleStrokeWidth
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleTranslate(
    managerId: String,
    circleTranslate: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleTranslate = circleTranslate.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getCircleTranslate(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleTranslate
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setCircleTranslateAnchor(
    managerId: String,
    circleTranslateAnchor: CircleTranslateAnchor,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    manager.circleTranslateAnchor = circleTranslateAnchor.toCircleTranslateAnchor()
    callback(Result.success(Unit))
  }

  override fun getCircleTranslateAnchor(
    managerId: String,
    callback: (Result<CircleTranslateAnchor?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as CircleAnnotationManager
    val value = manager.circleTranslateAnchor
    if (value != null) {
      callback(Result.success(value.toFLTCircleTranslateAnchor()))
    } else {
      callback(Result.success(null))
    }
  }
}

fun com.mapbox.maps.plugin.annotation.generated.CircleAnnotation.toFLTCircleAnnotation(): CircleAnnotation {
  return CircleAnnotation(
    id = id,
    geometry = geometry,
    circleSortKey = circleSortKey,
    circleBlur = circleBlur,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    circleColor = circleColorInt?.toUInt()?.toLong(),
    circleOpacity = circleOpacity,
    circleRadius = circleRadius,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    circleStrokeColor = circleStrokeColorInt?.toUInt()?.toLong(),
    circleStrokeOpacity = circleStrokeOpacity,
    circleStrokeWidth = circleStrokeWidth,
  )
}

fun CircleAnnotationOptions.toCircleAnnotationOptions(): com.mapbox.maps.plugin.annotation.generated.CircleAnnotationOptions {
  val options = com.mapbox.maps.plugin.annotation.generated.CircleAnnotationOptions()
  this.geometry?.let {
    options.withPoint(it)
  }
  this.circleSortKey?.let {
    options.withCircleSortKey(it)
  }
  this.circleBlur?.let {
    options.withCircleBlur(it)
  }
  this.circleColor?.let {
    options.withCircleColor(it.toInt())
  }
  this.circleOpacity?.let {
    options.withCircleOpacity(it)
  }
  this.circleRadius?.let {
    options.withCircleRadius(it)
  }
  this.circleStrokeColor?.let {
    options.withCircleStrokeColor(it.toInt())
  }
  this.circleStrokeOpacity?.let {
    options.withCircleStrokeOpacity(it)
  }
  this.circleStrokeWidth?.let {
    options.withCircleStrokeWidth(it)
  }
  return options
}
// End of generated file.