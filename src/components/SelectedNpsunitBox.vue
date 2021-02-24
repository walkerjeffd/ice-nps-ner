<template>
  <div>
    <div class="ice-info-box text-right">
      <div class="ice-info-box-title text-left">
        <strong>Selected Park:</strong> {{ selected.properties.label }} ({{ selected.id }})
      </div>

      <div class="ice-info-box-body">
        <button class="btn btn-default btn-xs" @click="showData = true">
          <i class="fa fa-table"></i> Data
        </button>
        <button class="btn btn-default btn-xs" @click="zoomTo">
          <i class="fa fa-search-plus"></i> Zoom To
        </button>
        <!-- <button class="btn btn-default btn-xs" @click="showCatchments">
          <i class="fa fa-plus-circle"></i> Catchments
        </button> -->
        <button class="btn btn-default btn-xs" @click="unselect">
          <i class="fa fa-times-circle"></i> Unselect
        </button>
      </div>
    </div>
    <ice-modal :show="showData" @close="showData = false">
      <span slot="title"><strong>Park Unit: {{ selected.properties.label }} ({{ selected.id }})</strong></span>
      <div slot="body">
        <p>This table lists the area-weighted mean value of all catchments that intersect this park unit.</p>
        <p>
          <strong>Total # Catchments</strong>: {{ selected.properties.n.toLocaleString() }}<br>
          <strong># Catchments Excluded From Models</strong>: {{ selected.properties.n_nodata.toLocaleString() }} ({{ selected.properties.n > 0 ? percentFormat(selected.properties.n_nodata / selected.properties.n) : 'N/A' }})

        </p>
        <table class="table table-condensed table-striped" v-if="dataRows.length > 0">
          <thead>
            <th>Variable</th>
            <th>Value</th>
          </thead>
          <tbody>
            <tr v-for="row in dataRows" :key="row.id">
              <td>{{row.label}}</td>
              <td>{{row.formattedValue}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </ice-modal>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import * as d3 from 'd3'

// import { xf } from '@/libs/IceCrossfilter'
import IceModal from '@/components/IceModal'

export default {
  components: { IceModal },
  props: ['selected'],
  data () {
    return {
      showData: false,
      dataRows: []
    }
  },
  computed: {
    ...mapGetters(['variables', 'theme'])
  },
  watch: {
    showData () {
      let rows = []
      if (this.showData) {
        rows = this.variables
          .filter(d => d.map || d.filter)
          .map(d => {
            const value = this.selected.properties[d.id]
            const formatter = d3.format(d.formats.value)
            return {
              id: d.id,
              label: d.label,
              format: d.formats.value,
              value,
              formattedValue: formatter(value)
            }
          })
      }

      this.dataRows = rows
    }
  },
  filters: {
  },
  methods: {
    unselect () {
      this.$emit('unselect')
    },
    zoomTo () {
      this.$emit('zoomTo', this.selected)
    },
    showCatchments () {
      // console.log('info:showCatchments')
      this.$emit('showCatchments', this.selected)
    },
    percentFormat (value) {
      return d3.format('.1%')(value)
    }
  }
}
</script>

<style>
.ice-info-box {
  padding: 5px 5px;
  margin: 10px 0;
  background: #fff;
  font-size: 12px;
  border-radius: 5px;
  box-shadow: 0 1px 5px rgba(0,0,0,0.4);
  z-index: 3000;
}

.ice-info-box-title {
  font-size: 1.2em;
}

.ice-info-box-body {
  width: 100%;
  margin-top: 5px;
}
</style>
