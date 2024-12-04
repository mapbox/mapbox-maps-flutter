package com.mapbox.maps.mapbox_maps

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.bindgen.DataRef
import com.mapbox.bindgen.Value
import com.mapbox.geojson.Feature
import com.mapbox.maps.Image
import com.mapbox.maps.MapboxStyleManager
import com.mapbox.maps.RuntimeStylingOptions
import com.mapbox.maps.extension.localization.localizeLabels
import com.mapbox.maps.extension.style.light.setLight
import com.mapbox.maps.extension.style.projection.generated.getProjection
import com.mapbox.maps.extension.style.projection.generated.setProjection
import com.mapbox.maps.mapbox_maps.pigeons.AmbientLight
import com.mapbox.maps.mapbox_maps.pigeons.CameraOptions
import com.mapbox.maps.mapbox_maps.pigeons.CanonicalTileID
import com.mapbox.maps.mapbox_maps.pigeons.CoordinateBounds
import com.mapbox.maps.mapbox_maps.pigeons.DirectionalLight
import com.mapbox.maps.mapbox_maps.pigeons.FlatLight
import com.mapbox.maps.mapbox_maps.pigeons.ImageContent
import com.mapbox.maps.mapbox_maps.pigeons.ImageStretches
import com.mapbox.maps.mapbox_maps.pigeons.LayerPosition
import com.mapbox.maps.mapbox_maps.pigeons.MbxImage
import com.mapbox.maps.mapbox_maps.pigeons.StyleManager
import com.mapbox.maps.mapbox_maps.pigeons.StyleObjectInfo
import com.mapbox.maps.mapbox_maps.pigeons.StyleProjection
import com.mapbox.maps.mapbox_maps.pigeons.StylePropertyValue
import com.mapbox.maps.mapbox_maps.pigeons.StylePropertyValueKind
import com.mapbox.maps.mapbox_maps.pigeons.TransitionOptions
import java.nio.ByteBuffer
import java.util.Locale

