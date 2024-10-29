<template>
  <div class="ice-map">
    <slot v-if="ready"></slot>
  </div>
</template>

<script>
import * as d3 from 'd3'
import '../libs/controlTransparency'
import 'leaflet/dist/leaflet.css'

import evt from '@/events'

export default {
  props: {
    options: {
      type: Object,
      required: true
    },
    features: {
      type: Object,
      required: false
    },
    selected: {
      type: Object,
      required: false
    }
  },
  data () {
    return {
      ready: false,
      map: null,
      disableClick: false,
      bounds: null,
      zoomLevel: null,
      layer: null
    }
  },
  mounted () {
    this.map = L.map(this.$el, {
      ...this.options
    })
    this.zoomLevel = this.map.getZoom()

    L.control.scale({ position: 'bottomleft' }).addTo(this.map)

    const basemaps = {
      'ESRI World Imagery': L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
        attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
      }).addTo(this.map),
      'USGS Imagery': L.tileLayer('https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}', {
        attribution: '<a href="http://www.doi.gov">U.S. Department of the Interior</a> | <a href="http://www.usgs.gov">U.S. Geological Survey</a> | <a href="http://www.usgs.gov/laws/policies_notices.html">Policies</a>',
        maxZoom: 16
      }),
      'USGS Topo': L.tileLayer('https://basemap.nationalmap.gov/ArcGIS/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}', {
        attribution: '<a href="http://www.doi.gov">U.S. Department of the Interior</a> | <a href="http://www.usgs.gov">U.S. Geological Survey</a> | <a href="http://www.usgs.gov/laws/policies_notices.html">Policies</a>',
        maxZoom: 16
      }),
      'USGS Hydrography': L.tileLayer('https://basemap.nationalmap.gov/arcgis/rest/services/USGSHydroCached/MapServer/tile/{z}/{y}/{x}', {
        attribution: '<a href="http://www.doi.gov">U.S. Department of the Interior</a> | <a href="http://www.usgs.gov">U.S. Geological Survey</a> | <a href="http://www.usgs.gov/laws/policies_notices.html">Policies</a>',
        maxZoom: 16
      }),
      'Open Street Map': L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '&copy <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
      }),
      'No Basemap': L.tileLayer('')
    }

    this.layer = L.geoJson(null, {
      style: (feature) => ({
        stroke: true,
        color: '#FF0000',
        weight: 1,
        fill: true,
        opacity: 0.8,
        fillColor: '#FF0000',
        fillOpacity: 0.05
      })
    }).addTo(this.map)

    L.control.transparency({ position: 'topleft' }).addTo(this.map)

    L.control.layers(basemaps, {}, {
      position: 'topleft',
      collapsed: true
    }).addTo(this.map)

    const svg = d3.select(this.map.getPanes().overlayPane).append('svg')
    svg.append('g').attr('class', 'leaflet-zoom-hide')

    let moveTimeout
    this.map.on('movestart', () => {
      window.clearTimeout(moveTimeout)
      this.disableClick = true
    })
    this.map.on('moveend', () => {
      moveTimeout = setTimeout(() => {
        this.disableClick = false
      }, 100)
    })
    this.map.on('zoomend', () => {
      this.zoomLevel = this.map.getZoom()
      evt.$emit('map:zoom')
    })

    this.$on('resize', this.resize)
    evt.$on('map:zoomTo', this.zoomTo)

    this.updateLayer()

    this.ready = true
  },
  beforeDestroy () {
    evt.$off('map:zoomTo', this.zoomTo)
    this.layer.clearLayers()
  },
  computed: {
    svg () {
      return d3.select(this.map.getPanes().overlayPane).select('svg')
    }
  },
  watch: {
    features () {
      this.updateLayer()
    },
    selected () {
      this.styleLayer()
    }
  },
  methods: {
    styleLayer () {
      if (!this.layer || this.layer.getLayers().length === 0) return

      this.layer.resetStyle()

      if (!this.selected) return

      this.layer.eachLayer(layer => {
        if (layer.feature.id === this.selected.id) {
          layer.setStyle({
            color: '#FF0000',
            weight: 2,
            opacity: 1,
            fillColor: '#FF0000',
            fillOpacity: 0.25
          })
        }
      })
    },
    updateLayer () {
      if (this.features) {
        this.layer.addData(this.features)
          .bindTooltip(function (layer) {
            return `<strong>${layer.feature.properties.label}</strong><br>Unit Code: ${layer.feature.id}`
          })
          .on('click', (ev) => {
            if (ev.layer.feature === this.selected) {
              return this.$emit('select', null)
            }
            this.$emit('select', ev.layer.feature)
          })
        this.styleLayer()
      }
    },
    resize (bounds) {
      if (bounds) this.bounds = bounds

      const topLeft = this.bounds[0]
      const bottomRight = this.bounds[1]

      this.svg.attr('width', bottomRight[0] - topLeft[0])
        .attr('height', bottomRight[1] - topLeft[1])
        .style('left', `${topLeft[0]}px`)
        .style('top', `${topLeft[1]}px`)

      this.svg.select('g')
        .attr('transform', `translate(${-topLeft[0]},${-topLeft[1]})`)
    },
    zoomTo (feature) {
      if (!feature) return

      this.map.fitBounds(L.geoJson(feature).getBounds())
    }
  }
}
</script>

<style>
.ice-map {
  width: 100%;
  height: 100%;
}

div.leaflet-top.leaflet-left {
  margin-left: 450px;
  margin-top: 60px;
}

.leaflet-touch .leaflet-control-layers-toggle {
  width: 30px !important;
  height: 30px !important;
}

.ice-control-transparency {
  width: 34px;
  text-align: center;
  padding-top: 10px;
  padding-bottom: 5px;
  background: #fff;
  border-radius: 5px;
  box-shadow: 0 1px 5px rgba(0,0,0,0.4);
}

.ice-control-transparency-slider {
  height: 100px;
  display: inline-block;
}
</style>
