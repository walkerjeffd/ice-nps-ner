DROP TABLE IF EXISTS data.nps_catchments;

CREATE TABLE data.nps_catchments AS (
  SELECT n.unit_code, c.featureid
  FROM (select * from gis.nps) n, gis.catchments c
  WHERE ST_Intersects(n.geom, c.geom)
);
