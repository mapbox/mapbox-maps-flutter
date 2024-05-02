// This file is generated.
package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationManager
import toFLTLineCap
import toFLTLineJoin
import toFLTLineTranslateAnchor
import toLineCap
import toLineJoin
import toLineTranslateAnchor

class PolylineAnnotationController(private val delegate: ControllerDelegate) : _PolylineAnnotationMessenger {
  private val annotationMap = mutableMapOf<String, com.mapbox.maps.plugin.annotation.generated.PolylineAnnotation>()
  private val managerCreateAnnotationMap = mutableMapOf<String, MutableList<String>>()

  override fun create(
    managerId: String,
    annotationOption: PolylineAnnotationOptions,
    callback: (Result<PolylineAnnotation>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager
      val annotation = manager.create(annotationOption.toPolylineAnnotationOptions())
      annotationMap[annotation.id] = annotation
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = mutableListOf(annotation.id)
      } else {
        managerCreateAnnotationMap[managerId]!!.add(annotation.id)
      }
      callback(Result.success(annotation.toFLTPolylineAnnotation()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun createMulti(
    managerId: String,
    annotationOptions: List<PolylineAnnotationOptions>,
    callback: (Result<List<PolylineAnnotation>>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager
      val annotations = manager.create(annotationOptions.map { it.toPolylineAnnotationOptions() })
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
      callback(Result.success(annotations.map { it.toFLTPolylineAnnotation() }.toMutableList()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun update(
    managerId: String,
    annotation: PolylineAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager

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
    annotation: PolylineAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager

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
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager
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

  private fun updateAnnotation(annotation: PolylineAnnotation): com.mapbox.maps.plugin.annotation.generated.PolylineAnnotation {
    val originalAnnotation = annotationMap[annotation.id]!!
    annotation.geometry?.let {
      originalAnnotation.geometry = it
    }
    annotation.lineJoin?.let {
      originalAnnotation.lineJoin = it.toLineJoin()
    }
    annotation.lineSortKey?.let {
      originalAnnotation.lineSortKey = it
    }
    annotation.lineBlur?.let {
      originalAnnotation.lineBlur = it
    }
    annotation.lineBorderColor?.let {
      originalAnnotation.lineBorderColorInt = it.toInt()
    }
    annotation.lineBorderWidth?.let {
      originalAnnotation.lineBorderWidth = it
    }
    annotation.lineColor?.let {
      originalAnnotation.lineColorInt = it.toInt()
    }
    annotation.lineGapWidth?.let {
      originalAnnotation.lineGapWidth = it
    }
    annotation.lineOffset?.let {
      originalAnnotation.lineOffset = it
    }
    annotation.lineOpacity?.let {
      originalAnnotation.lineOpacity = it
    }
    annotation.linePattern?.let {
      originalAnnotation.linePattern = it
    }
    annotation.lineWidth?.let {
      originalAnnotation.lineWidth = it
    }
    return originalAnnotation
  }

  override fun setLineCap(
    managerId: String,
    lineCap: LineCap,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineCap = lineCap.toLineCap()
    callback(Result.success(Unit))
  }

  override fun getLineCap(
    managerId: String,
    callback: (Result<LineCap?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineCap != null) {
      callback(Result.success(manager.lineCap!!.toFLTLineCap()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineMiterLimit(
    managerId: String,
    lineMiterLimit: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineMiterLimit = lineMiterLimit
    callback(Result.success(Unit))
  }

  override fun getLineMiterLimit(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineMiterLimit != null) {
      callback(Result.success(manager.lineMiterLimit!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineRoundLimit(
    managerId: String,
    lineRoundLimit: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineRoundLimit = lineRoundLimit
    callback(Result.success(Unit))
  }

  override fun getLineRoundLimit(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineRoundLimit != null) {
      callback(Result.success(manager.lineRoundLimit!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineDasharray(
    managerId: String,
    lineDasharray: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineDasharray = lineDasharray.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getLineDasharray(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineDasharray != null) {
      callback(Result.success(manager.lineDasharray!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineDepthOcclusionFactor(
    managerId: String,
    lineDepthOcclusionFactor: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineDepthOcclusionFactor = lineDepthOcclusionFactor
    callback(Result.success(Unit))
  }

  override fun getLineDepthOcclusionFactor(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineDepthOcclusionFactor != null) {
      callback(Result.success(manager.lineDepthOcclusionFactor!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineEmissiveStrength(
    managerId: String,
    lineEmissiveStrength: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineEmissiveStrength = lineEmissiveStrength
    callback(Result.success(Unit))
  }

  override fun getLineEmissiveStrength(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineEmissiveStrength != null) {
      callback(Result.success(manager.lineEmissiveStrength!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineTranslate(
    managerId: String,
    lineTranslate: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTranslate = lineTranslate.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getLineTranslate(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTranslate != null) {
      callback(Result.success(manager.lineTranslate!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineTranslateAnchor(
    managerId: String,
    lineTranslateAnchor: LineTranslateAnchor,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTranslateAnchor = lineTranslateAnchor.toLineTranslateAnchor()
    callback(Result.success(Unit))
  }

  override fun getLineTranslateAnchor(
    managerId: String,
    callback: (Result<LineTranslateAnchor?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTranslateAnchor != null) {
      callback(Result.success(manager.lineTranslateAnchor!!.toFLTLineTranslateAnchor()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineTrimOffset(
    managerId: String,
    lineTrimOffset: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTrimOffset = lineTrimOffset.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getLineTrimOffset(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTrimOffset != null) {
      callback(Result.success(manager.lineTrimOffset!!))
    } else {
      callback(Result.success(null))
    }
  }
}

fun com.mapbox.maps.plugin.annotation.generated.PolylineAnnotation.toFLTPolylineAnnotation(): PolylineAnnotation {
  return PolylineAnnotation(
    id = id,
    geometry = geometry,
    lineJoin = lineJoin?.toFLTLineJoin(),
    lineSortKey = lineSortKey,
    lineBlur = lineBlur,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    lineBorderColor = lineBorderColorInt?.toUInt()?.toLong(),
    lineBorderWidth = lineBorderWidth,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    lineColor = lineColorInt?.toUInt()?.toLong(),
    lineGapWidth = lineGapWidth,
    lineOffset = lineOffset,
    lineOpacity = lineOpacity,
    linePattern = linePattern,
    lineWidth = lineWidth,
  )
}

fun PolylineAnnotationOptions.toPolylineAnnotationOptions(): com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationOptions {
  val options = com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationOptions()
  this.geometry?.let {
    options.withGeometry(it)
  }
  this.lineJoin?.let {
    options.withLineJoin(it.toLineJoin())
  }
  this.lineSortKey?.let {
    options.withLineSortKey(it)
  }
  this.lineBlur?.let {
    options.withLineBlur(it)
  }
  this.lineBorderColor?.let {
    options.withLineBorderColor(it.toInt())
  }
  this.lineBorderWidth?.let {
    options.withLineBorderWidth(it)
  }
  this.lineColor?.let {
    options.withLineColor(it.toInt())
  }
  this.lineGapWidth?.let {
    options.withLineGapWidth(it)
  }
  this.lineOffset?.let {
    options.withLineOffset(it)
  }
  this.lineOpacity?.let {
    options.withLineOpacity(it)
  }
  this.linePattern?.let {
    options.withLinePattern(it)
  }
  this.lineWidth?.let {
    options.withLineWidth(it)
  }
  return options
}
// End of generated file.