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
    annotation.iconAllowOverlap?.let {
      originalAnnotation.iconAllowOverlap = it
    }
    annotation.iconAnchor?.let {
      originalAnnotation.iconAnchor = it.toIconAnchor()
    }
    annotation.iconIgnorePlacement?.let {
      originalAnnotation.iconIgnorePlacement = it
    }
    annotation.iconImage?.let {
      originalAnnotation.iconImage = it
    }
    annotation.iconKeepUpright?.let {
      originalAnnotation.iconKeepUpright = it
    }
    annotation.iconOffset?.let {
      originalAnnotation.iconOffset = it.mapNotNull { it }
    }
    annotation.iconOptional?.let {
      originalAnnotation.iconOptional = it
    }
    annotation.iconPadding?.let {
      originalAnnotation.iconPadding = it
    }
    annotation.iconPitchAlignment?.let {
      originalAnnotation.iconPitchAlignment = it.toIconPitchAlignment()
    }
    annotation.iconRotate?.let {
      originalAnnotation.iconRotate = it
    }
    annotation.iconRotationAlignment?.let {
      originalAnnotation.iconRotationAlignment = it.toIconRotationAlignment()
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
    annotation.symbolAvoidEdges?.let {
      originalAnnotation.symbolAvoidEdges = it
    }
    annotation.symbolPlacement?.let {
      originalAnnotation.symbolPlacement = it.toSymbolPlacement()
    }
    annotation.symbolSortKey?.let {
      originalAnnotation.symbolSortKey = it
    }
    annotation.symbolSpacing?.let {
      originalAnnotation.symbolSpacing = it
    }
    annotation.symbolZElevate?.let {
      originalAnnotation.symbolZElevate = it
    }
    annotation.symbolZOrder?.let {
      originalAnnotation.symbolZOrder = it.toSymbolZOrder()
    }
    annotation.textAllowOverlap?.let {
      originalAnnotation.textAllowOverlap = it
    }
    annotation.textAnchor?.let {
      originalAnnotation.textAnchor = it.toTextAnchor()
    }
    annotation.textField?.let {
      originalAnnotation.textField = it
    }
    annotation.textFont?.let {
      originalAnnotation.textFont = it.mapNotNull { it }
    }
    annotation.textIgnorePlacement?.let {
      originalAnnotation.textIgnorePlacement = it
    }
    annotation.textJustify?.let {
      originalAnnotation.textJustify = it.toTextJustify()
    }
    annotation.textKeepUpright?.let {
      originalAnnotation.textKeepUpright = it
    }
    annotation.textLetterSpacing?.let {
      originalAnnotation.textLetterSpacing = it
    }
    annotation.textLineHeight?.let {
      originalAnnotation.textLineHeight = it
    }
    annotation.textMaxAngle?.let {
      originalAnnotation.textMaxAngle = it
    }
    annotation.textMaxWidth?.let {
      originalAnnotation.textMaxWidth = it
    }
    annotation.textOffset?.let {
      originalAnnotation.textOffset = it.mapNotNull { it }
    }
    annotation.textOptional?.let {
      originalAnnotation.textOptional = it
    }
    annotation.textPadding?.let {
      originalAnnotation.textPadding = it
    }
    annotation.textPitchAlignment?.let {
      originalAnnotation.textPitchAlignment = it.toTextPitchAlignment()
    }
    annotation.textRadialOffset?.let {
      originalAnnotation.textRadialOffset = it
    }
    annotation.textRotate?.let {
      originalAnnotation.textRotate = it
    }
    annotation.textRotationAlignment?.let {
      originalAnnotation.textRotationAlignment = it.toTextRotationAlignment()
    }
    annotation.textSize?.let {
      originalAnnotation.textSize = it
    }
    annotation.textTransform?.let {
      originalAnnotation.textTransform = it.toTextTransform()
    }
    annotation.textVariableAnchor?.let {
      originalAnnotation.textVariableAnchor = it.mapNotNull { it }
    }
    annotation.textWritingMode?.let {
      originalAnnotation.textWritingMode = it.mapNotNull { it }
    }
    annotation.iconColor?.let {
      originalAnnotation.iconColorInt = it.toInt()
    }
    annotation.iconColorSaturation?.let {
      originalAnnotation.iconColorSaturation = it
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
    annotation.iconTranslate?.let {
      originalAnnotation.iconTranslate = it.mapNotNull { it }
    }
    annotation.iconTranslateAnchor?.let {
      originalAnnotation.iconTranslateAnchor = it.toIconTranslateAnchor()
    }
    annotation.symbolElevationReference?.let {
      originalAnnotation.symbolElevationReference = it.toSymbolElevationReference()
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
    annotation.textTranslate?.let {
      originalAnnotation.textTranslate = it.mapNotNull { it }
    }
    annotation.textTranslateAnchor?.let {
      originalAnnotation.textTranslateAnchor = it.toTextTranslateAnchor()
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
    if (manager.iconAnchor != null) {
      callback(Result.success(manager.iconAnchor!!.toFLTIconAnchor()))
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
    if (manager.iconImage != null) {
      callback(Result.success(manager.iconImage!!))
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
    if (manager.iconOffset != null) {
      callback(Result.success(manager.iconOffset!!))
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
    if (manager.iconRotate != null) {
      callback(Result.success(manager.iconRotate!!))
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
    if (manager.iconSize != null) {
      callback(Result.success(manager.iconSize!!))
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
    if (manager.iconTextFit != null) {
      callback(Result.success(manager.iconTextFit!!.toFLTIconTextFit()))
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
    if (manager.iconTextFitPadding != null) {
      callback(Result.success(manager.iconTextFitPadding!!))
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
    if (manager.symbolSortKey != null) {
      callback(Result.success(manager.symbolSortKey!!))
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
    if (manager.textAnchor != null) {
      callback(Result.success(manager.textAnchor!!.toFLTTextAnchor()))
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
    if (manager.textField != null) {
      callback(Result.success(manager.textField!!))
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
    if (manager.textJustify != null) {
      callback(Result.success(manager.textJustify!!.toFLTTextJustify()))
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
    if (manager.textLetterSpacing != null) {
      callback(Result.success(manager.textLetterSpacing!!))
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
    if (manager.textLineHeight != null) {
      callback(Result.success(manager.textLineHeight!!))
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
    if (manager.textMaxWidth != null) {
      callback(Result.success(manager.textMaxWidth!!))
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
    if (manager.textOffset != null) {
      callback(Result.success(manager.textOffset!!))
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
    if (manager.textRadialOffset != null) {
      callback(Result.success(manager.textRadialOffset!!))
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
    if (manager.textRotate != null) {
      callback(Result.success(manager.textRotate!!))
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
    if (manager.textSize != null) {
      callback(Result.success(manager.textSize!!))
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
    if (manager.textTransform != null) {
      callback(Result.success(manager.textTransform!!.toFLTTextTransform()))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconColor(
    managerId: String,
    iconColor: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconColor = iconColor
    callback(Result.success(Unit))
  }

  override fun getIconColor(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconColor != null) {
      callback(Result.success(manager.iconColor!!))
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
    if (manager.iconEmissiveStrength != null) {
      callback(Result.success(manager.iconEmissiveStrength!!))
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
    if (manager.iconHaloBlur != null) {
      callback(Result.success(manager.iconHaloBlur!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setIconHaloColor(
    managerId: String,
    iconHaloColor: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.iconHaloColor = iconHaloColor
    callback(Result.success(Unit))
  }

  override fun getIconHaloColor(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.iconHaloColor != null) {
      callback(Result.success(manager.iconHaloColor!!))
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
    if (manager.iconHaloWidth != null) {
      callback(Result.success(manager.iconHaloWidth!!))
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
    if (manager.iconImageCrossFade != null) {
      callback(Result.success(manager.iconImageCrossFade!!))
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
    if (manager.iconOpacity != null) {
      callback(Result.success(manager.iconOpacity!!))
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
    if (manager.symbolElevationReference != null) {
      callback(Result.success(manager.symbolElevationReference!!.toFLTSymbolElevationReference()))
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
    if (manager.symbolZOffset != null) {
      callback(Result.success(manager.symbolZOffset!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextColor(
    managerId: String,
    textColor: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textColor = textColor
    callback(Result.success(Unit))
  }

  override fun getTextColor(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textColor != null) {
      callback(Result.success(manager.textColor!!))
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
    if (manager.textEmissiveStrength != null) {
      callback(Result.success(manager.textEmissiveStrength!!))
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
    if (manager.textHaloBlur != null) {
      callback(Result.success(manager.textHaloBlur!!))
    } else {
      callback(Result.success(null))
    }
  }

  override fun setTextHaloColor(
    managerId: String,
    textHaloColor: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    manager.textHaloColor = textHaloColor
    callback(Result.success(Unit))
  }

  override fun getTextHaloColor(
    managerId: String,
    callback: (Result<String?>) -> Unit
  ) {
    val manager = delegate.getManager(managerId) as PointAnnotationManager
    if (manager.textHaloColor != null) {
      callback(Result.success(manager.textHaloColor!!))
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
    if (manager.textHaloWidth != null) {
      callback(Result.success(manager.textHaloWidth!!))
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
    if (manager.textOpacity != null) {
      callback(Result.success(manager.textOpacity!!))
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
    iconAllowOverlap = iconAllowOverlap,
    iconAnchor = iconAnchor?.toFLTIconAnchor(),
    iconIgnorePlacement = iconIgnorePlacement,
    iconImage = iconImage,
    iconKeepUpright = iconKeepUpright,
    iconOffset = iconOffset,
    iconOptional = iconOptional,
    iconPadding = iconPadding,
    iconPitchAlignment = iconPitchAlignment?.toFLTIconPitchAlignment(),
    iconRotate = iconRotate,
    iconRotationAlignment = iconRotationAlignment?.toFLTIconRotationAlignment(),
    iconSize = iconSize,
    iconTextFit = iconTextFit?.toFLTIconTextFit(),
    iconTextFitPadding = iconTextFitPadding,
    symbolAvoidEdges = symbolAvoidEdges,
    symbolPlacement = symbolPlacement?.toFLTSymbolPlacement(),
    symbolSortKey = symbolSortKey,
    symbolSpacing = symbolSpacing,
    symbolZElevate = symbolZElevate,
    symbolZOrder = symbolZOrder?.toFLTSymbolZOrder(),
    textAllowOverlap = textAllowOverlap,
    textAnchor = textAnchor?.toFLTTextAnchor(),
    textField = textField,
    textFont = textFont,
    textIgnorePlacement = textIgnorePlacement,
    textJustify = textJustify?.toFLTTextJustify(),
    textKeepUpright = textKeepUpright,
    textLetterSpacing = textLetterSpacing,
    textLineHeight = textLineHeight,
    textMaxAngle = textMaxAngle,
    textMaxWidth = textMaxWidth,
    textOffset = textOffset,
    textOptional = textOptional,
    textPadding = textPadding,
    textPitchAlignment = textPitchAlignment?.toFLTTextPitchAlignment(),
    textRadialOffset = textRadialOffset,
    textRotate = textRotate,
    textRotationAlignment = textRotationAlignment?.toFLTTextRotationAlignment(),
    textSize = textSize,
    textTransform = textTransform?.toFLTTextTransform(),
    textVariableAnchor = textVariableAnchor,
    textWritingMode = textWritingMode,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    iconColor = iconColorInt?.toUInt()?.toLong(),
    iconColorSaturation = iconColorSaturation,
    iconEmissiveStrength = iconEmissiveStrength,
    iconHaloBlur = iconHaloBlur,
    // colorInt is 32 bit and may be bigger than MAX_INT, so transfer to UInt firstly and then to Long.
    iconHaloColor = iconHaloColorInt?.toUInt()?.toLong(),
    iconHaloWidth = iconHaloWidth,
    iconImageCrossFade = iconImageCrossFade,
    iconOcclusionOpacity = iconOcclusionOpacity,
    iconOpacity = iconOpacity,
    iconTranslate = iconTranslate,
    iconTranslateAnchor = iconTranslateAnchor?.toFLTIconTranslateAnchor(),
    symbolElevationReference = symbolElevationReference?.toFLTSymbolElevationReference(),
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
    textTranslate = textTranslate,
    textTranslateAnchor = textTranslateAnchor?.toFLTTextTranslateAnchor(),
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
  this.iconAllowOverlap?.let {
    options.withIconAllowOverlap(it)
  }
  this.iconAnchor?.let {
    options.withIconAnchor(it.toIconAnchor())
  }
  this.iconIgnorePlacement?.let {
    options.withIconIgnorePlacement(it)
  }
  this.iconImage?.let {
    options.withIconImage(it)
  }
  this.iconKeepUpright?.let {
    options.withIconKeepUpright(it)
  }
  this.iconOffset?.let {
    options.withIconOffset(it.mapNotNull { it })
  }
  this.iconOptional?.let {
    options.withIconOptional(it)
  }
  this.iconPadding?.let {
    options.withIconPadding(it)
  }
  this.iconPitchAlignment?.let {
    options.withIconPitchAlignment(it.toIconPitchAlignment())
  }
  this.iconRotate?.let {
    options.withIconRotate(it)
  }
  this.iconRotationAlignment?.let {
    options.withIconRotationAlignment(it.toIconRotationAlignment())
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
  this.symbolAvoidEdges?.let {
    options.withSymbolAvoidEdges(it)
  }
  this.symbolPlacement?.let {
    options.withSymbolPlacement(it.toSymbolPlacement())
  }
  this.symbolSortKey?.let {
    options.withSymbolSortKey(it)
  }
  this.symbolSpacing?.let {
    options.withSymbolSpacing(it)
  }
  this.symbolZElevate?.let {
    options.withSymbolZElevate(it)
  }
  this.symbolZOrder?.let {
    options.withSymbolZOrder(it.toSymbolZOrder())
  }
  this.textAllowOverlap?.let {
    options.withTextAllowOverlap(it)
  }
  this.textAnchor?.let {
    options.withTextAnchor(it.toTextAnchor())
  }
  this.textField?.let {
    options.withTextField(it)
  }
  this.textFont?.let {
    options.withTextFont(it.mapNotNull { it })
  }
  this.textIgnorePlacement?.let {
    options.withTextIgnorePlacement(it)
  }
  this.textJustify?.let {
    options.withTextJustify(it.toTextJustify())
  }
  this.textKeepUpright?.let {
    options.withTextKeepUpright(it)
  }
  this.textLetterSpacing?.let {
    options.withTextLetterSpacing(it)
  }
  this.textLineHeight?.let {
    options.withTextLineHeight(it)
  }
  this.textMaxAngle?.let {
    options.withTextMaxAngle(it)
  }
  this.textMaxWidth?.let {
    options.withTextMaxWidth(it)
  }
  this.textOffset?.let {
    options.withTextOffset(it.mapNotNull { it })
  }
  this.textOptional?.let {
    options.withTextOptional(it)
  }
  this.textPadding?.let {
    options.withTextPadding(it)
  }
  this.textPitchAlignment?.let {
    options.withTextPitchAlignment(it.toTextPitchAlignment())
  }
  this.textRadialOffset?.let {
    options.withTextRadialOffset(it)
  }
  this.textRotate?.let {
    options.withTextRotate(it)
  }
  this.textRotationAlignment?.let {
    options.withTextRotationAlignment(it.toTextRotationAlignment())
  }
  this.textSize?.let {
    options.withTextSize(it)
  }
  this.textTransform?.let {
    options.withTextTransform(it.toTextTransform())
  }
  this.textVariableAnchor?.let {
    options.withTextVariableAnchor(it.mapNotNull { it })
  }
  this.textWritingMode?.let {
    options.withTextWritingMode(it.mapNotNull { it })
  }
  this.iconColor?.let {
    options.withIconColor(it.toInt())
  }
  this.iconColorSaturation?.let {
    options.withIconColorSaturation(it)
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
  this.iconTranslate?.let {
    options.withIconTranslate(it.mapNotNull { it })
  }
  this.iconTranslateAnchor?.let {
    options.withIconTranslateAnchor(it.toIconTranslateAnchor())
  }
  this.symbolElevationReference?.let {
    options.withSymbolElevationReference(it.toSymbolElevationReference())
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
  this.textTranslate?.let {
    options.withTextTranslate(it.mapNotNull { it })
  }
  this.textTranslateAnchor?.let {
    options.withTextTranslateAnchor(it.toTextTranslateAnchor())
  }
  return options
}
// End of generated file.