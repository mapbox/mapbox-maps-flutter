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

class PolylineAnnotationController(private val delegate: ControllerDelegate) :
  FLTPolylineAnnotationMessager._PolylineAnnotationMessager {
  private val annotationMap = mutableMapOf<String, PolylineAnnotation>()
  private val managerCreateAnnotationMap = mutableMapOf<String, MutableList<String>>()

  override fun create(
    managerId: String,
    annotationOption: FLTPolylineAnnotationMessager.PolylineAnnotationOptions,
    result: FLTPolylineAnnotationMessager.Result<FLTPolylineAnnotationMessager.PolylineAnnotation>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager
      val annotation = manager.create(annotationOption.toPolylineAnnotationOptions())
      annotationMap[annotation.id.toString()] = annotation
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = mutableListOf(annotation.id.toString())
      } else {
        managerCreateAnnotationMap[managerId]!!.add(annotation.id.toString())
      }
      result?.success(annotation.toFLTPolylineAnnotation())
    } catch (e: Exception) {
      result?.error(e)
    }
  }

  override fun createMulti(
    managerId: String,
    annotationOptions: MutableList<FLTPolylineAnnotationMessager.PolylineAnnotationOptions>,
    result: FLTPolylineAnnotationMessager.Result<MutableList<FLTPolylineAnnotationMessager.PolylineAnnotation>>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager
      val annotations = manager.create(annotationOptions.map { it.toPolylineAnnotationOptions() })
      annotations.forEach {
        annotationMap[it.id.toString()] = it
      }
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = annotations.map { it.id.toString() }.toMutableList()
      } else {
        managerCreateAnnotationMap[managerId]!!.addAll(
          annotations.map { it.id.toString() }
            .toList()
        )
      }
      result?.success(annotations.map { it.toFLTPolylineAnnotation() }.toMutableList())
    } catch (e: Exception) {
      result?.error(e)
    }
  }

  override fun update(
    managerId: String,
    annotation: FLTPolylineAnnotationMessager.PolylineAnnotation,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager

      if (!annotationMap.containsKey(annotation.id)) {
        result?.error(Throwable("Annotation has not been added on the map: $annotation."))
        return
      }
      val originalAnnotation = updateAnnotation(annotation)

      manager.update(originalAnnotation)
      annotationMap[annotation.id] = originalAnnotation
      result?.success(null)
    } catch (e: Exception) {
      result?.error(e)
    }
  }

  override fun delete(
    managerId: String,
    annotation: FLTPolylineAnnotationMessager.PolylineAnnotation,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager

      if (!annotationMap.containsKey(annotation.id)) {
        result?.error(Throwable("Annotation has not been added on the map: $annotation."))
        return
      }

      manager.delete(
        annotationMap[annotation.id]!!
      )
      annotationMap.remove(annotation.id)
      managerCreateAnnotationMap[managerId]?.remove(annotation.id)
      result?.success(null)
    } catch (e: Exception) {
      result?.error(e)
    }
  }

  override fun deleteAll(managerId: String, result: FLTPolylineAnnotationMessager.Result<Void>?) {
    try {
      val manager = delegate.getManager(managerId) as PolylineAnnotationManager
      managerCreateAnnotationMap[managerId]?.apply {
        forEach { annotationMap.remove(it) }
        clear()
      }
      manager.deleteAll()
      result?.success(null)
    } catch (e: Exception) {
      result?.error(e)
    }
  }

  private fun updateAnnotation(annotation: FLTPolylineAnnotationMessager.PolylineAnnotation): PolylineAnnotation {
    val originalAnnotation = annotationMap[annotation.id]!!
    annotation.geometry?.let {
      originalAnnotation.geometry = it.toLineString()
    }
    annotation.lineJoin?.let {
      originalAnnotation.lineJoin = LineJoin.values()[it.ordinal]
    }
    annotation.lineSortKey?.let {
      originalAnnotation.lineSortKey = it
    }
    annotation.lineBlur?.let {
      originalAnnotation.lineBlur = it
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
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineCap = LineCap.values()[lineCap.ordinal]
    result?.success(null)
  }

  override fun getLineCap(
    managerId: String,
    result: FLTPolylineAnnotationMessager.Result<Long>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineCap != null) {
      result?.success(manager.lineCap!!.ordinal.toLong())
    } else {
      result?.success(null)
    }
  }

  override fun setLineMiterLimit(
    managerId: String,
    lineMiterLimit: Double,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineMiterLimit = lineMiterLimit
    result?.success(null)
  }

  override fun getLineMiterLimit(
    managerId: String,
    result: FLTPolylineAnnotationMessager.Result<Double>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineMiterLimit != null) {
      result?.success(manager.lineMiterLimit!!)
    } else {
      result?.success(null)
    }
  }

  override fun setLineRoundLimit(
    managerId: String,
    lineRoundLimit: Double,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineRoundLimit = lineRoundLimit
    result?.success(null)
  }

  override fun getLineRoundLimit(
    managerId: String,
    result: FLTPolylineAnnotationMessager.Result<Double>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineRoundLimit != null) {
      result?.success(manager.lineRoundLimit!!)
    } else {
      result?.success(null)
    }
  }

  override fun setLineDasharray(
    managerId: String,
    lineDasharray: List<Double>,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineDasharray = lineDasharray
    result?.success(null)
  }

  override fun getLineDasharray(
    managerId: String,
    result: FLTPolylineAnnotationMessager.Result<List<Double>>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineDasharray != null) {
      result?.success(manager.lineDasharray!!)
    } else {
      result?.success(null)
    }
  }

  override fun setLineTranslate(
    managerId: String,
    lineTranslate: List<Double>,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTranslate = lineTranslate
    result?.success(null)
  }

  override fun getLineTranslate(
    managerId: String,
    result: FLTPolylineAnnotationMessager.Result<List<Double>>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTranslate != null) {
      result?.success(manager.lineTranslate!!)
    } else {
      result?.success(null)
    }
  }

  override fun setLineTranslateAnchor(
    managerId: String,
    lineTranslateAnchor: FLTPolylineAnnotationMessager.LineTranslateAnchor,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTranslateAnchor = LineTranslateAnchor.values()[lineTranslateAnchor.ordinal]
    result?.success(null)
  }

  override fun getLineTranslateAnchor(
    managerId: String,
    result: FLTPolylineAnnotationMessager.Result<Long>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTranslateAnchor != null) {
      result?.success(manager.lineTranslateAnchor!!.ordinal.toLong())
    } else {
      result?.success(null)
    }
  }

  override fun setLineTrimOffset(
    managerId: String,
    lineTrimOffset: List<Double>,
    result: FLTPolylineAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    manager.lineTrimOffset = lineTrimOffset
    result?.success(null)
  }

  override fun getLineTrimOffset(
    managerId: String,
    result: FLTPolylineAnnotationMessager.Result<List<Double>>?
  ) {
    val manager = delegate.getManager(managerId) as PolylineAnnotationManager
    if (manager.lineTrimOffset != null) {
      result?.success(manager.lineTrimOffset!!)
    } else {
      result?.success(null)
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
    builder.setLineJoin(FLTPolylineAnnotationMessager.LineJoin.values()[it.ordinal])
  }
  this.lineSortKey?.let {
    builder.setLineSortKey(it)
  }
  this.lineBlur?.let {
    builder.setLineBlur(it)
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
    options.withLineJoin(LineJoin.values()[it.ordinal])
  }
  this.lineSortKey?.let {
    options.withLineSortKey(it)
  }
  this.lineBlur?.let {
    options.withLineBlur(it)
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