class StyleController(private val context: Context, private val styleManager: MapboxStyleManager) :
  StyleManager {
  override fun getStyleURI(callback: (Result<String>) -> Unit) {
    callback(Result.success(styleManager.styleURI))
  }

  @SuppressLint("RestrictedApi")
  override fun setStyleURI(uri: String, callback: (Result<Unit>) -> Unit) {
    val options = RuntimeStylingOptions.Builder()
      .completedCallback { callback(Result.success(Unit)) }
      .errorCallback { _, mapLoadingError -> callback(Result.failure(Throwable(mapLoadingError.message))) }
      .build()
    styleManager.styleManager.setStyleURI(uri, options)
  }

  override fun getStyleJSON(callback: (Result<String>) -> Unit) {
    callback(Result.success(styleManager.styleJSON))
  }

  @SuppressLint("RestrictedApi")
  override fun setStyleJSON(json: String, callback: (Result<Unit>) -> Unit) {
    val options = RuntimeStylingOptions.Builder()
      .completedCallback { callback(Result.success(Unit)) }
      .errorCallback { _, mapLoadingError -> callback(Result.failure(Throwable(mapLoadingError.message))) }
      .build()
    styleManager.styleManager.setStyleJSON(json, options)
  }

  override fun getStyleDefaultCamera(callback: (Result<CameraOptions>) -> Unit) {
    val camera = styleManager.styleDefaultCamera
    callback(Result.success(camera.toFLTCameraOptions(context)))
  }

  override fun getStyleTransition(callback: (Result<TransitionOptions>) -> Unit) {
    val transitionOptions = styleManager.getStyleTransition()
    callback(
      Result.success(
        TransitionOptions(
          duration = transitionOptions.duration,
          delay = transitionOptions.delay,
          enablePlacementTransitions = transitionOptions.enablePlacementTransitions
        )
      )
    )
  }

  override fun getStyleImports(): List<StyleObjectInfo> {
    return styleManager.getStyleImports().map { it.toFLTStyleObjectInfo() }
  }

  override fun removeStyleImport(importId: String) {
    styleManager.removeStyleImport(importId)
  }

  override fun getStyleImportSchema(importId: String): Any {
    return styleManager.getStyleImportSchema(importId)
      .getValueOrElse {
        throw RuntimeException(it)
      }
  }

  override fun getStyleImportConfigProperties(importId: String): Map<String, StylePropertyValue> {
    return styleManager.getStyleImportConfigProperties(importId)
      .getValueOrElse { throw RuntimeException(it) }
      .mapValues { it.value.toFLTStylePropertyValue() }
      .toMutableMap()
  }

  override fun getStyleImportConfigProperty(
    importId: String,
    config: String
  ): StylePropertyValue {
    return styleManager.getStyleImportConfigProperty(importId, config)
      .getValueOrElse { throw RuntimeException(it) }
      .toFLTStylePropertyValue()
  }

  override fun setStyleImportConfigProperties(importId: String, configs: Map<String, Any>) {
    styleManager.setStyleImportConfigProperties(
      importId,
      configs.mapValues { it.toValue() } as HashMap<String, Value>
    )
  }

  override fun setStyleImportConfigProperty(importId: String, config: String, value: Any) {
    styleManager.setStyleImportConfigProperty(importId, config, value.toValue())
  }

  override fun setStyleTransition(
    transitionOptions: TransitionOptions,
    callback: (Result<Unit>) -> Unit
  ) {
    styleManager.setStyleTransition(
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
      val expected = styleManager.addStyleLayer(
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
      val expected = styleManager.addPersistentStyleLayer(
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
    val expected = styleManager.isStyleLayerPersistent(layerId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(expected.value!!))
    }
  }

  override fun removeStyleLayer(layerId: String, callback: (Result<Unit>) -> Unit) {
    val expected = styleManager.removeStyleLayer(layerId)
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
    val expected = styleManager.moveStyleLayer(
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
    val expected = styleManager.styleLayerExists(layerId)
    callback(Result.success(expected))
  }

  override fun getStyleLayers(callback: (Result<List<StyleObjectInfo?>>) -> Unit) {
    callback(
      Result.success(
        styleManager.styleLayers.map { it.toFLTStyleObjectInfo() }.toMutableList()
      )
    )
  }

  override fun getStyleLayerProperty(
    layerId: String,
    property: String,
    callback: (Result<StylePropertyValue>) -> Unit
  ) {
    val styleLayerProperty = styleManager.getStyleLayerProperty(layerId, property)
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
      styleManager.setStyleLayerProperty(layerId, property, value.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleLayerProperties(layerId: String, callback: (Result<String>) -> Unit) {
    val expected = styleManager.getStyleLayerProperties(layerId)
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
    val expected = styleManager.setStyleLayerProperties(layerId, properties.toValue())
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
    val expected = styleManager.addStyleSource(sourceId, properties.toValue())
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
    val styleLayerProperty = styleManager.getStyleSourceProperty(sourceId, property)
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
      styleManager.setStyleSourceProperty(sourceId, property, value.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleSourceProperties(sourceId: String, callback: (Result<String>) -> Unit) {
    val expected = styleManager.getStyleSourceProperties(sourceId)
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
    val expected = styleManager.setStyleSourceProperties(sourceId, properties.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun addGeoJSONSourceFeatures(
    sourceId: String,
    dataId: String,
    features: List<Feature>,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = styleManager.addGeoJSONSourceFeatures(sourceId, dataId, features)
    callback(Result.success(Unit))
  }

  override fun updateGeoJSONSourceFeatures(
    sourceId: String,
    dataId: String,
    features: List<Feature>,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = styleManager.updateGeoJSONSourceFeatures(sourceId, dataId, features)
    callback(Result.success(Unit))
  }

  override fun removeGeoJSONSourceFeatures(
    sourceId: String,
    dataId: String,
    featureIds: List<String>,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = styleManager.removeGeoJSONSourceFeatures(sourceId, dataId, featureIds)
    callback(Result.success(Unit))
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

    val expected = styleManager.updateStyleImageSourceImage(
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
    val expected = styleManager.removeStyleSource(sourceId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun styleSourceExists(sourceId: String, callback: (Result<Boolean>) -> Unit) {
    val expected = styleManager.styleSourceExists(sourceId)
    callback(Result.success(expected))
  }

  override fun getStyleSources(callback: (Result<List<StyleObjectInfo?>>) -> Unit) {
    callback(
      Result.success(
        styleManager.styleSources.map { it.toFLTStyleObjectInfo() }.toMutableList()
      )
    )
  }

  override fun getStyleLights(): List<StyleObjectInfo> {
    return styleManager.getStyleLights().map { it.toFLTStyleObjectInfo() }
  }

  override fun setLight(flatLight: FlatLight) {
    styleManager.setLight(flatLight.toFlatLight())
  }

  override fun setLights(
    ambientLight: AmbientLight,
    directionalLight: DirectionalLight
  ) {
    styleManager.setLight(ambientLight.toAmbientLight(), directionalLight.toDirectionalLight())
  }

  override fun getStyleLightProperty(
    id: String,
    property: String,
    callback: (Result<StylePropertyValue>) -> Unit
  ) {
    val styleLightProperty = styleManager.getStyleLightProperty(id, property)

    callback(
      Result.success(
        StylePropertyValue(
          styleLightProperty.value.toFLTValue(),
          StylePropertyValueKind.values()[styleLightProperty.kind.ordinal]
        )
      )
    )
  }

  override fun setStyleLightProperty(
    id: String,
    property: String,
    value: Any,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = styleManager.setStyleLightProperty(id, property, value.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun setStyleTerrain(properties: String, callback: (Result<Unit>) -> Unit) {
    val expected = styleManager.setStyleTerrain(properties.toValue())
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
    val styleProperty = styleManager.getStyleTerrainProperty(property)
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
    val expected = styleManager.setStyleTerrainProperty(property, value.toValue())
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun getStyleImage(imageId: String, callback: (Result<MbxImage?>) -> Unit) {
    val image = styleManager.getStyleImage(imageId)

    if (image == null) {
      callback(Result.success(null))
      return
    }

    val buffer = image.data.buffer.also { it.rewind() }
    val byteArray = ByteArray(buffer.capacity())
    buffer.get(byteArray)
    callback(
      Result.success(
        MbxImage(width = image.width.toLong(), height = image.height.toLong(), data = byteArray)
      )
    )
  }

  override fun removeStyleImage(imageId: String, callback: (Result<Unit>) -> Unit) {
    val expected = styleManager.removeStyleImage(imageId)
    if (expected.isError) {
      callback(Result.failure(Throwable(expected.error)))
    } else {
      callback(Result.success(Unit))
    }
  }

  override fun hasStyleImage(imageId: String, callback: (Result<Boolean>) -> Unit) {
    callback(Result.success(styleManager.hasStyleImage(imageId)))
  }

  override fun invalidateStyleCustomGeometrySourceTile(
    sourceId: String,
    tileId: CanonicalTileID,
    callback: (Result<Unit>) -> Unit
  ) {
    val expected = styleManager.invalidateStyleCustomGeometrySourceTile(
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
    styleManager.invalidateStyleCustomGeometrySourceRegion(
      sourceId,
      bounds.toCoordinateBounds()
    )
    callback(Result.success(Unit))
  }

  override fun isStyleLoaded(callback: (Result<Boolean>) -> Unit) {
    callback(Result.success(styleManager.isStyleLoaded()))
  }

  override fun getProjection(): StyleProjection? {
    return styleManager.getProjection()?.toFLTProjection()
  }

  override fun setProjection(projection: StyleProjection) {
    styleManager.setProjection(projection.toProjection())
  }

  override fun localizeLabels(
    locale: String,
    layerIds: List<String>?,
    callback: (Result<Unit>) -> Unit
  ) {
    styleManager.localizeLabels(Locale(locale), layerIds)
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
    val expected = styleManager.addStyleImage(
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
          it.second.toFloat()
        )
      },
      stretchY.map { com.mapbox.maps.ImageStretches(it!!.first.toFloat(), it.second.toFloat()) }
        .toMutableList(),
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

  override fun addStyleModel(modelId: String, modelUri: String, callback: (Result<Unit>) -> Unit) {
    styleManager.addStyleModel(modelId, modelUri)
      .handleResult(callback)
  }

  override fun removeStyleModel(modelId: String, callback: (Result<Unit>) -> Unit) {
    styleManager.removeStyleModel(modelId)
      .handleResult(callback)
  }
}