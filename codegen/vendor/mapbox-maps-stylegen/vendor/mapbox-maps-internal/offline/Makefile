RESOURCES=src/test/resources

# Bounding box for `washingtondc.geojson`.
WDC_NORTH=38.995968036509325
WDC_SOUTH=38.79164435125454
WDC_WEST=-77.1197952245159
WDC_EAST=-76.90914996169623

download-schema:
	wget https://raw.githubusercontent.com/mapbox/mapbox-gl-native/master/platform/default/include/mbgl/storage/offline_schema.sql \
		-O src/main/sqldelight/com/mapbox/maps/offline/offline.sq

#
# Run it including the path to the `mbgl-offline` binary
#
#   $ MBGL_OFFLINE=/path/to/mbgl-offline make test-resources
#

test-resources:
	# Clean up
	rm $(RESOURCES)/test-*.db

	# WDC (bounding box)
	$(MBGL_OFFLINE) --token=$(MAPBOX_ACCESS_TOKEN) \
                    --style=mapbox://styles/mapbox/streets-v11 \
                    --output=$(RESOURCES)/test-streets-bbox.db \
                    --north=$(WDC_NORTH) --west=$(WDC_WEST) --south=$(WDC_SOUTH) --east=$(WDC_EAST) \
                    --minZoom=10 --maxZoom=15 \
                    --pixelRatio=1 \
                    --includeIdeographs=1

	# WDC (geometry)
	$(MBGL_OFFLINE) --token=$(MAPBOX_ACCESS_TOKEN) \
                    --style=mapbox://styles/mapbox/streets-v11 \
                    --output=$(RESOURCES)/test-streets-geo.db \
                    --geojson=$(RESOURCES)/washingtondc.geojson \
                    --minZoom=10 --maxZoom=15 \
                    --pixelRatio=1 \
                    --includeIdeographs=1

build-jar:
	./gradlew shadowJar
	cp build/libs/offline.jar ..
