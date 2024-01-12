// This file is generated.
package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.extension.style.layers.properties.generated.*
import com.mapbox.maps.mapbox_maps.toLineString
import com.mapbox.maps.mapbox_maps.toMap
import com.mapbox.maps.mapbox_maps.toPoints
import com.mapbox.maps.pigeons.FLTPolylineAnnotationMessager
import com.mapbox.maps.plugin.annotation.generated.PolylineAnnotation
import com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationOptions
import toFLTLineCap
import toFLTLineJoin
import toFLTLineTranslateAnchor
import toLineCap
import toLineJoin
import toLineTranslateAnchor

class PolylineAnnotationController(private val delegate: ControllerDelegate) :
  FLTPolylineAnnotationMessager._PolylineAnnotationMessager {
  private val annotationMap = mutableMapOf<String, PolylineAnnotation>()
  private val managerCreateAnnotationMap = mutableMapOf<String, MutableList<String>>()

  override fun create(
    managerId: String,
    annotationOption: FLTPolylineAnnotationMessager.PolylineAnnotationOptions,
    result: FLTPolylineAnnotationMessager.Result<FLTPolylineAnnotationMessager.PolylineAnnotation>
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
      result.success(annotation.toFLTPolylineAnnotation())
    } catch (e: Exception) {
      result.error(e)
    }
  }

  override fun createMulti(
    managerId: String,
    annotationOptions: MutableList<FLTPolylineAnnotationMessager.PolylineAnnotationOptions>,
    result: FLTPolylineAnnotationMessager.Result<MutableList<FLTPolylineAnnotationMessager.PolylineAnnotation>>
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
      result.success(annotations.map { it.toFLTPolylineAnnotation() }.toMutableList())
    } catch (e: Exception) {
      result.error(e)
    }
  }

  override fun update(
    managerId: String,
    annotation: FLTPolylineAnnotationMessager.PolylineAnnotation,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager

      if (!annotationMap.containsKey(annotation.id)) {
        result.error(Throwable("Annotation has not been added on the map: $annotation."))
        return
      }
      val originalAnnotation = updateAnnotation(annotation)

      manager.update(originalAnnotation)
      annotationMap[annotation.id] = originalAnnotation
      result.success()
    } catch (e: Exception) {
      result.error(e)
    }
  }

  override fun delete(
    managerId: String,
    annotation: FLTPolylineAnnotationMessager.PolylineAnnotation,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager

      if (!annotationMap.containsKey(annotation.id)) {
        result.error(Throwable("Annotation has not been added on the map: $annotation."))
        return
      }

      manager.delete(
        annotationMap[annotation.id]!!
      )
      annotationMap.remove(annotation.id)
      managerCreateAnnotationMap[managerId]?.remove(annotation.id)
      result.success()
    } catch (e: Exception) {
      result.error(e)
    }
  }

  override fun deleteAll(managerId: String, result: FLTPolylineAnnotationMessager.VoidResult) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager
      managerCreateAnnotationMap[managerId]?.apply {
        forEach { annotationMap.remove(it) }
        clear()
      }
      manager.deleteAll()
      result.success()
    } catch (e: Exception) {
      result.error(e)
    }
  }

  private fun updateAnnotation(annotation: FLTPolylineAnnotationMessager.PolylineAnnotation): PolylineAnnotation {
    val originalAnnotation = annotationMap[annotation.id]!!
    annotation.geometry?.let {
      originalAnnotation.geometry = it.toLineString()
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
    lineCap: FLTPolylineAnnotationMessager.LineCap,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineCap = lineCap.toLineCap()
    result.success()
  }

  override fun getLineCap(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<FLTPolylineAnnotationMessager.LineCap>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineCap != null) {
      result.success(manager.lineCap!!.toFLTLineCap())
    } else {
      result.success(null)
    }
  }

  override fun setLineMiterLimit(
    managerId: String,
    lineMiterLimit: Double,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineMiterLimit = lineMiterLimit
    result.success()
  }

  override fun getLineMiterLimit(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<Double>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineMiterLimit != null) {
      result.success(manager.lineMiterLimit!!)
    } else {
      result.success(null)
    }
  }

  override fun setLineRoundLimit(
    managerId: String,
    lineRoundLimit: Double,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineRoundLimit = lineRoundLimit
    result.success()
  }

  override fun getLineRoundLimit(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<Double>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineRoundLimit != null) {
      result.success(manager.lineRoundLimit!!)
    } else {
      result.success(null)
    }
  }

  override fun setLineDasharray(
    managerId: String,
    lineDasharray: List<Double>,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineDasharray = lineDasharray
    result.success()
  }

  override fun getLineDasharray(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<List<Double>>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineDasharray != null) {
      result.success(manager.lineDasharray!!)
    } else {
      result.success(null)
    }
  }

  override fun setLineDepthOcclusionFactor(
    managerId: String,
    lineDepthOcclusionFactor: Double,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineDepthOcclusionFactor = lineDepthOcclusionFactor
    result.success()
  }

  override fun getLineDepthOcclusionFactor(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<Double>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineDepthOcclusionFactor != null) {
      result.success(manager.lineDepthOcclusionFactor!!)
    } else {
      result.success(null)
    }
  }

  override fun setLineEmissiveStrength(
    managerId: String,
    lineEmissiveStrength: Double,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineEmissiveStrength = lineEmissiveStrength
    result.success()
  }

  override fun getLineEmissiveStrength(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<Double>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineEmissiveStrength != null) {
      result.success(manager.lineEmissiveStrength!!)
    } else {
      result.success(null)
    }
  }

  override fun setLineTranslate(
    managerId: String,
    lineTranslate: List<Double>,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTranslate = lineTranslate
    result.success()
  }

  override fun getLineTranslate(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<List<Double>>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTranslate != null) {
      result.success(manager.lineTranslate!!)
    } else {
      result.success(null)
    }
  }

  override fun setLineTranslateAnchor(
    managerId: String,
    lineTranslateAnchor: FLTPolylineAnnotationMessager.LineTranslateAnchor,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTranslateAnchor = lineTranslateAnchor.toLineTranslateAnchor()
    result.success()
  }

  override fun getLineTranslateAnchor(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<FLTPolylineAnnotationMessager.LineTranslateAnchor>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTranslateAnchor != null) {
      result.success(manager.lineTranslateAnchor!!.toFLTLineTranslateAnchor())
    } else {
      result.success(null)
    }
  }

  override fun setLineTrimOffset(
    managerId: String,
    lineTrimOffset: List<Double>,
    result: FLTPolylineAnnotationMessager.VoidResult
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTrimOffset = lineTrimOffset
    result.success()
  }

  override fun getLineTrimOffset(
    managerId: String,
    result: FLTPolylineAnnotationMessager.NullableResult<List<Double>>
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTrimOffset != null) {
      result.success(manager.lineTrimOffset!!)
    } else {
      result.success(null)
    }
  }
}

