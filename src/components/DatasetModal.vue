<template>
  <div>
    <h4>Catchment Characteristics</h4>

    <ul>
      <li>
        <a href="http://conte-ecology.github.io/shedsGisData/#the-national-hydrography-dataset-high-resolution-delineation-version-2-nhdhrdv2" target="_blank">SHEDS National Hydrography Dataset High Resolution Delineation V2 (NHDHRDV2)</a>
      </li>
      <li>
        <a href="http://conte-ecology.github.io/shedsGisData/#basin-characteristics" target="_blank">SHEDS Basin Characteristics Dataset</a>
      </li>
    </ul>

    <table class="table table-condensed table-striped">
      <thead>
        <th>Variable</th>
        <th>Description</th>
        <th>Source</th>
      </thead>
      <tbody>
        <tr>
          <td>Drainage Area (km2)</td>
          <td>Total (cumulative) drainage area of each catchment</td>
          <td>SHEDS Delineation (NHDHRDV2)</td>
        </tr>
        <tr>
          <td>Elevation (m)</td>
          <td>Average elevation of each catchment</td>
          <td>National Elevation Dataset (NED)</td>
        </tr>
        <tr>
          <td>Agriculture Cover (%)</td>
          <td>Percent of agriculture land use within catchment</td>
          <td>National Land Cover Database</td>
        </tr>
        <tr>
          <td>Forest Cover (%)</td>
          <td>Percent of forest cover within catchment</td>
          <td>National Land Cover Database</td>
        </tr>
        <tr>
          <td>Summer Precip. (mm/mon)</td>
          <td>Average summer (Jun-Aug) precipitation within catchment</td>
          <td>PRISM Climate Group</td>
        </tr>
      </tbody>
    </table>

    <hr>

    <h4>Stream Temperature Model</h4>
    <ul>
      <li><a href="https://ecosheds.github.io/northeast-temp-model/" target="_blank">SHEDS Stream Temperature Model (v1.2.0)</a></li>
    </ul>
    <table class="table table-condensed table-striped">
      <thead>
        <th>Variable</th>
        <th>Description</th>
      </thead>
      <tbody>
        <tr>
          <td>Mean Summer Temp. (degC)</td>
          <td>Predicted mean summer (Jun-Aug) stream temperature at catchment outlet</td>
        </tr>
        <tr>
          <td># Days/Year Temp. &gt; 22 degC</td>
          <td>Frequency (days per year) with predicted mean daily stream temp &gt; 22 degC at catchment outlet</td>
        </tr>
        <tr>
          <td>Coldwater Refugia</td>
          <td>Value is 1 if (# Days/Year Temp. &gt; 22 degC) &lt; 1, otherwise 0</td>
        </tr>
      </tbody>
    </table>

    <hr>

    <h4>Brook Trout Occupancy Model</h4>
    <ul>
      <li><a href="https://ecosheds.github.io/northeast-bto-model/" target="_blank">SHEDS Brook Trout Occupancy Model (v1.3.0)</a></li>
    </ul>
    <table class="table table-condensed table-striped">
      <thead>
        <th>Variable</th>
        <th>Description</th>
      </thead>
      <tbody>
        <tr>
          <td>Current Occupancy Prob.</td>
          <td>Predicted probability of Brook Trout occupancy within catchment</td>
        </tr>
        <tr>
          <td>Max Air Temp Increase for 30% Occupancy Prob.</td>
          <td>Maximum increase in air temperature yielding a 30% probability of Brook Trout occupancy.</td>
        </tr>
        <tr>
          <td>Max Air Temp Increase for 50% Occupancy Prob.</td>
          <td>Maximum increase in air temperature yielding a 50% probability of Brook Trout occupancy.</td>
        </tr>
        <tr>
          <td>Max Air Temp Increase for 70% Occupancy Prob.</td>
          <td>Maximum increase in air temperature yielding a 70% probability of Brook Trout occupancy.</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
