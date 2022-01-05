#!/bin/bash
# import nps units layer to postgres database
# usage: ./import-nps-units.shp /path/to/shp

# ogr2ogr -f "ESRI Shapefile" $FILE_WGS $FILE -s_srs EPSG:5070 -t_srs EPSG:4326 -fieldTypeToString real
shp2pgsql -s 4269:4326 -g geom -d -I -t 2D $1 gis.nps | psql -h ecosheds.org -p 5433 -d sheds -q
