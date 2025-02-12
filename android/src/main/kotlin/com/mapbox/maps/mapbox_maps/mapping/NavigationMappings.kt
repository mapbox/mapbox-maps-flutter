package com.mapbox.maps.mapbox_maps.mapping

import com.mapbox.common.location.Location
import com.mapbox.maps.mapbox_maps.pigeons.NavigationLocation
import com.mapbox.maps.mapbox_maps.pigeons.RouteProgress as NavigationRouteProgress
import com.mapbox.maps.mapbox_maps.pigeons.RouteProgressState as NavigationRouteProgressState
import com.mapbox.maps.mapbox_maps.pigeons.UpcomingRoadObject as NavigationUpcomingRoadObject
import com.mapbox.maps.mapbox_maps.pigeons.RoadObject as NavigationRoadObject
import com.mapbox.maps.mapbox_maps.pigeons.RoadObjectLocationType as NavigationRoadObjectLocationType
import com.mapbox.maps.mapbox_maps.pigeons.RoadObjectDistanceInfo as NavigationRoadObjectDistanceInfo
import com.mapbox.navigation.base.trip.model.RouteProgress
import com.mapbox.navigation.base.trip.model.roadobject.RoadObject
import com.mapbox.navigation.base.trip.model.roadobject.UpcomingRoadObject
import com.mapbox.navigation.base.trip.model.roadobject.distanceinfo.RoadObjectDistanceInfo

fun Location.toFLT(): NavigationLocation {
  return NavigationLocation(
    verticalAccuracy = this.verticalAccuracy,
    horizontalAccuracy = this.horizontalAccuracy,
    monotonicTimestamp = this.monotonicTimestamp,
    longitude = this.longitude,
    bearingAccuracy = this.bearingAccuracy,
    timestamp = this.timestamp,
    speedAccuracy = this.speedAccuracy,
    floor = this.floor,
    speed = this.speed,
    source = this.source,
    altitude = this.altitude,
    latitude = this.latitude,
    bearing = this.bearing
  )
}

fun android.location.Location.toFLT(): NavigationLocation {
  return NavigationLocation(
    longitude = this.longitude,
    altitude = this.altitude,
    latitude = this.latitude
  )
}

fun RoadObject.toFLT(): NavigationRoadObject {
  return NavigationRoadObject(
    id = this.id,
    objectType = NavigationRoadObjectLocationType.ofRaw(this.objectType),
    length = this.length,
    provider = this.provider,
    isUrban = this.isUrban
  )
}

fun RoadObjectDistanceInfo.toFLT(): NavigationRoadObjectDistanceInfo {
  return NavigationRoadObjectDistanceInfo(
    distanceToStart = this.distanceToStart
  )
}

fun UpcomingRoadObject.toFLT(): NavigationUpcomingRoadObject {
  return NavigationUpcomingRoadObject(
    roadObject = this.roadObject.toFLT(),
    distanceToStart = this.distanceToStart,
    distanceInfo = this.distanceInfo?.toFLT()
  )
}

fun RouteProgress.toFLT(): NavigationRouteProgress {
  return NavigationRouteProgress(
    bannerInstructionsJson = this.bannerInstructions?.toJson(),
    voiceInstructionsJson = this.voiceInstructions?.toJson(),
    currentState = this.currentState.name.let { NavigationRouteProgressState.valueOf(it) },
    inTunnel = this.inTunnel,
    distanceRemaining = this.distanceRemaining.toDouble(),
    distanceTraveled = this.distanceTraveled.toDouble(),
    durationRemaining = this.durationRemaining.toDouble(),
    fractionTraveled = this.fractionTraveled.toDouble(),
    remainingWaypoints = this.remainingWaypoints.toLong(),
    upcomingRoadObjects = this.upcomingRoadObjects.map { it.toFLT() },
    stale = this.stale,
    routeAlternativeId = this.routeAlternativeId,
    currentRouteGeometryIndex = this.currentRouteGeometryIndex.toLong(),
  )
}