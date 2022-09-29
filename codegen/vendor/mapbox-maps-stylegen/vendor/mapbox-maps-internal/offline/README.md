# Offline reader

This project contains a small utility (`offline.jar`) that helps you verify and obtain information about an offline maps database.

## Build from source

If you just want to use the tool, skip to the next section, the repo contains a pre-compiled version ready for use.

Build steps:

1. The project contains a copy of the offline schema under `src/main/sqldelight/com/mapbox/maps/offline/offline.sq`. If you need to update it, run `make download-schema`. This schema is the same schema used by [Maps Native](https://github.com/mapbox/mapbox-gl-native).

2. Build the executable JAR with `make build-jar`. The resulting file will be copied to the root folder of this repo as `offline.jar`.

## Usage

> Note: You need to install Java in order to run this app. On Debian-based systems like Ubuntu, you can install Java by running `sudo apt-get install default-jre`.

Run `offline.jar` with no arguments, or with `-help` to get usage information:

```
$ java -jar offline.jar -help
usage: offline
 -help         Print usage information (this screen).
 -path <arg>   Path to offline database file.
```

Currently, `offline.jar` only supports one `-path` parameter. Its value should point at an offline maps database (the process to build these databases [is documented here](https://github.com/mapbox/mapbox-gl-native/wiki/Sideloading-offline-maps)).

A sample output of this app looks like the following:

```
$ java -jar offline.jar -path offline/src/test/resources/test-streets-bbox.db 
{
  "totalRegions" : 1,
  "totalResources" : 1030,
  "resourcesSize" : 58900926,
  "resourcesPercentage" : 77.39699623694888,
  "totalTiles" : 687,
  "tilesSize" : 17201415,
  "tilesPercentage" : 22.603003763051127,
  "totalRegionResources" : 1030,
  "totalRegionTiles" : 687
}
```

You can use the output above to confirm a) that the database file is valid, and 2) that it contains both tiles and resources data. The tool will show how much data resources vs tiles represent in a specific database.

## Detecting invalid databases

If the database is in the wrong format (e.g. MBTiles), or it's corrupted, `offline.jar` will present different error messages:

```
$ java -jar offline.jar -path README.md 
Exception in thread "main" org.sqlite.SQLiteException: [SQLITE_NOTADB]  File opened that is not a database file (file is not a database)
```

```
$ java -jar offline.jar -path trails.mbtiles 
Exception in thread "main" org.sqlite.SQLiteException: [SQLITE_ERROR] SQL error or missing database (no such table: regions)
```

### Detecting empty downloads

You can use `offline.jar` to confirm that an offline region was downloaded successfully:

```
$ java -jar offline.jar -path offline/src/test/resources/test-no-tiles.db 
{
  "totalRegions" : 1,
  "totalResources" : 396,
  "resourcesSize" : 5500019,
  "resourcesPercentage" : 100.0,
  "totalTiles" : 0,
  "tilesSize" : 0,
  "tilesPercentage" : 0.0,
  "totalRegionResources" : 396,
  "totalRegionTiles" : 0
}
```

In this case, you can see that although resources were downloaded, no tiles are included in the database.

### Test databases

To recreate the test databases under `offline/src/test/resources/` you need to build `mbgl-offline` separately, and pass it as a parameter to `make`:

```
$ MBGL_OFFLINE=/path/to/mbgl-offline make test-resources
```

You also need to set up a `MAPBOX_ACCESS_TOKEN` environment variable with a valid token.

### Optimizing downloads

The first example above shows a download for Washington, DC using a bounding box (`test-streets-bbox.db`). An immediate optimization would be to use the actual geometry to avoid downloading unnecessary data. This is what we've done with `test-streets-geo.db`:

```
$ java -jar offline.jar -path offline/src/test/resources/test-streets-geo.db 
{
  "totalRegions" : 1,
  "totalResources" : 1030,
  "resourcesSize" : 58900926,
  "resourcesPercentage" : 85.45722290503097,
  "totalTiles" : 348,
  "tilesSize" : 10023530,
  "tilesPercentage" : 14.54277709496902,
  "totalRegionResources" : 1030,
  "totalRegionTiles" : 348
}
```

You can see that though we still need the same number of resources (1030) the number of tiles is considerable lower (348 vs 687). This way we can confirm that, not only the download is valid, tiles represent a smaller percentage of the overall size after optimizing the area definition.  

## Bugs and feature requests

If you find any issues using this tool, or need new functionality, please cut a ticket in this repo and tag @zugaldia.
