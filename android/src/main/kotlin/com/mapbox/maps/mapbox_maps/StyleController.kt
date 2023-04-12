package com.mapbox.maps.mapbox_maps

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.mapbox.bindgen.Value
import com.mapbox.common.Logger
import com.mapbox.maps.*
import com.mapbox.maps.extension.localization.localizeLabels
import com.mapbox.maps.extension.style.layers.properties.generated.ProjectionName
import com.mapbox.maps.extension.style.projection.generated.Projection
import com.mapbox.maps.extension.style.projection.generated.getProjection
import com.mapbox.maps.extension.style.projection.generated.setProjection
import com.mapbox.maps.pigeons.FLTMapInterfaces
import java.nio.ByteBuffer
import java.util.Locale

class StyleController(private val mapboxMap: MapboxMap) : FLTMapInterfaces.StyleManager {
  override fun getStyleURI(result: FLTMapInterfaces.Result<String>) {
    mapboxMap.getStyle {
      result.success(it.styleURI)
    }
  }

  override fun setStyleURI(uri: String, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      it.styleURI = uri
      result.success(null)
    }
  }

  override fun getStyleJSON(result: FLTMapInterfaces.Result<String>) {
    mapboxMap.getStyle {
      result.success(it.styleJSON)
    }
  }

  override fun setStyleJSON(json: String, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      it.styleJSON = json
      result.success(null)
    }
  }

  override fun getStyleDefaultCamera(result: FLTMapInterfaces.Result<FLTMapInterfaces.CameraOptions>?) {
    mapboxMap.getStyle {
      val camera = it.styleDefaultCamera
      result?.success(camera.toFLTCameraOptions())
    }
  }

  override fun getStyleTransition(result: FLTMapInterfaces.Result<FLTMapInterfaces.TransitionOptions>) {
    mapboxMap.getStyle {
      val transitionOptions = it.styleTransition
      result.success(
        FLTMapInterfaces.TransitionOptions.Builder().setDelay(transitionOptions.delay)
          .setDuration(transitionOptions.duration)
          .setEnablePlacementTransitions(transitionOptions.enablePlacementTransitions)
          .build()
      )
    }
  }

  override fun setStyleTransition(
    transitionOptions: FLTMapInterfaces.TransitionOptions,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      it.styleTransition = TransitionOptions.Builder().delay(transitionOptions.delay)
        .duration(transitionOptions.duration)
        .enablePlacementTransitions(transitionOptions.enablePlacementTransitions).build()
      result.success(null)
    }
  }

  override fun addStyleLayer(
    properties: String,
    layerPosition: FLTMapInterfaces.LayerPosition?,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      properties.toValue().let { parameters ->
        val expected = it.addStyleLayer(
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
          result.success(null)
        }
      }
    }
  }

  override fun addPersistentStyleLayer(
    properties: String,
    layerPosition: FLTMapInterfaces.LayerPosition?,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      properties.toValue().let { parameters ->
        val expected = it.addPersistentStyleLayer(
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
          result.success(null)
        }
      }
    }
  }

  override fun isStyleLayerPersistent(layerId: String, result: FLTMapInterfaces.Result<Boolean>) {
    mapboxMap.getStyle {
      val expected = it.isStyleLayerPersistent(layerId)
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(expected.value)
      }
    }
  }

  override fun removeStyleLayer(layerId: String, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      val expected = it.removeStyleLayer(layerId)
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun moveStyleLayer(
    layerId: String,
    layerPosition: FLTMapInterfaces.LayerPosition?,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      val expected = it.moveStyleLayer(
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
        result.success(null)
      }
    }
  }

  override fun styleLayerExists(layerId: String, result: FLTMapInterfaces.Result<Boolean>) {
    mapboxMap.getStyle {
      val expected = it.styleLayerExists(layerId)
      result.success(expected)
    }
  }

  override fun getStyleLayers(result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.StyleObjectInfo>>) {
    mapboxMap.getStyle {
      result.success(
        it.styleLayers.map { styleObjectInfo ->
          FLTMapInterfaces.StyleObjectInfo.Builder().setId(styleObjectInfo.id)
            .setType(styleObjectInfo.type).build()
        }.toMutableList()
      )
    }
  }

  override fun getStyleLayerProperty(
    layerId: String,
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    mapboxMap.getStyle {
      val styleLayerProperty = it.getStyleLayerProperty(layerId, property)
      val stylePropertyValueKind =
        FLTMapInterfaces.StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
      val stylePropertyValue =
        FLTMapInterfaces.StylePropertyValue.Builder()
          .setValue(styleLayerProperty.value.toString())
          .setKind(stylePropertyValueKind).build()
      result.success(stylePropertyValue)
    }
  }

  override fun setStyleLayerProperty(
    layerId: String,
    property: String,
    value: Any,
    result: FLTMapInterfaces.Result<Void>?
  ) {
    mapboxMap.getStyle {
      val expected =
        it.setStyleLayerProperty(layerId, property, value.toValue())
      if (expected.isError) {
        result?.error(Throwable(expected.error))
      } else {
        result?.success(null)
      }
    }
  }

  override fun getStyleLayerProperties(
    layerId: String,
    result: FLTMapInterfaces.Result<String>
  ) {
    mapboxMap.getStyle {
      val expected = it.getStyleLayerProperties(layerId)
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(expected.value?.toJson())
      }
    }
  }

  override fun setStyleLayerProperties(
    layerId: String,
    properties: String,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      val expected = it.setStyleLayerProperties(layerId, properties.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun addStyleSource(
    sourceId: String,
    properties: String,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      val expected = it.addStyleSource(sourceId, properties.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun getStyleSourceProperty(
    sourceId: String,
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    mapboxMap.getStyle {
      val styleLayerProperty = it.getStyleSourceProperty(sourceId, property)
      val stylePropertyValueKind =
        FLTMapInterfaces.StylePropertyValueKind.values()[styleLayerProperty.kind.ordinal]
      val value = if (property == "tiles" || property == "bounds" || property == "clusterProperties") {
        styleLayerProperty.value.toJson()
      } else {
        styleLayerProperty.value.toString()
      }
      val stylePropertyValue =
        FLTMapInterfaces.StylePropertyValue.Builder()
          .setValue(value)
          .setKind(stylePropertyValueKind).build()
      result.success(stylePropertyValue)
    }
  }

  override fun setStyleSourceProperty(
    sourceId: String,
    property: String,
    value: Any,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      val expected =
        it.setStyleSourceProperty(sourceId, property, value.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun getStyleSourceProperties(
    sourceId: String,
    result: FLTMapInterfaces.Result<String>
  ) {
    mapboxMap.getStyle {
      val expected = it.getStyleSourceProperties(sourceId)
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(expected.value!!.toJson())
      }
    }
  }

  override fun setStyleSourceProperties(
    sourceId: String,
    properties: String,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      val expected = it.setStyleSourceProperties(sourceId, properties.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun updateStyleImageSourceImage(
    sourceId: String,
    image: FLTMapInterfaces.MbxImage,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      var bitmap = BitmapFactory.decodeByteArray(
        image.data,
        0,
        image.data.size
      )
      if (bitmap.config != Bitmap.Config.ARGB_8888) {
        bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, false)
      }
      val byteBuffer = ByteBuffer.allocate(bitmap.byteCount)
      bitmap.copyPixelsToBuffer(byteBuffer)

      val expected = it.updateStyleImageSourceImage(
        sourceId,
        Image(
          image.width.toInt(),
          image.height.toInt(), byteBuffer.array()
        )
      )
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun removeStyleSource(sourceId: String, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      val expected = it.removeStyleSource(sourceId)
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun styleSourceExists(sourceId: String, result: FLTMapInterfaces.Result<Boolean>) {
    mapboxMap.getStyle {
      val expected = it.styleSourceExists(sourceId)
      result.success(expected)
    }
  }

  override fun getStyleSources(result: FLTMapInterfaces.Result<MutableList<FLTMapInterfaces.StyleObjectInfo>>) {
    mapboxMap.getStyle {
      result.success(
        it.styleSources.map {
          FLTMapInterfaces.StyleObjectInfo.Builder().setId(it.id).setType(it.type).build()
        }.toMutableList()
      )
    }
  }

  override fun setStyleLight(properties: String, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      val expected = it.setStyleLight(properties.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun getStyleLightProperty(
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    mapboxMap.getStyle {
      val styleLightProperty = it.getStyleLightProperty(property)
      result.success(
        FLTMapInterfaces.StylePropertyValue.Builder()
          .setKind(
            FLTMapInterfaces.StylePropertyValueKind.values()[styleLightProperty.kind.ordinal]
          )
          .setValue(styleLightProperty.value.toString()).build()
      )
    }
  }

  override fun setStyleLightProperty(id: String, value: Any, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      val expected = it.setStyleLightProperty(id, value.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun setStyleTerrain(properties: String, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      val expected = it.setStyleTerrain(properties.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun getStyleTerrainProperty(
    property: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.StylePropertyValue>
  ) {
    mapboxMap.getStyle {
      val styleProperty = it.getStyleTerrainProperty(property)
      val stylePropertyValueKind =
        FLTMapInterfaces.StylePropertyValueKind.values()[styleProperty.kind.ordinal]
      val stylePropertyValue =
        FLTMapInterfaces.StylePropertyValue.Builder().setValue(styleProperty.value.toString())
          .setKind(stylePropertyValueKind).build()
      result.success(stylePropertyValue)
    }
  }

  override fun setStyleTerrainProperty(
    property: String,
    value: Any,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      val expected = it.setStyleTerrainProperty(property, value.toValue())
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun getStyleImage(
    imageId: String,
    result: FLTMapInterfaces.Result<FLTMapInterfaces.MbxImage>
  ) {
    mapboxMap.getStyle {
      it.getStyleImage(imageId)?.let { image ->
        result.success(
          FLTMapInterfaces.MbxImage.Builder().setWidth(image.width.toLong()).setHeight(
            image.height.toLong()
          ).setData(image.data).build()
        )
      }
      result.success(null)
    }
  }

  override fun removeStyleImage(imageId: String, result: FLTMapInterfaces.Result<Void?>) {
    mapboxMap.getStyle {
      val expected = it.removeStyleImage(imageId)
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun hasStyleImage(imageId: String, result: FLTMapInterfaces.Result<Boolean>) {
    mapboxMap.getStyle {
      result.success(it.hasStyleImage(imageId))
    }
  }

//    override fun setStyleCustomGeometrySourceTileData(
//        sourceId: String,
//        tileId: FLTMapInterfaces.CanonicalTileID,
//        featureCollection: String,
//        result: FLTMapInterfaces.Result<Void>
//    ) {
//        mapboxMap.getStyle { style ->
//            val canonicalTileID = CanonicalTileID(
//                tileId.z.toByte(), tileId.x.toInt(),
//                tileId.y.toInt()
//            )
//            FeatureCollection.fromJson(featureCollection).features()?.let {
//                val expected = style.setStyleCustomGeometrySourceTileData(
//                    sourceId,
//                    tileId = canonicalTileID,
//                    it
//                )
//                if (expected.isError) {
//                    result.error(Throwable(expected.error))
//                } else {
//                    result.success(null)
//                }
//            }
//            result.error(Throwable("Features are null."))
//        }
//    }

  override fun invalidateStyleCustomGeometrySourceTile(
    sourceId: String,
    tileId: FLTMapInterfaces.CanonicalTileID,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      val expected = it.invalidateStyleCustomGeometrySourceTile(
        sourceId,
        CanonicalTileID(
          tileId.z.toByte(), tileId.x.toInt(), tileId.y.toInt()
        )
      )
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
    }
  }

  override fun invalidateStyleCustomGeometrySourceRegion(
    sourceId: String,
    bounds: FLTMapInterfaces.CoordinateBounds,
    result: FLTMapInterfaces.Result<Void>?
  ) {
    mapboxMap.getStyle { style ->
      style.invalidateStyleCustomGeometrySourceRegion(
        sourceId,
        coordinateBounds = bounds.toCoordinateBounds()
      )
      result?.success(null)
    }
  }

  override fun isStyleLoaded(result: FLTMapInterfaces.Result<Boolean>) {
    mapboxMap.getStyle {
      result.success(it.isStyleLoaded)
    }
  }

  override fun getProjection(result: FLTMapInterfaces.Result<String>) {
    mapboxMap.getStyle {
      result.success(it.getProjection().name.value)
    }
  }

  override fun setProjection(projection: String, result: FLTMapInterfaces.Result<Void>) {
    mapboxMap.getStyle {
      when (projection) {
        ProjectionName.GLOBE.value -> it.setProjection(Projection(ProjectionName.GLOBE))
        ProjectionName.MERCATOR.value -> it.setProjection(Projection(ProjectionName.MERCATOR))
        else -> {
          result.error(Throwable("Invalid projection $projection"))
        }
      }
      result.success(null)
    }
  }

  override fun localizeLabels(
    locale: String,
    layerIds: MutableList<String>?,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      it.localizeLabels(Locale(locale), layerIds)
      result.success(null)
    }
  }

  override fun addStyleImage(
    imageId: String,
    scale: Double,
    image: FLTMapInterfaces.MbxImage,
    sdf: Boolean,
    stretchX: MutableList<FLTMapInterfaces.ImageStretches>,
    stretchY: MutableList<FLTMapInterfaces.ImageStretches>,
    content: FLTMapInterfaces.ImageContent?,
    result: FLTMapInterfaces.Result<Void>
  ) {
    mapboxMap.getStyle {
      var bitmap = BitmapFactory.decodeByteArray(
        image.data,
        0,
        image.data.size
      )
      if (bitmap.config != Bitmap.Config.ARGB_8888) {
        bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, false)
      }
      val byteBuffer = ByteBuffer.allocate(bitmap.byteCount)
      bitmap.copyPixelsToBuffer(byteBuffer)
      val expected = it.addStyleImage(
        imageId, scale.toFloat(),
        Image(
          image.width.toInt(),
          image.height.toInt(), byteBuffer.array()
        ),
        sdf,
        stretchX.map {
          ImageStretches(
            it.first.toFloat(),
            it.second.toFloat()
          )
        },
        stretchY.map { ImageStretches(it.first.toFloat(), it.second.toFloat()) },
        if (content != null) ImageContent(
          content.left.toFloat(),
          content.top.toFloat(), content.right.toFloat(), content.bottom.toFloat()
        ) else null
      )
      if (expected.isError) {
        result.error(Throwable(expected.error))
      } else {
        result.success(null)
      }
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
    Logger.e(
      "StyleController",
      "Can not map value, type is not supported: ${this::class.java.canonicalName}"
    )
    Value.valueOf("")
  }
}