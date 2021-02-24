<template>
  <div>
    <h3>Overview</h3>

    <div class="row">
      <div class="col-md-12">
        <p>
          <strong>Coldwater Refugia in the Northeast</strong> was built using the <a href="http://ice.ecosheds.org/">Interactive Catchment Explorer (ICE)</a>, which is a data visualization framework for exploring large and complex environmental datasets and model outputs.
        </p>
      </div>
    </div>

    <hr>

    <h3>Dataset Options</h3>
    <div class="row">
      <div class="col-md-12">
        <p>
          The dataset being shown on the map is controlled by three sets of options, which are configured using dropdown menus.
        </p>
        <p>
          The <code>Resolution</code> option determines the set of HUC* basins that are used to spatially aggregate the individual catchments (see Spatial Aggregation below).
          Higher values correspond to the higher resolutions (HUC6 is the lowest resolution, HUC12 is the highest).
          Due to the large number of HUC12 basins across the North Atlantic, this resolution is divided into 2-digit HUC sub-regions, only one of which can be viewed at a time (see <a href="https://commons.wikimedia.org/wiki/File:Huc_region-edit.png" target="_blank">HUC2 map</a>).
        </p>
        <p>
          The <code>Park Unit</code> option allows you to select a National Park Unit to focus on. When a park unit is selected, the map will automatically zoom to that location.
        </p>
        <p>
          The <code>Variable</code> option determines which variable is spatially aggregated and used to color-code each HUC.
          When this variable is changed, the legend will automatically update to reflect the range of values for the selected variable.
        </p>
        <p style="font-style:italic">
          * HUC stands for <a href="https://en.wikipedia.org/wiki/Hydrological_code" target="_blank">Hydrologic Unit Code</a>, which is a hierarchical drainage basin classification system <a href="https://water.usgs.gov/GIS/huc.html" target="_blank">developed by the USGS and USDA-NRCS</a> commonly used for identifying distinct watersheds across the U.S.
        </p>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12 text-center">
        <img
          src="../assets/img/guide/map-options.png"
          alt="Map options"
          class="img-rounded"
          style="margin-top:10px">
      </div>
    </div>

    <hr>

    <h3>Map Controls and Layers</h3>
    <p>
      The map provides a basemap (satellite or street map) and one or more static layers (streams, waterbodies, HUC boundaries).
      On top of the basemap and static layers is an interactive layer containing HUC basins for the selected resolution (e.g. HUC8, HUC10, etc.).
    </p>

    <h4>Map Controls</h4>
    <div class="row">
      <div class="col-md-12">
        <img
          src="../assets/img/guide/map-controls.png"
          alt="Map Controls"
          class="img-rounded pull-right">
        <p>
          Use the map controls to zoom in and out, adjust the transparency of the HUCs, and switch basemaps or show/hide individual static layers.
        </p>
        <p>
          <i class="fa fa-exclamation-triangle" style="color:orange"></i> <i>The static layers (e.g. streams) are tiled images, and therefore not interactive (i.e., you cannot click on a stream to see more info).</i>
        </p>
      </div>
    </div>

    <h4>HUC Basin Layer</h4>
    <div class="row">
      <div class="col-md-12">
        <div class="pull-right">
          <img
            src="../assets/img/guide/huc-hover.png"
            alt="Hover to View HUC Info"
            class="img-rounded">
          <br>
          <img
            src="../assets/img/guide/huc-click.png"
            alt="Click to Select a HUC"
            class="img-rounded"
            style="margin-top:10px">
        </div>
        <p>
          The HUC basin layer shows the drainage areas for the selected resolution (see Dataset Options above).
        </p>
        <p>
          The color of each HUC represents the average value of the selected variable among all catchments within that HUC (see Spatial Aggregation below).
        </p>
        <p>
          <strong>Hover</strong> your mouse over a HUC to view its ID, name, and value for the selected variable.
        </p>
        <p>
          <strong>Click</strong> to select a HUC.
          This will open a new toolbar showing the name and ID of the selected HUC, and provide additional tools to view the <code>Data</code> for all variables, <code>Zoom To</code>, view <code>Catchments</code> within, or <code>Unselect</code> that HUC.
        </p>
      </div>
    </div>

    <hr>

    <h3>Color Legend</h3>

    <p>The legend shows the color scale corresponding to the range of values for the selected variable.</p>
    <p>
      Click the <code>Legend Options</code> link to open addition controls.
      The <code>Colors</code> menu provides alternative color scales.
      The <code>Transform</code> menu provides alternative variable transformations (i.e., linear or log).
      The logarithmic transformation can be useful for variables that exhibit a highly skewed distribution.
    </p>

    <img
      src="../assets/img/guide/legend.png"
      alt="Legend options"
      class="img-rounded"
      style="margin-top:10px">
    <hr>

    <h3>Spatial Aggregation</h3>
    <div class="row">
      <div class="col-md-12">
        <img
          src="../assets/img/guide/aggregation.png"
          alt="Spatial Aggregation"
          class="img-rounded pull-right">
        <p>
          One of the primary goals of ICE is to allow users to explore large geospatial datasets.
          With nearly 400,000 catchments across the North Atlantic region, it would not be possible to provide an interactive layer with all of the catchments due to the memory and processing power required.
          To solve this problem, ICE spatially aggregates the individual catchments to larger HUC basins.
          This aggregation yields a smaller dataset (i.e., fewer polygons) that can be more efficiently displayed as an interactive layer on the map.
        </p>
        <p>
          The spatial aggregation can be performed at varying HUC resolutions by changing the <code>Resolution</code> (see Dataset Options section above).
          By changing this resolution, users can compare patterns at varying spatial scales ranging from the local sub-basins (HUC12s) within a sub-region to the major drainage basins (HUC6s) across the entire North Atlantic region.
        </p>
        <p>
          Catchments are spatially aggregated using the <strong>area-weighted mean</strong>.
          The value for each HUC is the calculated using the mean of the  catchments within that HUC and weighted by catchment area.
          The area-weighted mean thus corrects for differences in the areas of the individual catchments within each HUC.
          For example, if the selected variable is Elevation (m), then the color of each HUC reflects the area-weighted mean elevation of the catchments within it.
        </p>
      </div>
    </div>

    <hr>

    <h3>Downloading Data</h3>

    <p>
      The datasets displayed in ICE can be downloaded by clicking the Download button on the main toolbar.
    </p>

    <p>
      Datasets can be downloaded in two types of file formats:
    </p>
    <ul>
      <li>
        <strong>Comma-Separate Value (CSV)</strong>: a text file containing a table of values.
        Each row repesents one geographic feature (e.g. a HUC or catchment), and each column represents an ID or variable.
        The CSV files <strong>do not</strong> include the geospatial properties (e.g. polygon) of each feature.
        CSV files can be viewed and analyzed using Excel or any other common data analysis program.
      </li>
      <li>
        <strong>GeoJSON</strong>: a text file in JSON format, which contains both an attribute table as well as the geospatial properties of each feature (i.e., the polygons).
        This file format is similar to a shapefile, but is more commonly used for web applications due to complexities of the shapefile format (e.g. each shapefile is a combination of multiple).
        GeoJSON files can be loaded directly into desktop GIS software (QGIS, or ArcGIS), or can be converted to shapefiles using the <a href="https://mygeodata.cloud/converter/geojson-to-shp" target="_blank">MyGeodata Converter</a>.
      </li>
    </ul>

    <p>The datasets that are available to download include:</p>
    <ul>
      <li>
        <strong>HUC Layer</strong>: the current set of HUC basins shown on the map including the ID, name, and area-weighted mean value of the selected variable.
        The GeoJSON format of this file will let you re-create the current map shown in ICE using desktop GIS software.
      </li>
      <li>
        <strong>Catchments Layer (Selected HUC Only)</strong>: when a HUC is selected, these files contain the data for the catchments within that HUC.
        In order to download the geospatial file (GeoJSON format), you must load the catchments for the HUC into ICE by clicking the Catchments button on the Selected HUC toolbar.
      </li>
      <li>
        <strong>Catchments Layer (Entire Region)</strong>: the entire dataset for the region is provided as a CSV file.
        Due to the large number of catchments, the geospatial files are provided as a series of shapefiles pre-staged by 2-digit HUC regions. The CSV files can be joined to the shapefiles using the
        <code>id</code> column of the CSV file and the <code>featureid</code> column of the shapefile.
      </li>
    </ul>
  </div>
</template>

<style scoped>
img {
  margin-left: 20px;
  margin-bottom: 10px;
}
</style>
