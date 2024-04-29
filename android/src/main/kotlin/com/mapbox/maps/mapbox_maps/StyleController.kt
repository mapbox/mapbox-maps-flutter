package com.mapbox.maps.mapbox_maps

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.bindgen.DataRef
import com.mapbox.bindgen.Value
import com.mapbox.maps.Image
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.extension.localization.localizeLabels
import com.mapbox.maps.extension.style.light.setLight
import com.mapbox.maps.extension.style.projection.generated.getProjection
import com.mapbox.maps.extension.style.projection.generated.setProjection
import com.mapbox.maps.logE
import com.mapbox.maps.mapbox_maps.pigeons.*
import java.lang.RuntimeException
import java.nio.ByteBuffer
import java.util.HashMap
import java.util.Locale

class StyleController(private val mapboxMap: MapboxMap, private val context: Context) :
  StyleManager {
  override fun getStyleURI(callback: (Result<String>) -> Unit) {
    callback(Result.success(mapboxMap.style?.styleURI ?: ""))
  }

  override fun setStyleURI(uri: String, callback: (Result<Unit>) -> Unit) {
    mapboxMap.loadStyle(uri) {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleJSON(callback: (Result<String>) -> Unit) {
    callback(Result.success(mapboxMap.style?.styleJSON ?: ""))
  }

  override fun setStyleJSON(json: String, callback: (Result<Unit>) -> Unit) {
    mapboxMap.loadStyle(json) {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleDefaultCamera(callback: (Result<CameraOptions>) -> Unit) {
    val camera = mapboxMap.styleDefaultCamera
    callback(Result.success(camera.toFLTCameraOptions(context)))
  }

  override fun getStyleTransition(callback: (Result<TransitionOptions>) -> Unit) {
    val transitionOptions = mapboxMap.getStyleTransition()
    callback(
      Result.success(
        TransitionOptions(duration = transitionOptions.duration, delay = transitionOptions.delay, enablePlacementTransitions = transitionOptions.enablePlacementTransitions)
      )
    )
  }

  override fun getStyleImports(): List<StyleObjectInfo> {
    return mapboxMap.getStyleImports().map { it.toFLTStyleObjectInfo() }
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

  override fun getStyleImportConfigProperties(importId: String): Map<String, StylePropertyValue> {
    return mapboxMap.getStyleImportConfigProperties(importId)
      .getValueOrElse { throw RuntimeException(it) }
      .mapValues { it.value.toFLTStylePropertyValue() }
      .toMutableMap()
  }

  override fun getStyleImportConfigProperty(
    importId: String,
    config: String
  ): StylePropertyValue {
    return mapboxMap.getStyleImportConfigProperty(importId, config)
      .getValueOrElse { throw RuntimeException(it) }
      .toFLTStylePropertyValue()
  }

  override fun setStyleImportConfigProperties(importId: String, configs: Map<String, Any>) {
    mapboxMap.setStyleImportConfigProperties(
      importId,
      configs.mapValues { it.toValue() } as HashMap<String, Value>
    )
  }

  override fun setStyleImportConfigProperty(importId: String, config: String, value: Any) {
    mapboxMap.setStyleImportConfigProperty(importId, config, value.toValue())
  }

  override fun setStyleTransition(
    transitionOptions: TransitionOptions,
    callback: (Result<Unit>) -> Unit
  ) {
    mapboxMap.setStyleTransition(
      com.mapbox.maps.TransitionOptions.Builder()
        .delay(transitionOptions.delay)
        .duration(transitionOptions.duration)
        .enablePlacementTransitions(transitionOptions.enablePlacementTransitions).build()
    )
    callback(Result.success(Unit))
  }

  override fun addStyleLayer(
    properties: String,
    layerPosition: LayerPosition?,
    callback: (Result<Unit>) -> Unit
  ) {
    properties.toValue().let { parameters ->
      val expected = mapboxMap.addStyleLayer(
        parameters,
        com.mapbox.maps.LayerPosition(
          layerPosition?.above,
          layerPosition?.below,
          layerPosition?.at?.toInt()
        )
      )
      if (expected.isError) {
        callback(Result.failure(Throwable(expected.error)))
      } else {
        callback(Result.success(Unit))
      }
    }
  }

  override fun addPersistentStyleLayer(
    properties: String,
    layerPosition: LayerPosition?,
    callback: (Result<Unit>) -> Unit
  ) {
    properties.toValue().let { parameters ->
      val expected = mapboxMap.addPersistentStyleLayer(
        parameters,
        com.mapbox.maps.LayerPosition(
          layerPosition?.above,
          layerPosition?.below,
          layerPosition?.at?.toInt()
        )
      )
      if (expected.isError) {
        callback(Result.failure(Throwable(expected.error)))
      } else {
        callback(Result.success(Unit))
      }
    }
  }

  override fun isStyleLayerPersistent(layerId: String, callback: (Result<Boolean>) -> Unit) {
    val expected = mapboxMap.isStyleLayerPersistent(layerId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(expected.value!!))
    }
  }

  override fun removeStyleLayer(layerId: String, callback: (Result<Unit>) -> Unit) {
    val expected = mapboxMap.removeStyleLayer(layerId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun moveStyleLayer(
    layerId: String,
    layerPosition: LayerPosition?,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = mapboxMap.moveStyleLayer(
      layerId,
      if (layerPosition != null) com.mapbox.maps.LayerPosition(
        layerPosition.above,
        layerPosition.below,
        layerPosition.at?.toInt()
      ) else null
    )
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun styleLayerExists(layerId: String, callback: (Result<Boolean>) -> Unit) {
    val expected = mapboxMap.styleLayerExists(layerId)
    callback(Result.success(expected))
  }

  override fun getStyleLayers(callback: (Result<List<StyleObjectInfo?>>) -> Unit) {
    callback(
      Result.success(
        mapboxMap.styleLayers.map { it.toFLTStyleObjectInfo() }.toMutableList()
      )
    )
  }

  override fun getStyleLayerProperty(
    layerId: String,
    property: String,
    callback: (Result<StylePropertyValue>) -> Unit
  ) {
    val styleLayerProperty = mapboxMap.getStyleLayerProperty(layerId, property)
    val stylePropertyValueKind =
      StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
    val stylePropertyValue =
      StylePropertyValue(styleLayerProperty.value.toFLTValue(), stylePropertyValueKind)
    callback(Result.success(stylePropertyValue))
  }

  override fun setStyleLayerProperty(
    layerId: String,
    property: String,
    value: Any,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected =
      mapboxMap.setStyleLayerProperty(layerId, property, value.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleLayerProperties(layerId: String, callback: (Result<String>) -> Unit) {
    val expected = mapboxMap.getStyleLayerProperties(layerId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(expected.value!!.toJson()))
    }
  }

  override fun setStyleLayerProperties(
    layerId: String,
    properties: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = mapboxMap.setStyleLayerProperties(layerId, properties.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun addStyleSource(
    sourceId: String,
    properties: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = mapboxMap.addStyleSource(sourceId, properties.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleSourceProperty(
    sourceId: String,
    property: String,
    callback: (Result<StylePropertyValue>) -> Unit
  ) {
    val styleLayerProperty = mapboxMap.getStyleSourceProperty(sourceId, property)
    val stylePropertyValueKind =
      StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
    val value = styleLayerProperty.value.toFLTValue()
    val stylePropertyValue =
      StylePropertyValue(value, stylePropertyValueKind)
    callback(Result.success(stylePropertyValue))
  }

  override fun setStyleSourceProperty(
    sourceId: String,
    property: String,
    value: Any,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected =
      mapboxMap.setStyleSourceProperty(sourceId, property, value.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleSourceProperties(sourceId: String, callback: (Result<String>) -> Unit) {
    val expected = mapboxMap.getStyleSourceProperties(sourceId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(expected.value!!.toJson()))
    }
  }

  override fun setStyleSourceProperties(
    sourceId: String,
    properties: String,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = mapboxMap.setStyleSourceProperties(sourceId, properties.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun updateStyleImageSourceImage(
    sourceId: String,
    image: MbxImage,
    callback: (Result<Unit>) -> Unit
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
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun removeStyleSource(sourceId: String, callback: (Result<Unit>) -> Unit) {
    val expected = mapboxMap.removeStyleSource(sourceId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun styleSourceExists(sourceId: String, callback: (Result<Boolean>) -> Unit) {
    val expected = mapboxMap.styleSourceExists(sourceId)
    callback(Result.success(expected))
  }

  override fun getStyleSources(callback: (Result<List<StyleObjectInfo?>>) -> Unit) {
    callback(
      Result.success(
        mapboxMap.styleSources.map { it.toFLTStyleObjectInfo() }.toMutableList()
      )
    )
  }

  override fun getStyleLights(): List<StyleObjectInfo> {
    return mapboxMap.style?.getStyleLights()?.map { it.toFLTStyleObjectInfo() }
      ?: listOf()
  }

  override fun setLight(flatLight: FlatLight) {
    mapboxMap.style?.setLight(flatLight.toFlatLight())
  }

  override fun setLights(
    ambientLight: AmbientLight,
    directionalLight: DirectionalLight
  ) {
    mapboxMap.style?.setLight(ambientLight.toAmbientLight(), directionalLight.toDirectionalLight())
  }

  override fun getStyleLightProperty(
    id: String,
    property: String,
    callback: (Result<StylePropertyValue>) -> Unit
  ) {
    val styleLightProperty = mapboxMap.style?.getStyleLightProperty(id, property)

    if (styleLightProperty != null) {
      callback(
        Result.success(
          StylePropertyValue(styleLightProperty.value.toFLTValue(), StylePropertyValueKind.values()[styleLightProperty.kind.ordinal])
        )
      )
    } else {
      callback(Result.failure(Throwable("No style available")))
    }
  }

  override fun setStyleLightProperty(
    id: String,
    property: String,
    value: Any,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = mapboxMap.style?.setStyleLightProperty(id, property, value.toValue())
    if (expected?.isError == true) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun setStyleTerrain(properties: String, callback: (Result<Unit>) -> Unit) {
    val expected = mapboxMap.setStyleTerrain(properties.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleTerrainProperty(
    property: String,
    callback: (Result<StylePropertyValue>) -> Unit
  ) {
    val styleProperty = mapboxMap.getStyleTerrainProperty(property)
    val stylePropertyValueKind =
      StylePropertyValueKind.values()[styleProperty.kind.ordinal]
    val stylePropertyValue =
      StylePropertyValue(styleProperty.value.toFLTValue(), stylePropertyValueKind)
    callback(Result.success(stylePropertyValue))
  }

  override fun setStyleTerrainProperty(
    property: String,
    value: Any,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = mapboxMap.setStyleTerrainProperty(property, value.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleImage(imageId: String, callback: (Result<MbxImage?>) -> Unit) {
    val image = mapboxMap.getStyleImage(imageId)

    if (image == null) {
      callback(Result.success(null))
      return
    }

    val byteArray = ByteArray(image.data.buffer.capacity())
    image.data.buffer.get(byteArray)
    callback(
      Result.success(
        MbxImage(width = image.width.toLong(), height = image.height.toLong(), data = byteArray)
      )
    )
  }

  override fun removeStyleImage(imageId: String, callback: (Result<Unit>) -> Unit) {
    val expected = mapboxMap.removeStyleImage(imageId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun hasStyleImage(imageId: String, callback: (Result<Boolean>) -> Unit) {
    callback(Result.success(mapboxMap.hasStyleImage(imageId)))
  }

  override fun invalidateStyleCustomGeometrySourceTile(
    sourceId: String,
    tileId: CanonicalTileID,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = mapboxMap.invalidateStyleCustomGeometrySourceTile(
      sourceId,
      com.mapbox.maps.CanonicalTileID(
        tileId.z.toByte(), tileId.x.toInt(), tileId.y.toInt()
      )
    )
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun invalidateStyleCustomGeometrySourceRegion(
    sourceId: String,
    bounds: CoordinateBounds,
    callback: (Result<Unit>) -> Unit
  ) {
    mapboxMap.invalidateStyleCustomGeometrySourceRegion(
      sourceId,
      bounds.toCoordinateBounds()
    )
    callback(Result.success(Unit))
  }

  override fun isStyleLoaded(callback: (Result<Boolean>) -> Unit) {
    callback(Result.success(mapboxMap.isStyleLoaded()))
  }

  override fun getProjection(): StyleProjection? {
    return mapboxMap.style?.getProjection()?.toFLTProjection()
  }

  override fun setProjection(projection: StyleProjection) {
    mapboxMap.style?.setProjection(projection.toProjection())
  }

  override fun localizeLabels(
    locale: String,
    layerIds: List<String>?,
    callback: (Result<Unit>) -> Unit
  ) {
    mapboxMap.style?.localizeLabels(Locale(locale), layerIds)
    callback(Result.success(Unit))
  }

  override fun addStyleImage(
    imageId: String,
    scale: Double,
    image: MbxImage,
    sdf: Boolean,
    stretchX: List<ImageStretches?>,
    stretchY: List<ImageStretches?>,
    content: ImageContent?,
    callback: (Result<Unit>) -> Unit
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
        com.mapbox.maps.ImageStretches(
          it!!.first.toFloat(),
          it!!.second.toFloat()
        )
      },
      stretchY.map { com.mapbox.maps.ImageStretches(it!!.first.toFloat(), it!!.second.toFloat()) }.toMutableList(),
      if (content != null) com.mapbox.maps.ImageContent(
        content.left.toFloat(),
        content.top.toFloat(), content.right.toFloat(), content.bottom.toFloat()
      ) else null
    )
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
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