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
    annotation.lineCap?.let {
      originalAnnotation.lineCap = it.toLineCap()
    }
    annotation.lineJoin?.let {
      originalAnnotation.lineJoin = it.toLineJoin()
    }
    annotation.lineMiterLimit?.let {
      originalAnnotation.lineMiterLimit = it
    }
    annotation.lineRoundLimit?.let {
      originalAnnotation.lineRoundLimit = it
    }
    annotation.lineSortKey?.let {
      originalAnnotation.lineSortKey = it
    }
    annotation.lineZOffset?.let {
      originalAnnotation.lineZOffset = it
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
    annotation.lineDasharray?.let {
      originalAnnotation.lineDasharray = it.mapNotNull { it }
    }
    annotation.lineDepthOcclusionFactor?.let {
      originalAnnotation.lineDepthOcclusionFactor = it
    }
    annotation.lineEmissiveStrength?.let {
      originalAnnotation.lineEmissiveStrength = it
    }
    annotation.lineGapWidth?.let {
      originalAnnotation.lineGapWidth = it
    }
    annotation.lineGradient?.let {
      originalAnnotation.lineGradientInt = it.toInt()
    }
    annotation.lineOcclusionOpacity?.let {
      originalAnnotation.lineOcclusionOpacity = it
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
    annotation.lineTranslate?.let {
      originalAnnotation.lineTranslate = it.mapNotNull { it }
    }
    annotation.lineTranslateAnchor?.let {
      originalAnnotation.lineTranslateAnchor = it.toLineTranslateAnchor()
    }
    annotation.lineTrimColor?.let {
      originalAnnotation.lineTrimColorInt = it.toInt()
    }
    annotation.lineTrimFadeRange?.let {
      originalAnnotation.lineTrimFadeRange = it.mapNotNull { it }
    }
    annotation.lineTrimOffset?.let {
      originalAnnotation.lineTrimOffset = it.mapNotNull { it }
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

  override fun setLineJoin(
    managerId: String,
    lineJoin: LineJoin,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineJoin = lineJoin.toLineJoin()
    callback(Result.success(Unit))
  }

  override fun getLineJoin(
    managerId: String,
    callback: (Result<LineJoin?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineJoin != null) {
      callback(Result.success(manager.lineJoin!!.toFLTLineJoin()))
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

  override fun setLineSortKey(
    managerId: String,
    lineSortKey: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineSortKey = lineSortKey
    callback(Result.success(Unit))
  }

  override fun getLineSortKey(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineSortKey != null) {
      callback(Result.success(manager.lineSortKey!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineZOffset(
    managerId: String,
    lineZOffset: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineZOffset = lineZOffset
    callback(Result.success(Unit))
  }

  override fun getLineZOffset(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineZOffset != null) {
      callback(Result.success(manager.lineZOffset!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineBlur(
    managerId: String,
    lineBlur: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineBlur = lineBlur
    callback(Result.success(Unit))
  }

  override fun getLineBlur(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineBlur != null) {
      callback(Result.success(manager.lineBlur!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineBorderColor(
    managerId: String,
    lineBorderColor: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineBorderColor = lineBorderColor
    callback(Result.success(Unit))
  }

  override fun getLineBorderColor(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineBorderColor != null) {
      callback(Result.success(manager.lineBorderColor!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineBorderWidth(
    managerId: String,
    lineBorderWidth: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineBorderWidth = lineBorderWidth
    callback(Result.success(Unit))
  }

  override fun getLineBorderWidth(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineBorderWidth != null) {
      callback(Result.success(manager.lineBorderWidth!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineColor(
    managerId: String,
    lineColor: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineColor = lineColor
    callback(Result.success(Unit))
  }

  override fun getLineColor(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineColor != null) {
      callback(Result.success(manager.lineColor!!))
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

  override fun setLineGapWidth(
    managerId: String,
    lineGapWidth: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineGapWidth = lineGapWidth
    callback(Result.success(Unit))
  }

  override fun getLineGapWidth(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineGapWidth != null) {
      callback(Result.success(manager.lineGapWidth!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineOcclusionOpacity(
    managerId: String,
    lineOcclusionOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineOcclusionOpacity = lineOcclusionOpacity
    callback(Result.success(Unit))
  }

  override fun getLineOcclusionOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineOcclusionOpacity != null) {
      callback(Result.success(manager.lineOcclusionOpacity!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineOffset(
    managerId: String,
    lineOffset: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineOffset = lineOffset
    callback(Result.success(Unit))
  }

  override fun getLineOffset(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineOffset != null) {
      callback(Result.success(manager.lineOffset!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineOpacity(
    managerId: String,
    lineOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineOpacity = lineOpacity
    callback(Result.success(Unit))
  }

  override fun getLineOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineOpacity != null) {
      callback(Result.success(manager.lineOpacity!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLinePattern(
    managerId: String,
    linePattern: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.linePattern = linePattern
    callback(Result.success(Unit))
  }

  override fun getLinePattern(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.linePattern != null) {
      callback(Result.success(manager.linePattern!!))
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

  override fun setLineTrimColor(
    managerId: String,
    lineTrimColor: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTrimColor = lineTrimColor
    callback(Result.success(Unit))
  }

  override fun getLineTrimColor(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTrimColor != null) {
      callback(Result.success(manager.lineTrimColor!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setLineTrimFadeRange(
    managerId: String,
    lineTrimFadeRange: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTrimFadeRange = lineTrimFadeRange.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getLineTrimFadeRange(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTrimFadeRange != null) {
      callback(Result.success(manager.lineTrimFadeRange!!))
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

  override fun setLineWidth(
    managerId: String,
    lineWidth: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineWidth = lineWidth
    callback(Result.success(Unit))
  }

  override fun getLineWidth(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineWidth != null) {
      callback(Result.success(manager.lineWidth!!))
    } else {
      callback(Result.success(null))
    }
  }
}

fun com.mapbox.maps.plugin.annotation.generated.PolylineAnnotation.toFLTPolylineAnnotation(): PolylineAnnotation {
  return PolylineAnnotation(
    id = id,
    geometry = geometry,
    lineCap = lineCap?.toFLTLineCap(),
    lineJoin = lineJoin?.toFLTLineJoin(),
    lineMiterLimit = lineMiterLimit,
    lineRoundLimit = lineRoundLimit,
    lineSortKey = lineSortKey,
    lineZOffset = lineZOffset,
    lineBlur = lineBlur,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    lineBorderColor = lineBorderColorInt?.toUInt()?.toLong(),
    lineBorderWidth = lineBorderWidth,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    lineColor = lineColorInt?.toUInt()?.toLong(),
    lineDasharray = lineDasharray,
    lineDepthOcclusionFactor = lineDepthOcclusionFactor,
    lineEmissiveStrength = lineEmissiveStrength,
    lineGapWidth = lineGapWidth,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    lineGradient = lineGradientInt?.toUInt()?.toLong(),
    lineOcclusionOpacity = lineOcclusionOpacity,
    lineOffset = lineOffset,
    lineOpacity = lineOpacity,
    linePattern = linePattern,
    lineTranslate = lineTranslate,
    lineTranslateAnchor = lineTranslateAnchor?.toFLTLineTranslateAnchor(),
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    lineTrimColor = lineTrimColorInt?.toUInt()?.toLong(),
    lineTrimFadeRange = lineTrimFadeRange,
    lineTrimOffset = lineTrimOffset,
    lineWidth = lineWidth,
  )
}

fun PolylineAnnotationOptions.toPolylineAnnotationOptions(): com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationOptions {
  val options = com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationOptions()
  this.geometry?.let {
    options.withGeometry(it)
  }
  this.lineCap?.let {
    options.withLineCap(it.toLineCap())
  }
  this.lineJoin?.let {
    options.withLineJoin(it.toLineJoin())
  }
  this.lineMiterLimit?.let {
    options.withLineMiterLimit(it)
  }
  this.lineRoundLimit?.let {
    options.withLineRoundLimit(it)
  }
  this.lineSortKey?.let {
    options.withLineSortKey(it)
  }
  this.lineZOffset?.let {
    options.withLineZOffset(it)
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
  this.lineDasharray?.let {
    options.withLineDasharray(it.mapNotNull { it })
  }
  this.lineDepthOcclusionFactor?.let {
    options.withLineDepthOcclusionFactor(it)
  }
  this.lineEmissiveStrength?.let {
    options.withLineEmissiveStrength(it)
  }
  this.lineGapWidth?.let {
    options.withLineGapWidth(it)
  }
  this.lineGradient?.let {
    options.withLineGradient(it.toInt())
  }
  this.lineOcclusionOpacity?.let {
    options.withLineOcclusionOpacity(it)
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
  this.lineTranslate?.let {
    options.withLineTranslate(it.mapNotNull { it })
  }
  this.lineTranslateAnchor?.let {
    options.withLineTranslateAnchor(it.toLineTranslateAnchor())
  }
  this.lineTrimColor?.let {
    options.withLineTrimColor(it.toInt())
  }
  this.lineTrimFadeRange?.let {
    options.withLineTrimFadeRange(it.mapNotNull { it })
  }
  this.lineTrimOffset?.let {
    options.withLineTrimOffset(it.mapNotNull { it })
  }
  this.lineWidth?.let {
    options.withLineWidth(it)
  }
  return options
}
// End of generated file.