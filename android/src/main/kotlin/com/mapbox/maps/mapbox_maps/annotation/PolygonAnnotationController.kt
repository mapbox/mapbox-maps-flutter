// This file is generated.
package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.extension.style.layers.properties.generated.*
import com.mapbox.maps.mapbox_maps.toMap
import com.mapbox.maps.mapbox_maps.toPointsList
import com.mapbox.maps.mapbox_maps.toPolygon
import com.mapbox.maps.pigeons.FLTPolygonAnnotationMessager
import com.mapbox.maps.plugin.annotation.generated.PolygonAnnotation
import com.mapbox.maps.plugin.annotation.generated.PolygonAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.PolygonAnnotationOptions

class PolygonAnnotationController(private val delegate: ControllerDelegate) :
  FLTPolygonAnnotationMessager._PolygonAnnotationMessager {
  private val annotationMap = mutableMapOf<String, PolygonAnnotation>()
  private val managerCreateAnnotationMap = mutableMapOf<String, MutableList<String>>()

  override fun create(
    managerId: String,
    annotationOption: FLTPolygonAnnotationMessager.PolygonAnnotationOptions,
    result: FLTPolygonAnnotationMessager.Result<FLTPolygonAnnotationMessager.PolygonAnnotation>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager
      val annotation = manager.create(annotationOption.toPolygonAnnotationOptions())
      annotationMap[annotation.id.toString()] = annotation
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = mutableListOf(annotation.id.toString())
      } else {
        managerCreateAnnotationMap[managerId]!!.add(annotation.id.toString())
      }
      result?.success(annotation.toFLTPolygonAnnotation())
    } catch (e: Exception) {
      result?.error(e)
    }
  }

  override fun createMulti(
    managerId: String,
    annotationOptions: MutableList<FLTPolygonAnnotationMessager.PolygonAnnotationOptions>,
    result: FLTPolygonAnnotationMessager.Result<MutableList<FLTPolygonAnnotationMessager.PolygonAnnotation>>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager
      val annotations = manager.create(annotationOptions.map { it.toPolygonAnnotationOptions() })
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
      result?.success(annotations.map { it.toFLTPolygonAnnotation() }.toMutableList())
    } catch (e: Exception) {
      result?.error(e)
    }
  }

  override fun update(
    managerId: String,
    annotation: FLTPolygonAnnotationMessager.PolygonAnnotation,
    result: FLTPolygonAnnotationMessager.Result<Void>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager

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
    annotation: FLTPolygonAnnotationMessager.PolygonAnnotation,
    result: FLTPolygonAnnotationMessager.Result<Void>?
  ) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager

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

  override fun deleteAll(managerId: String, result: FLTPolygonAnnotationMessager.Result<Void>?) {
    try {
      val manager = delegate.getManager(managerId) as PolygonAnnotationManager
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

  private fun updateAnnotation(annotation: FLTPolygonAnnotationMessager.PolygonAnnotation): PolygonAnnotation {
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
    result: FLTPolygonAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    manager.fillAntialias = fillAntialias
    result?.success(null)
  }

  override fun getFillAntialias(
    managerId: String,
    result: FLTPolygonAnnotationMessager.Result<Boolean>?
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    if (manager.fillAntialias != null) {
      result?.success(manager.fillAntialias!!)
    } else {
      result?.success(null)
    }
  }

  override fun setFillTranslate(
    managerId: String,
    fillTranslate: List<Double>,
    result: FLTPolygonAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    manager.fillTranslate = fillTranslate
    result?.success(null)
  }

  override fun getFillTranslate(
    managerId: String,
    result: FLTPolygonAnnotationMessager.Result<List<Double>>?
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    if (manager.fillTranslate != null) {
      result?.success(manager.fillTranslate!!)
    } else {
      result?.success(null)
    }
  }

  override fun setFillTranslateAnchor(
    managerId: String,
    fillTranslateAnchor: FLTPolygonAnnotationMessager.FillTranslateAnchor,
    result: FLTPolygonAnnotationMessager.Result<Void>?
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    manager.fillTranslateAnchor = FillTranslateAnchor.values()[fillTranslateAnchor.ordinal]
    result?.success(null)
  }

  override fun getFillTranslateAnchor(
    managerId: String,
    result: FLTPolygonAnnotationMessager.Result<Long>?
  ) {
    val manager = delegate.getManager(managerId) as PolygonAnnotationManager
    if (manager.fillTranslateAnchor != null) {
      result?.success(manager.fillTranslateAnchor!!.ordinal.toLong())
    } else {
      result?.success(null)
    }
  }
}

fun PolygonAnnotation.toFLTPolygonAnnotation(): FLTPolygonAnnotationMessager.PolygonAnnotation {
  val builder = FLTPolygonAnnotationMessager.PolygonAnnotation.Builder()
  builder.setId(this.id.toString())

  this.geometry.let {
    builder.setGeometry(it.toMap())
  }
  this.fillSortKey?.let {
    builder.setFillSortKey(it)
  }
  this.fillColorInt?.let {
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    builder.setFillColor(it.toUInt().toLong())
  }
  this.fillOpacity?.let {
    builder.setFillOpacity(it)
  }
  this.fillOutlineColorInt?.let {
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    builder.setFillOutlineColor(it.toUInt().toLong())
  }
  this.fillPattern?.let {
    builder.setFillPattern(it)
  }

  return builder.build()
}

fun FLTPolygonAnnotationMessager.PolygonAnnotationOptions.toPolygonAnnotationOptions(): PolygonAnnotationOptions {
  val options = PolygonAnnotationOptions()
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