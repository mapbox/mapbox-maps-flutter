package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.bindgen.DataRef
import com.mapbox.bindgen.Value
import com.mapbox.maps.*
import com.mapbox.maps.extension.localization.localizeLabels
import com.mapbox.maps.extension.style.light.setLight
import com.mapbox.maps.extension.style.projection.generated.getProjection
import com.mapbox.maps.extension.style.projection.generated.setProjection
import com.mapbox.maps.pigeons.FLTMapInterfaces
import java.lang.RuntimeException
import java.nio.ByteBuffer
import java.util.HashMap
import java.util.Locale

class StyleController(private val mapboxMap: MapboxMap, private val context: Context) :
  FLTMapInterfaces.StyleManager {
  override fun getStyleURI(result: FLTMapInterfaces.Result<String>) {
    result.success(mapboxMap.style?.styleURI ?: "")
  }

  override fun setStyleURI(uri: String, result: FLTMapInterfaces.VoidResult) {
    mapboxMap.loadStyle(uri) {
      result.success()
    }
  }

  override fun getStyleJSON(result: FLTMapInterfaces.Result<String>) {
    result.success(mapboxMap.style?.styleJSON ?: "")
  }

  override fun setStyleJSON(json: String, result: FLTMapInterfaces.VoidResult) {
    mapboxMap.loadStyle(json) {
      result.success()
    }
  }

  override fun getStyleDefaultCamera(result: FLTMapInterfaces.Result<FLTMapInterfaces.CameraOptions>) {
    val camera = mapboxMap.styleDefaultCamera
    result.success(camera.toFLTCameraOptions(context))
  }

  override fun getStyleTransition(result: FLTMapInterfaces.Result<FLTMapInterfaces.TransitionOptions>) {
    val transitionOptions = mapboxMap.getStyleTransition()
    result.success(
      FLTMapInterfaces.TransitionOptions.Builder().setDelay(transitionOptions.delay)
        .setDuration(transitionOptions.duration)
        .setEnablePlacementTransitions(transitionOptions.enablePlacementTransitions)
        .build()
    )
  }

  override fun getStyleImports(): MutableList<FLTMapInterfaces.StyleObjectInfo> {
    return mapboxMap.getStyleImports().map { it.toFLTStyleObjectInfo() }.toMutableList()
  }

  override fun removeStyleImport(importId: String) {
    mapboxMap.removeStyleImport(importId)
  }

  override fun getStyleImportSchema(importId: String): Any {
    return mapboxMap.getStyleImportSchema(importId)
      .getValueOrElse {
        throw RuntimeException(it)
      }
  }

  override fun getStyleImportConfigProperties(importId: String): MutableMap<String, FLTMapInterfaces.StylePropertyValue> {
    return mapboxMap.getStyleImportConfigProperties(importId)
      .getValueOrElse { throw RuntimeException(it) }
      .mapValues { it.value.toFLTStylePropertyValue() }
      .toMutableMap()
  }

  override fun getStyleImportConfigProperty(
    importId: String,
    config: String
  ): FLTMapInterfaces.StylePropertyValue {
    return mapboxMap.getStyleImportConfigProperty(importId, config)
      .getValueOrElse { throw RuntimeException(it) }
      .toFLTStylePropertyValue()
  }

  override fun setStyleImportConfigProperties(importId: String, configs: MutableMap<String, Any>) {
    mapboxMap.setStyleImportConfigProperties(
      importId,
      configs.mapValues { it.toValue() } as HashMap<String, Value>
    )
  }

  override fun setStyleImportConfigProperty(importId: String, config: String, value: Any) {
    mapboxMap.setStyleImportConfigProperty(importId, config, value.toValue())
  }

  override fun setStyleTransition(
    transitionOptions: FLTMapInterfaces.TransitionOptions,
    result: FLTMapInterfaces.VoidResult
  ) {
    mapboxMap.setStyleTransition(
      TransitionOptions.Builder().delay(transitionOptions.delay)
        .duration(transitionOptions.duration)
        .enablePlacementTransitions(transitionOptions.enablePlacementTransitions).build()
    )
    result.success()
  }

  override fun addStyleLayer(
    properties: String,
    layerPosition: FLTMapInterfaces.LayerPosition?,
    result: FLTMapInterfaces.VoidResult
  ) {
    properties.toValue().let { parameters ->
      val expected = mapboxMap.addStyleLayer(
        parameters,
        LayerPosition(
          layerPosition?.above,
          layerPosition?.below,
          layerPosition?.at?.toInt()
        )
      )
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success()
      }
    }
  }

  override fun addPersistentStyleLayer(
    properties: String,
    layerPosition: FLTMapInterfaces.LayerPosition?,
    result: FLTMapInterfaces.VoidResult
  ) {
    properties.toValue().let { parameters ->
      val expected = mapboxMap.addPersistentStyleLayer(
        parameters,
        LayerPosition(
          layerPosition?.above,
          layerPosition?.below,
          layerPosition?.at?.toInt()
        )
      )
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success()
      }
    }
  }

  override fun isStyleLayerPersistent(layerId: String, result: FLTMapInterfaces.Result<Boolean>) {
    val expected = mapboxMap.isStyleLayerPersistent(layerId)
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success(expected.value!!)
    }
  }

  override fun removeStyleLayer(layerId: String, result: FLTMapInterfaces.VoidResult) {
    val expected = mapboxMap.removeStyleLayer(layerId)
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun moveStyleLayer(
    layerId: String,
    layerPosition: FLTMapInterfaces.LayerPosition?,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected = mapboxMap.moveStyleLayer(
      layerId,
      if (layerPosition != null) LayerPosition(
        layerPosition.above,
        layerPosition.below,
        layerPosition.at?.toInt()
      ) else null
    )
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun styleLayerExists(layerId: String, result: FLTMapInterfaces.Result<Boolean>) {
    val expected = mapboxMap.styleLayerExists(layerId)
    result.success(expected)
  }

  override fun getStyleLayers(result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.StyleObjectInfo>>) {
    result.success(
      mapboxMap.styleLayers.map { it.toFLTStyleObjectInfo() }.toMutableList()
    )
  }

  override fun getStyleLayerProperty(
    layerId: String,
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    val styleLayerProperty = mapboxMap.getStyleLayerProperty(layerId, property)
    val stylePropertyValueKind =
      FLTMapInterfaces.StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
    val stylePropertyValue =
      FLTMapInterfaces.StylePropertyValue.Builder()
        .setValue(styleLayerProperty.value.toFLTValue())
        .setKind(stylePropertyValueKind).build()
    result.success(stylePropertyValue)
  }

  override fun setStyleLayerProperty(
    layerId: String,
    property: String,
    value: Any,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected =
      mapboxMap.setStyleLayerProperty(layerId, property, value.toValue())
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun getStyleLayerProperties(
    layerId: String,
    result: FLTMapInterfaces.Result<String>
  ) {
    val expected = mapboxMap.getStyleLayerProperties(layerId)
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success(expected.value!!.toJson())
    }
  }

  override fun setStyleLayerProperties(
    layerId: String,
    properties: String,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected = mapboxMap.setStyleLayerProperties(layerId, properties.toValue())
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun addStyleSource(
    sourceId: String,
    properties: String,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected = mapboxMap.addStyleSource(sourceId, properties.toValue())
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun getStyleSourceProperty(
    sourceId: String,
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    val styleLayerProperty = mapboxMap.getStyleSourceProperty(sourceId, property)
    val stylePropertyValueKind =
      FLTMapInterfaces.StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
    val value = styleLayerProperty.value.toFLTValue()
    val stylePropertyValue =
      FLTMapInterfaces.StylePropertyValue.Builder()
        .setValue(value)
        .setKind(stylePropertyValueKind).build()
    result.success(stylePropertyValue)
  }

  override fun setStyleSourceProperty(
    sourceId: String,
    property: String,
    value: Any,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected =
      mapboxMap.setStyleSourceProperty(sourceId, property, value.toValue())
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun getStyleSourceProperties(
    sourceId: String,
    result: FLTMapInterfaces.Result<String>
  ) {
    val expected = mapboxMap.getStyleSourceProperties(sourceId)
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success(expected.value!!.toJson())
    }
  }

  override fun setStyleSourceProperties(
    sourceId: String,
    properties: String,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected = mapboxMap.setStyleSourceProperties(sourceId, properties.toValue())
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun updateStyleImageSourceImage(
    sourceId: String,
    image: FLTMapInterfaces.MbxImage,
    result: FLTMapInterfaces.VoidResult
  ) {
    var bitmap = BitmapFactory.decodeByteArray(
      image.data,
      0,
      image.data.size
    )
    if (bitmap.config != Bitmap.Config.ARGB_8888) {
      bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, false)
    }
    val byteBuffer = ByteBuffer.allocateDirect(bitmap.byteCount)
    bitmap.copyPixelsToBuffer(byteBuffer)

    val expected = mapboxMap.updateStyleImageSourceImage(
      sourceId,
      Image(
        image.width.toInt(),
        image.height.toInt(),
        DataRef(byteBuffer)
      )
    )
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun removeStyleSource(sourceId: String, result: FLTMapInterfaces.VoidResult) {
    val expected = mapboxMap.removeStyleSource(sourceId)
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun styleSourceExists(sourceId: String, result: FLTMapInterfaces.Result<Boolean>) {
    val expected = mapboxMap.styleSourceExists(sourceId)
    result.success(expected)
  }

  override fun getStyleSources(result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.StyleObjectInfo>>) {
    result.success(
      mapboxMap.styleSources.map { it.toFLTStyleObjectInfo() }.toMutableList()
    )
  }

  override fun getStyleLights(): MutableList<FLTMapInterfaces.StyleObjectInfo> {
    return mapboxMap.style?.getStyleLights()?.map { it.toFLTStyleObjectInfo() }?.toMutableList()
      ?: mutableListOf()
  }

  override fun setLight(flatLight: FLTMapInterfaces.FlatLight) {
    mapboxMap.style?.setLight(flatLight.toFlatLight())
  }

  override fun setLights(
    ambientLight: FLTMapInterfaces.AmbientLight,
    directionalLight: FLTMapInterfaces.DirectionalLight
  ) {
    mapboxMap.style?.setLight(ambientLight.toAmbientLight(), directionalLight.toDirectionalLight())
  }

  fun setStyleLight(properties: String, result: FLTMapInterfaces.VoidResult) {
    val expected = mapboxMap.style?.setStyleLights(properties.toValue())
    if (expected?.isError == true) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun getStyleLightProperty(
    id: String,
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    val styleLightProperty = mapboxMap.style?.getStyleLightProperty(id, property)

    if (styleLightProperty != null) {
      result.success(
        FLTMapInterfaces.StylePropertyValue.Builder()
          .setKind(
            FLTMapInterfaces.StylePropertyValueKind.values()[styleLightProperty.kind.ordinal]
          )
          .setValue(styleLightProperty.value.toFLTValue()).build()
      )
    } else {
      result.error(Throwable("No style available"))
    }
  }

  override fun setStyleLightProperty(
    id: String,
    property: String,
    value: Any,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected = mapboxMap.style?.setStyleLightProperty(id, property, value.toValue())
    if (expected?.isError == true) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun setStyleTerrain(properties: String, result: FLTMapInterfaces.VoidResult) {
    val expected = mapboxMap.setStyleTerrain(properties.toValue())
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun getStyleTerrainProperty(
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    val styleProperty = mapboxMap.getStyleTerrainProperty(property)
    val stylePropertyValueKind =
      FLTMapInterfaces.StylePropertyValueKind.values()[styleProperty.kind.ordinal]
    val stylePropertyValue =
      FLTMapInterfaces.StylePropertyValue.Builder().setValue(styleProperty.value.toFLTValue())
        .setKind(stylePropertyValueKind).build()
    result.success(stylePropertyValue)
  }

  override fun setStyleTerrainProperty(
    property: String,
    value: Any,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected = mapboxMap.setStyleTerrainProperty(property, value.toValue())
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun getStyleImage(
    imageId: String,
    result: FLTMapInterfaces.NullableResult<FLTMapInterfaces.MbxImage>
  ) {
    mapboxMap.getStyleImage(imageId)?.let { image ->
      val byteArray = ByteArray(image.data.buffer.capacity())
      image.data.buffer.get(byteArray)
      result.success(
        FLTMapInterfaces.MbxImage.Builder()
          .setWidth(image.width.toLong())
          .setHeight(image.height.toLong())
          .setData(byteArray)
          .build()
      )
    }
    result.success(null)
  }

  override fun removeStyleImage(imageId: String, result: FLTMapInterfaces.VoidResult) {
    val expected = mapboxMap.removeStyleImage(imageId)
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun hasStyleImage(imageId: String, result: FLTMapInterfaces.Result<Boolean>) {
    mapboxMap.hasStyleImage(imageId)
  }

  override fun invalidateStyleCustomGeometrySourceTile(
    sourceId: String,
    tileId: FLTMapInterfaces.CanonicalTileID,
    result: FLTMapInterfaces.VoidResult
  ) {
    val expected = mapboxMap.invalidateStyleCustomGeometrySourceTile(
      sourceId,
      CanonicalTileID(
        tileId.z.toByte(), tileId.x.toInt(), tileId.y.toInt()
      )
    )
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }

  override fun invalidateStyleCustomGeometrySourceRegion(
    sourceId: String,
    bounds: FLTMapInterfaces.CoordinateBounds,
    result: FLTMapInterfaces.VoidResult
  ) {
    mapboxMap.invalidateStyleCustomGeometrySourceRegion(
      sourceId,
      bounds.toCoordinateBounds()
    )
    result.success()
  }

  override fun isStyleLoaded(result: FLTMapInterfaces.Result<Boolean>) {
    result.success(mapboxMap.isStyleLoaded())
  }

  override fun getProjection(): FLTMapInterfaces.StyleProjection? {
    return mapboxMap.style?.getProjection()?.toFLTProjection()
  }

  override fun setProjection(projection: FLTMapInterfaces.StyleProjection) {
    mapboxMap.style?.setProjection(projection.toProjection())
  }

  override fun localizeLabels(
    locale: String,
    layerIds: MutableList<String>?,
    result: FLTMapInterfaces.VoidResult
  ) {
    mapboxMap.style?.localizeLabels(Locale(locale), layerIds)
    result.success()
  }

  override fun addStyleImage(
    imageId: String,
    scale: Double,
    image: FLTMapInterfaces.MbxImage,
    sdf: Boolean,
    stretchX: MutableList<FLTMapInterfaces.ImageStretches>,
    stretchY: MutableList<FLTMapInterfaces.ImageStretches>,
    content: FLTMapInterfaces.ImageContent?,
    result: FLTMapInterfaces.VoidResult
  ) {
    var bitmap = BitmapFactory.decodeByteArray(
      image.data,
      0,
      image.data.size
    )
    if (bitmap.config != Bitmap.Config.ARGB_8888) {
      bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, false)
    }
    val byteBuffer = ByteBuffer.allocateDirect(bitmap.byteCount)
    bitmap.copyPixelsToBuffer(byteBuffer)
    val expected = mapboxMap.addStyleImage(
      imageId, scale.toFloat(),
      Image(
        image.width.toInt(),
        image.height.toInt(),
        DataRef(byteBuffer)
      ),
      sdf,
      stretchX.map {
        ImageStretches(
          it.first.toFloat(),
          it.second.toFloat()
        )
      }.toMutableList(),
      stretchY.map { ImageStretches(it.first.toFloat(), it.second.toFloat()) }.toMutableList(),
      if (content != null) ImageContent(
        content.left.toFloat(),
        content.top.toFloat(), content.right.toFloat(), content.bottom.toFloat()
      ) else null
    )
    if (expected.isError) {
      result.error(Throwable(expected.error))
    } else {
      result.success()
    }
  }
}

fun Any.toValue(): Value {
  return if (this is String) {
    if (this.startsWith("{") || this.startsWith("[")) {
      Value.fromJson(this).value!!
    } else {
      val number = this.toDoubleOrNull()
      if (number != null) {
        Value.valueOf(number)
      } else {
        Value.valueOf(this)
      }
    }
  } else if (this is Double) {
    Value.valueOf(this)
  } else if (this is Long) {
    Value.valueOf(this)
  } else if (this is Int) {
    Value.valueOf(this.toLong())
  } else if (this is Boolean) {
    Value.valueOf(this)
  } else if (this is IntArray) {
    val valueArray = this.map { Value(it.toLong()) }
    Value(valueArray)
  } else if (this is BooleanArray) {
    val valueArray = this.map(::Value)
    Value(valueArray)
  } else if (this is DoubleArray) {
    val valueArray = this.map(::Value)
    Value(valueArray)
  } else if (this is FloatArray) {
    val valueArray = this.map { Value(it.toDouble()) }
    Value(valueArray)
  } else if (this is LongArray) {
    val valueArray = this.map(::Value)
    Value(valueArray)
  } else if (this is Array<*>) {
    val valueArray = this.map { it?.toValue() }
    Value(valueArray)
  } else if (this is List<*>) {
    val valueArray = this.map { it?.toValue() }
    Value(valueArray)
  } else {
    logE(
      "StyleController",
      "Can not map value, type is not supported: ${this::class.java.canonicalName}"
    )
    Value.valueOf("")
  }
}

fun Value.toFLTValue(): Any? {
  return when (contents) {
    is List<*> -> {
      (contents as List<*>).map { (it as? Value)?.toFLTValue() ?: it }
    }
    is Map<*, *> -> {
      (contents as Map<*, *>)
        .mapKeys { (it.key as? Value)?.toFLTValue() ?: it.key }
        .mapValues { (it.value as? Value)?.toFLTValue() ?: it.value }
    }
    else -> {
      contents
    }
  }
}