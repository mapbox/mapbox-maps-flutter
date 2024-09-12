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
import toFLTSymbolElevationReference
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
import toSymbolElevationReference
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
    annotation.iconOcclusionOpacity?.let {
      originalAnnotation.iconOcclusionOpacity = it
    }
    annotation.iconOpacity?.let {
      originalAnnotation.iconOpacity = it
    }
    annotation.symbolZOffset?.let {
      originalAnnotation.symbolZOffset = it
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
    annotation.textOcclusionOpacity?.let {
      originalAnnotation.textOcclusionOpacity = it
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
    val value = manager.iconAllowOverlap
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconAnchor(
    managerId: String,
    iconAnchor: IconAnchor,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconAnchor = iconAnchor.toIconAnchor()
    callback(Result.success(Unit))
  }

  override fun getIconAnchor(
    managerId: String,
    callback: (Result<IconAnchor?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconAnchor
    if (value != null) {
      callback(Result.success(value.toFLTIconAnchor()))
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
    val value = manager.iconIgnorePlacement
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconImage(
    managerId: String,
    iconImage: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconImage = iconImage
    callback(Result.success(Unit))
  }

  override fun getIconImage(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconImage
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconKeepUpright
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconOffset(
    managerId: String,
    iconOffset: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconOffset = iconOffset.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getIconOffset(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconOffset
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconOptional
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconPadding
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconPitchAlignment
    if (value != null) {
      callback(Result.success(value.toFLTIconPitchAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconRotate(
    managerId: String,
    iconRotate: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconRotate = iconRotate
    callback(Result.success(Unit))
  }

  override fun getIconRotate(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconRotate
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconRotationAlignment
    if (value != null) {
      callback(Result.success(value.toFLTIconRotationAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconSize(
    managerId: String,
    iconSize: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconSize = iconSize
    callback(Result.success(Unit))
  }

  override fun getIconSize(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconSize
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconTextFit(
    managerId: String,
    iconTextFit: IconTextFit,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconTextFit = iconTextFit.toIconTextFit()
    callback(Result.success(Unit))
  }

  override fun getIconTextFit(
    managerId: String,
    callback: (Result<IconTextFit?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconTextFit
    if (value != null) {
      callback(Result.success(value.toFLTIconTextFit()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconTextFitPadding(
    managerId: String,
    iconTextFitPadding: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconTextFitPadding = iconTextFitPadding.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getIconTextFitPadding(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconTextFitPadding
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.symbolAvoidEdges
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.symbolPlacement
    if (value != null) {
      callback(Result.success(value.toFLTSymbolPlacement()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolSortKey(
    managerId: String,
    symbolSortKey: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolSortKey = symbolSortKey
    callback(Result.success(Unit))
  }

  override fun getSymbolSortKey(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.symbolSortKey
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.symbolSpacing
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.symbolZElevate
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.symbolZOrder
    if (value != null) {
      callback(Result.success(value.toFLTSymbolZOrder()))
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
    val value = manager.textAllowOverlap
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextAnchor(
    managerId: String,
    textAnchor: TextAnchor,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textAnchor = textAnchor.toTextAnchor()
    callback(Result.success(Unit))
  }

  override fun getTextAnchor(
    managerId: String,
    callback: (Result<TextAnchor?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textAnchor
    if (value != null) {
      callback(Result.success(value.toFLTTextAnchor()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextField(
    managerId: String,
    textField: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textField = textField
    callback(Result.success(Unit))
  }

  override fun getTextField(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textField
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textFont
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textIgnorePlacement
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextJustify(
    managerId: String,
    textJustify: TextJustify,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textJustify = textJustify.toTextJustify()
    callback(Result.success(Unit))
  }

  override fun getTextJustify(
    managerId: String,
    callback: (Result<TextJustify?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textJustify
    if (value != null) {
      callback(Result.success(value.toFLTTextJustify()))
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
    val value = manager.textKeepUpright
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextLetterSpacing(
    managerId: String,
    textLetterSpacing: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textLetterSpacing = textLetterSpacing
    callback(Result.success(Unit))
  }

  override fun getTextLetterSpacing(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textLetterSpacing
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextLineHeight(
    managerId: String,
    textLineHeight: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textLineHeight = textLineHeight
    callback(Result.success(Unit))
  }

  override fun getTextLineHeight(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textLineHeight
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textMaxAngle
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextMaxWidth(
    managerId: String,
    textMaxWidth: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textMaxWidth = textMaxWidth
    callback(Result.success(Unit))
  }

  override fun getTextMaxWidth(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textMaxWidth
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextOffset(
    managerId: String,
    textOffset: List<Double?>,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textOffset = textOffset.mapNotNull { it }
    callback(Result.success(Unit))
  }

  override fun getTextOffset(
    managerId: String,
    callback: (Result<List<Double?>?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textOffset
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textOptional
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textPadding
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textPitchAlignment
    if (value != null) {
      callback(Result.success(value.toFLTTextPitchAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextRadialOffset(
    managerId: String,
    textRadialOffset: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textRadialOffset = textRadialOffset
    callback(Result.success(Unit))
  }

  override fun getTextRadialOffset(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textRadialOffset
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextRotate(
    managerId: String,
    textRotate: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textRotate = textRotate
    callback(Result.success(Unit))
  }

  override fun getTextRotate(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textRotate
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textRotationAlignment
    if (value != null) {
      callback(Result.success(value.toFLTTextRotationAlignment()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextSize(
    managerId: String,
    textSize: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textSize = textSize
    callback(Result.success(Unit))
  }

  override fun getTextSize(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textSize
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextTransform(
    managerId: String,
    textTransform: TextTransform,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textTransform = textTransform.toTextTransform()
    callback(Result.success(Unit))
  }

  override fun getTextTransform(
    managerId: String,
    callback: (Result<TextTransform?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textTransform
    if (value != null) {
      callback(Result.success(value.toFLTTextTransform()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconColor(
    managerId: String,
    iconColor: Long,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconColorInt = iconColor.toInt()
    callback(Result.success(Unit))
  }

  override fun getIconColor(
    managerId: String,
    callback: (Result<Long?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconColorInt
    if (value != null) {
      callback(Result.success(value.toUInt().toLong()))
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
    val value = manager.iconColorSaturation
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconEmissiveStrength(
    managerId: String,
    iconEmissiveStrength: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconEmissiveStrength = iconEmissiveStrength
    callback(Result.success(Unit))
  }

  override fun getIconEmissiveStrength(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconEmissiveStrength
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconHaloBlur(
    managerId: String,
    iconHaloBlur: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconHaloBlur = iconHaloBlur
    callback(Result.success(Unit))
  }

  override fun getIconHaloBlur(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconHaloBlur
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconHaloColor(
    managerId: String,
    iconHaloColor: Long,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconHaloColorInt = iconHaloColor.toInt()
    callback(Result.success(Unit))
  }

  override fun getIconHaloColor(
    managerId: String,
    callback: (Result<Long?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconHaloColorInt
    if (value != null) {
      callback(Result.success(value.toUInt().toLong()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconHaloWidth(
    managerId: String,
    iconHaloWidth: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconHaloWidth = iconHaloWidth
    callback(Result.success(Unit))
  }

  override fun getIconHaloWidth(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconHaloWidth
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconImageCrossFade(
    managerId: String,
    iconImageCrossFade: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconImageCrossFade = iconImageCrossFade
    callback(Result.success(Unit))
  }

  override fun getIconImageCrossFade(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconImageCrossFade
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconOcclusionOpacity
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconOpacity(
    managerId: String,
    iconOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconOpacity = iconOpacity
    callback(Result.success(Unit))
  }

  override fun getIconOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.iconOpacity
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconTranslate
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.iconTranslateAnchor
    if (value != null) {
      callback(Result.success(value.toFLTIconTranslateAnchor()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolElevationReference(
    managerId: String,
    symbolElevationReference: SymbolElevationReference,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolElevationReference = symbolElevationReference.toSymbolElevationReference()
    callback(Result.success(Unit))
  }

  override fun getSymbolElevationReference(
    managerId: String,
    callback: (Result<SymbolElevationReference?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.symbolElevationReference
    if (value != null) {
      callback(Result.success(value.toFLTSymbolElevationReference()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setSymbolZOffset(
    managerId: String,
    symbolZOffset: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.symbolZOffset = symbolZOffset
    callback(Result.success(Unit))
  }

  override fun getSymbolZOffset(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.symbolZOffset
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextColor(
    managerId: String,
    textColor: Long,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textColorInt = textColor.toInt()
    callback(Result.success(Unit))
  }

  override fun getTextColor(
    managerId: String,
    callback: (Result<Long?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textColorInt
    if (value != null) {
      callback(Result.success(value.toUInt().toLong()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextEmissiveStrength(
    managerId: String,
    textEmissiveStrength: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textEmissiveStrength = textEmissiveStrength
    callback(Result.success(Unit))
  }

  override fun getTextEmissiveStrength(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textEmissiveStrength
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextHaloBlur(
    managerId: String,
    textHaloBlur: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textHaloBlur = textHaloBlur
    callback(Result.success(Unit))
  }

  override fun getTextHaloBlur(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textHaloBlur
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextHaloColor(
    managerId: String,
    textHaloColor: Long,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textHaloColorInt = textHaloColor.toInt()
    callback(Result.success(Unit))
  }

  override fun getTextHaloColor(
    managerId: String,
    callback: (Result<Long?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textHaloColorInt
    if (value != null) {
      callback(Result.success(value.toUInt().toLong()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextHaloWidth(
    managerId: String,
    textHaloWidth: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textHaloWidth = textHaloWidth
    callback(Result.success(Unit))
  }

  override fun getTextHaloWidth(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textHaloWidth
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textOcclusionOpacity
    if (value != null) {
      callback(Result.success(value))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextOpacity(
    managerId: String,
    textOpacity: Double,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textOpacity = textOpacity
    callback(Result.success(Unit))
  }

  override fun getTextOpacity(
    managerId: String,
    callback: (Result<Double?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    val value = manager.textOpacity
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textTranslate
    if (value != null) {
      callback(Result.success(value))
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
    val value = manager.textTranslateAnchor
    if (value != null) {
      callback(Result.success(value.toFLTTextTranslateAnchor()))
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
    iconOcclusionOpacity = iconOcclusionOpacity,
    iconOpacity = iconOpacity,
    symbolZOffset = symbolZOffset,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    textColor = textColorInt?.toUInt()?.toLong(),
    textEmissiveStrength = textEmissiveStrength,
    textHaloBlur = textHaloBlur,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    textHaloColor = textHaloColorInt?.toUInt()?.toLong(),
    textHaloWidth = textHaloWidth,
    textOcclusionOpacity = textOcclusionOpacity,
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
  this.iconOcclusionOpacity?.let {
    options.withIconOcclusionOpacity(it)
  }
  this.iconOpacity?.let {
    options.withIconOpacity(it)
  }
  this.symbolZOffset?.let {
    options.withSymbolZOffset(it)
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
  this.textOcclusionOpacity?.let {
    options.withTextOcclusionOpacity(it)
  }
  this.textOpacity?.let {
    options.withTextOpacity(it)
  }
  return options
}
// End of generated file.