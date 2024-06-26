// This file is generated.
package com.mapbox.maps.mapbox_maps.annotation

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationManager
import toFLTIconAnchor
import toFLTIconPitchAlignment
import toFLTIconRotationAlignment
import toFLTIconTextFit
import toFLTIconTranslateAnchor
import toFLTSymbolPlacement
import toFLTSymbolZOrder
import toFLTTextAnchor
import toFLTTextJustify
import toFLTTextPitchAlignment
import toFLTTextRotationAlignment
import toFLTTextTransform
import toFLTTextTranslateAnchor
import toIconAnchor
import toIconPitchAlignment
import toIconRotationAlignment
import toIconTextFit
import toIconTranslateAnchor
import toSymbolPlacement
import toSymbolZOrder
import toTextAnchor
import toTextJustify
import toTextPitchAlignment
import toTextRotationAlignment
import toTextTransform
import toTextTranslateAnchor
import java.io.ByteArrayOutputStream

class PointAnnotationController(private val delegate: ControllerDelegate) : _PointAnnotationMessenger {
  private val annotationMap = mutableMapOf<String, com.mapbox.maps.plugin.annotation.generated.PointAnnotation>()
  private val managerCreateAnnotationMap = mutableMapOf<String, MutableList<String>>()

  override fun create(
    managerId: String,
    annotationOption: PointAnnotationOptions,
    callback: (Result<PointAnnotation>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PointAnnotationManager
      val annotation = manager.create(annotationOption.toPointAnnotationOptions())
      annotationMap[annotation.id] = annotation
      if (managerCreateAnnotationMap[managerId].isNullOrEmpty()) {
        managerCreateAnnotationMap[managerId] = mutableListOf(annotation.id)
      } else {
        managerCreateAnnotationMap[managerId]!!.add(annotation.id)
      }
      callback(Result.success(annotation.toFLTPointAnnotation()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun createMulti(
    managerId: String,
    annotationOptions: List<PointAnnotationOptions>,
    callback: (Result<List<PointAnnotation>>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PointAnnotationManager
      val annotations = manager.create(annotationOptions.map { it.toPointAnnotationOptions() })
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
      callback(Result.success(annotations.map { it.toFLTPointAnnotation() }.toMutableList()))
    } catch (e: Exception) {
      callback(Result.failure(e))
    }
  }

  override fun update(
    managerId: String,
    annotation: PointAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PointAnnotationManager

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
    annotation: PointAnnotation,
    callback: (Result<Unit>) -> Unit
  ) {
    try {
      val manager = delegate.getManager(managerId) as PointAnnotationManager

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
      val manager = delegate.getManager(managerId) as PointAnnotationManager
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

  private fun updateAnnotation(annotation: PointAnnotation): com.mapbox.maps.plugin.annotation.generated.PointAnnotation {
    val originalAnnotation = annotationMap[annotation.id]!!
    annotation.geometry?.let {
      originalAnnotation.geometry = it
    }
    annotation.image?.let {
      originalAnnotation.iconImageBitmap = (BitmapFactory.decodeByteArray(it, 0, it.size))
    }
    annotation.iconAnchor?.let {
      originalAnnotation.iconAnchor = it.toIconAnchor()
    }
    annotation.iconImage?.let {
      originalAnnotation.iconImage = it
    }
    annotation.iconOffset?.let {
      originalAnnotation.iconOffset = it.mapNotNull { it }
    }
    annotation.iconRotate?.let {
      originalAnnotation.iconRotate = it
    }
    annotation.iconSize?.let {
      originalAnnotation.iconSize = it
    }
    annotation.iconTextFit?.let {
      originalAnnotation.iconTextFit = it.toIconTextFit()
    }
    annotation.iconTextFitPadding?.let {
      originalAnnotation.iconTextFitPadding = it.mapNotNull { it }
    }
    annotation.symbolSortKey?.let {
      originalAnnotation.symbolSortKey = it
    }
    annotation.textAnchor?.let {
      originalAnnotation.textAnchor = it.toTextAnchor()
    }
    annotation.textField?.let {
      originalAnnotation.textField = it
    }
    annotation.textJustify?.let {
      originalAnnotation.textJustify = it.toTextJustify()
    }
    annotation.textLetterSpacing?.let {
      originalAnnotation.textLetterSpacing = it
    }
    annotation.textLineHeight?.let {
      originalAnnotation.textLineHeight = it
    }
    annotation.textMaxWidth?.let {
      originalAnnotation.textMaxWidth = it
    }
    annotation.textOffset?.let {
      originalAnnotation.textOffset = it.mapNotNull { it }
    }
    annotation.textRadialOffset?.let {
      originalAnnotation.textRadialOffset = it
    }
    annotation.textRotate?.let {
      originalAnnotation.textRotate = it
    }
    annotation.textSize?.let {
      originalAnnotation.textSize = it
    }
    annotation.textTransform?.let {
      originalAnnotation.textTransform = it.toTextTransform()
    }
    annotation.iconColor?.let {
      originalAnnotation.iconColorInt = it.toInt()
    }
    annotation.iconEmissiveStrength?.let {
      originalAnnotation.iconEmissiveStrength = it
    }
    annotation.iconHaloBlur?.let {
      originalAnnotation.iconHaloBlur = it
    }
    annotation.iconHaloColor?.let {
      originalAnnotation.iconHaloColorInt = it.toInt()
    }
    annotation.iconHaloWidth?.let {
      originalAnnotation.iconHaloWidth = it
    }
    annotation.iconImageCrossFade?.let {
      originalAnnotation.iconImageCrossFade = it
    }
    annotation.iconOpacity?.let {
      originalAnnotation.iconOpacity = it
    }
    annotation.textColor?.let {
      originalAnnotation.textColorInt = it.toInt()
    }
    annotation.textEmissiveStrength?.let {
      originalAnnotation.textEmissiveStrength = it
    }
    annotation.textHaloBlur?.let {
      originalAnnotation.textHaloBlur = it
    }
    annotation.textHaloColor?.let {
      originalAnnotation.textHaloColorInt = it.toInt()
    }
    annotation.textHaloWidth?.let {
      originalAnnotation.textHaloWidth = it
    }
    annotation.textOpacity?.let {
      originalAnnotation.textOpacity = it
    }
    return originalAnnotation
  }

  override fun setIconAllowOverlap(
    managerId: String,
    iconAllowOverlap: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconAllowOverlap = iconAllowOverlap
    callback(Result.success(Unit))
  }

  override fun getIconAllowOverlap(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconAllowOverlap != null) {
      callback(Result.success(manager.iconAllowOverlap!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconIgnorePlacement(
    managerId: String,
    iconIgnorePlacement: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconIgnorePlacement = iconIgnorePlacement
    callback(Result.success(Unit))
  }

  override fun getIconIgnorePlacement(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconIgnorePlacement != null) {
      callback(Result.success(manager.iconIgnorePlacement!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconKeepUpright(
    managerId: String,
    iconKeepUpright: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconKeepUpright = iconKeepUpright
    callback(Result.success(Unit))
  }

  override fun getIconKeepUpright(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconKeepUpright != null) {
      callback(Result.success(manager.iconKeepUpright!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconOptional(
    managerId: String,
    iconOptional: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconOptional = iconOptional
    callback(Result.success(Unit))
  }

  override fun getIconOptional(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconOptional != null) {
      callback(Result.success(manager.iconOptional!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconPadding(
    managerId: String,
    iconPadding: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconPadding = iconPadding
    callback(Result.success(Unit))
  }

  override fun getIconPadding(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconPadding != null) {
      callback(Result.success(manager.iconPadding!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconPitchAlignment(
    managerId: String,
    iconPitchAlignment: IconPitchAlignment,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconPitchAlignment = iconPitchAlignment.toIconPitchAlignment()
    callback(Result.success(Unit))
  }

  override fun getIconPitchAlignment(
    managerId: String,
    callback: (Result<IconPitchAlignment?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconPitchAlignment != null) {
      callback(Result.success(manager.iconPitchAlignment!!.toFLTIconPitchAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconRotationAlignment(
    managerId: String,
    iconRotationAlignment: IconRotationAlignment,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconRotationAlignment = iconRotationAlignment.toIconRotationAlignment()
    callback(Result.success(Unit))
  }

  override fun getIconRotationAlignment(
    managerId: String,
    callback: (Result<IconRotationAlignment?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconRotationAlignment != null) {
      callback(Result.success(manager.iconRotationAlignment!!.toFLTIconRotationAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolAvoidEdges(
    managerId: String,
    symbolAvoidEdges: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolAvoidEdges = symbolAvoidEdges
    callback(Result.success(Unit))
  }

  override fun getSymbolAvoidEdges(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.symbolAvoidEdges != null) {
      callback(Result.success(manager.symbolAvoidEdges!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolPlacement(
    managerId: String,
    symbolPlacement: SymbolPlacement,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolPlacement = symbolPlacement.toSymbolPlacement()
    callback(Result.success(Unit))
  }

  override fun getSymbolPlacement(
    managerId: String,
    callback: (Result<SymbolPlacement?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.symbolPlacement != null) {
      callback(Result.success(manager.symbolPlacement!!.toFLTSymbolPlacement()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolSpacing(
    managerId: String,
    symbolSpacing: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolSpacing = symbolSpacing
    callback(Result.success(Unit))
  }

  override fun getSymbolSpacing(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.symbolSpacing != null) {
      callback(Result.success(manager.symbolSpacing!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolZElevate(
    managerId: String,
    symbolZElevate: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolZElevate = symbolZElevate
    callback(Result.success(Unit))
  }

  override fun getSymbolZElevate(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.symbolZElevate != null) {
      callback(Result.success(manager.symbolZElevate!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolZOrder(
    managerId: String,
    symbolZOrder: SymbolZOrder,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolZOrder = symbolZOrder.toSymbolZOrder()
    callback(Result.success(Unit))
  }

  override fun getSymbolZOrder(
    managerId: String,
    callback: (Result<SymbolZOrder?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.symbolZOrder != null) {
      callback(Result.success(manager.symbolZOrder!!.toFLTSymbolZOrder()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextAllowOverlap(
    managerId: String,
    textAllowOverlap: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textAllowOverlap = textAllowOverlap
    callback(Result.success(Unit))
  }

  override fun getTextAllowOverlap(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textAllowOverlap != null) {
      callback(Result.success(manager.textAllowOverlap!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextFont(
    managerId: String,
    textFont: List<String?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textFont = textFont.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getTextFont(
    managerId: String,
    callback: (Result<List<String?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textFont != null) {
      callback(Result.success(manager.textFont!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextIgnorePlacement(
    managerId: String,
    textIgnorePlacement: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textIgnorePlacement = textIgnorePlacement
    callback(Result.success(Unit))
  }

  override fun getTextIgnorePlacement(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textIgnorePlacement != null) {
      callback(Result.success(manager.textIgnorePlacement!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextKeepUpright(
    managerId: String,
    textKeepUpright: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textKeepUpright = textKeepUpright
    callback(Result.success(Unit))
  }

  override fun getTextKeepUpright(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textKeepUpright != null) {
      callback(Result.success(manager.textKeepUpright!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextMaxAngle(
    managerId: String,
    textMaxAngle: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textMaxAngle = textMaxAngle
    callback(Result.success(Unit))
  }

  override fun getTextMaxAngle(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textMaxAngle != null) {
      callback(Result.success(manager.textMaxAngle!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextOptional(
    managerId: String,
    textOptional: Boolean,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textOptional = textOptional
    callback(Result.success(Unit))
  }

  override fun getTextOptional(
    managerId: String,
    callback: (Result<Boolean?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textOptional != null) {
      callback(Result.success(manager.textOptional!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextPadding(
    managerId: String,
    textPadding: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textPadding = textPadding
    callback(Result.success(Unit))
  }

  override fun getTextPadding(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textPadding != null) {
      callback(Result.success(manager.textPadding!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextPitchAlignment(
    managerId: String,
    textPitchAlignment: TextPitchAlignment,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textPitchAlignment = textPitchAlignment.toTextPitchAlignment()
    callback(Result.success(Unit))
  }

  override fun getTextPitchAlignment(
    managerId: String,
    callback: (Result<TextPitchAlignment?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textPitchAlignment != null) {
      callback(Result.success(manager.textPitchAlignment!!.toFLTTextPitchAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextRotationAlignment(
    managerId: String,
    textRotationAlignment: TextRotationAlignment,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textRotationAlignment = textRotationAlignment.toTextRotationAlignment()
    callback(Result.success(Unit))
  }

  override fun getTextRotationAlignment(
    managerId: String,
    callback: (Result<TextRotationAlignment?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textRotationAlignment != null) {
      callback(Result.success(manager.textRotationAlignment!!.toFLTTextRotationAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconColorSaturation(
    managerId: String,
    iconColorSaturation: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconColorSaturation = iconColorSaturation
    callback(Result.success(Unit))
  }

  override fun getIconColorSaturation(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconColorSaturation != null) {
      callback(Result.success(manager.iconColorSaturation!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconOcclusionOpacity(
    managerId: String,
    iconOcclusionOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconOcclusionOpacity = iconOcclusionOpacity
    callback(Result.success(Unit))
  }

  override fun getIconOcclusionOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconOcclusionOpacity != null) {
      callback(Result.success(manager.iconOcclusionOpacity!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconTranslate(
    managerId: String,
    iconTranslate: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconTranslate = iconTranslate.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getIconTranslate(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconTranslate != null) {
      callback(Result.success(manager.iconTranslate!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconTranslateAnchor(
    managerId: String,
    iconTranslateAnchor: IconTranslateAnchor,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconTranslateAnchor = iconTranslateAnchor.toIconTranslateAnchor()
    callback(Result.success(Unit))
  }

  override fun getIconTranslateAnchor(
    managerId: String,
    callback: (Result<IconTranslateAnchor?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconTranslateAnchor != null) {
      callback(Result.success(manager.iconTranslateAnchor!!.toFLTIconTranslateAnchor()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextOcclusionOpacity(
    managerId: String,
    textOcclusionOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textOcclusionOpacity = textOcclusionOpacity
    callback(Result.success(Unit))
  }

  override fun getTextOcclusionOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textOcclusionOpacity != null) {
      callback(Result.success(manager.textOcclusionOpacity!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextTranslate(
    managerId: String,
    textTranslate: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textTranslate = textTranslate.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getTextTranslate(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textTranslate != null) {
      callback(Result.success(manager.textTranslate!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextTranslateAnchor(
    managerId: String,
    textTranslateAnchor: TextTranslateAnchor,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textTranslateAnchor = textTranslateAnchor.toTextTranslateAnchor()
    callback(Result.success(Unit))
  }

  override fun getTextTranslateAnchor(
    managerId: String,
    callback: (Result<TextTranslateAnchor?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textTranslateAnchor != null) {
      callback(Result.success(manager.textTranslateAnchor!!.toFLTTextTranslateAnchor()))
    } else {
      callback(Result.success(null))
    }
  }
}

fun com.mapbox.maps.plugin.annotation.generated.PointAnnotation.toFLTPointAnnotation(): PointAnnotation {
  return PointAnnotation(
    id = id,
    geometry = geometry,
    image = iconImageBitmap?.let {
      ByteArrayOutputStream().also { stream ->
        it.compress(Bitmap.CompressFormat.PNG, 100, stream)
      }.toByteArray()
    },
    iconAnchor = iconAnchor?.toFLTIconAnchor(),
    iconImage = iconImage,
    iconOffset = iconOffset,
    iconRotate = iconRotate,
    iconSize = iconSize,
    iconTextFit = iconTextFit?.toFLTIconTextFit(),
    iconTextFitPadding = iconTextFitPadding,
    symbolSortKey = symbolSortKey,
    textAnchor = textAnchor?.toFLTTextAnchor(),
    textField = textField,
    textJustify = textJustify?.toFLTTextJustify(),
    textLetterSpacing = textLetterSpacing,
    textLineHeight = textLineHeight,
    textMaxWidth = textMaxWidth,
    textOffset = textOffset,
    textRadialOffset = textRadialOffset,
    textRotate = textRotate,
    textSize = textSize,
    textTransform = textTransform?.toFLTTextTransform(),
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    iconColor = iconColorInt?.toUInt()?.toLong(),
    iconEmissiveStrength = iconEmissiveStrength,
    iconHaloBlur = iconHaloBlur,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    iconHaloColor = iconHaloColorInt?.toUInt()?.toLong(),
    iconHaloWidth = iconHaloWidth,
    iconImageCrossFade = iconImageCrossFade,
    iconOpacity = iconOpacity,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    textColor = textColorInt?.toUInt()?.toLong(),
    textEmissiveStrength = textEmissiveStrength,
    textHaloBlur = textHaloBlur,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    textHaloColor = textHaloColorInt?.toUInt()?.toLong(),
    textHaloWidth = textHaloWidth,
    textOpacity = textOpacity,
  )
}

fun PointAnnotationOptions.toPointAnnotationOptions(): com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions {
  val options = com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions()
  this.geometry?.let {
    options.withPoint(it)
  }
  this.image?.let {
    options.withIconImage(BitmapFactory.decodeByteArray(it, 0, it.size))
  }
  this.iconAnchor?.let {
    options.withIconAnchor(it.toIconAnchor())
  }
  this.iconImage?.let {
    options.withIconImage(it)
  }
  this.iconOffset?.let {
    options.withIconOffset(it.mapNotNull { it })
  }
  this.iconRotate?.let {
    options.withIconRotate(it)
  }
  this.iconSize?.let {
    options.withIconSize(it)
  }
  this.iconTextFit?.let {
    options.withIconTextFit(it.toIconTextFit())
  }
  this.iconTextFitPadding?.let {
    options.withIconTextFitPadding(it.mapNotNull { it })
  }
  this.symbolSortKey?.let {
    options.withSymbolSortKey(it)
  }
  this.textAnchor?.let {
    options.withTextAnchor(it.toTextAnchor())
  }
  this.textField?.let {
    options.withTextField(it)
  }
  this.textJustify?.let {
    options.withTextJustify(it.toTextJustify())
  }
  this.textLetterSpacing?.let {
    options.withTextLetterSpacing(it)
  }
  this.textLineHeight?.let {
    options.withTextLineHeight(it)
  }
  this.textMaxWidth?.let {
    options.withTextMaxWidth(it)
  }
  this.textOffset?.let {
    options.withTextOffset(it.mapNotNull { it })
  }
  this.textRadialOffset?.let {
    options.withTextRadialOffset(it)
  }
  this.textRotate?.let {
    options.withTextRotate(it)
  }
  this.textSize?.let {
    options.withTextSize(it)
  }
  this.textTransform?.let {
    options.withTextTransform(it.toTextTransform())
  }
  this.iconColor?.let {
    options.withIconColor(it.toInt())
  }
  this.iconEmissiveStrength?.let {
    options.withIconEmissiveStrength(it)
  }
  this.iconHaloBlur?.let {
    options.withIconHaloBlur(it)
  }
  this.iconHaloColor?.let {
    options.withIconHaloColor(it.toInt())
  }
  this.iconHaloWidth?.let {
    options.withIconHaloWidth(it)
  }
  this.iconImageCrossFade?.let {
    options.withIconImageCrossFade(it)
  }
  this.iconOpacity?.let {
    options.withIconOpacity(it)
  }
  this.textColor?.let {
    options.withTextColor(it.toInt())
  }
  this.textEmissiveStrength?.let {
    options.withTextEmissiveStrength(it)
  }
  this.textHaloBlur?.let {
    options.withTextHaloBlur(it)
  }
  this.textHaloColor?.let {
    options.withTextHaloColor(it.toInt())
  }
  this.textHaloWidth?.let {
    options.withTextHaloWidth(it)
  }
  this.textOpacity?.let {
    options.withTextOpacity(it)
  }
  return options
}
// End of generated file.