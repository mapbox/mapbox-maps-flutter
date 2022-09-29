package com.mapbox.maps.offline

import com.fasterxml.jackson.databind.ObjectMapper
import com.mapbox.maps.offline.generated.OfflineDb
import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.sqlite.driver.JdbcSqliteDriver
import org.apache.commons.cli.DefaultParser
import org.apache.commons.cli.HelpFormatter
import org.apache.commons.cli.Options
import kotlin.system.exitProcess

data class OfflineResult(
    val totalRegions: Int,
    val totalResources: Int,
    val resourcesSize: Int,
    val resourcesPercentage: Double,
    val totalTiles: Int,
    val tilesSize: Int,
    val tilesPercentage: Double,
    val totalRegionResources: Int,
    val totalRegionTiles: Int
)

fun getPathFromArgs(args: Array<String>): String? {
    val options = Options()
    options.addOption("path", true, "Path to offline database file.")
    options.addOption("help", false, "Print usage information (this screen).")

    val parser = DefaultParser()
    val cmd = parser.parse(options, args)
    val path = cmd.getOptionValue("path")
    if (cmd.hasOption("help") || path.isNullOrBlank()) {
        val formatter = HelpFormatter()
        formatter.printHelp("offline", options)
    }

    return path
}

fun main(args: Array<String>) {
    // Open DB
    val path = getPathFromArgs(args) ?: exitProcess(0)
    val url = "jdbc:sqlite:$path"
    val driver: SqlDriver = JdbcSqliteDriver(url)
    val db = OfflineDb(driver)

    // Compute values
    val totalRegions = db.basicQueries.selectAllRegions().executeAsList().size
    val resources = db.basicQueries.selectAllResources().executeAsList()
    val tiles = db.basicQueries.selectAllTiles().executeAsList()
    val totalRegionResources = db.basicQueries.selectAllRegionResources().executeAsList().size
    val totalRegionTiles = db.basicQueries.selectAllRegionTiles().executeAsList().size
    val resourcesSize = resources.map { it.data?.size ?: 0 }.sum()
    val tilesSize = tiles.map { it.data?.size ?: 0 }.sum()
    val resourcesPercentage = 100.0 * resourcesSize / (resourcesSize + tilesSize)
    val tilesPercentage = 100.0 * tilesSize / (resourcesSize + tilesSize)

    // Prepare result data
    val result = OfflineResult(
        totalRegions = totalRegions,
        totalResources = resources.size,
        resourcesSize = resourcesSize,
        resourcesPercentage = resourcesPercentage,
        totalTiles = tiles.size,
        tilesSize = tilesSize,
        tilesPercentage = tilesPercentage,
        totalRegionResources = totalRegionResources,
        totalRegionTiles = totalRegionTiles
    )

    // Print pretty JSON
    println(ObjectMapper().writerWithDefaultPrettyPrinter().writeValueAsString(result))
}
