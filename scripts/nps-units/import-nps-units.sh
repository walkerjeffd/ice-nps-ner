#!/bin/bash

FILE=/Users/jeff/Dropbox/SHEDS/nps-ner/gis/NER_NPS_Units/NER_NPS_Units.shp

# ogr2ogr -f "ESRI Shapefile" $FILE_WGS $FILE -s_srs EPSG:5070 -t_srs EPSG:4326 -fieldTypeToString real
shp2pgsql -s 4269:4326 -g geom -d -I -t 2D $FILE gis.nps | psql -h trout.local -d sheds -q