fun PolylineAnnotation.toFLTPolylineAnnotation(): FLTPolylineAnnotationMessager.PolylineAnnotation {
  val builder = FLTPolylineAnnotationMessager.PolylineAnnotation.Builder()
  builder.setId(this.id.toString())

  this.geometry.let {
    builder.setGeometry(it.toMap())
  }
  this.lineJoin?.let {
    builder.setLineJoin(it.toFLTLineJoin())
  }
  this.lineSortKey?.let {
    builder.setLineSortKey(it)
  }
  this.lineBlur?.let {
    builder.setLineBlur(it)
  }
  this.lineBorderColorInt?.let {
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    builder.setLineBorderColor(it.toUInt().toLong())
  }
  this.lineBorderWidth?.let {
    builder.setLineBorderWidth(it)
  }
  this.lineColorInt?.let {
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    builder.setLineColor(it.toUInt().toLong())
  }
  this.lineGapWidth?.let {
    builder.setLineGapWidth(it)
  }
  this.lineOffset?.let {
    builder.setLineOffset(it)
  }
  this.lineOpacity?.let {
    builder.setLineOpacity(it)
  }
  this.linePattern?.let {
    builder.setLinePattern(it)
  }
  this.lineWidth?.let {
    builder.setLineWidth(it)
  }

  return builder.build()
}

fun FLTPolylineAnnotationMessager.PolylineAnnotationOptions.toPolylineAnnotationOptions(): PolylineAnnotationOptions {
  val options = PolylineAnnotationOptions()
  this.geometry?.let {
    options.withPoints(it.toPoints())
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