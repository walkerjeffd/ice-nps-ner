const webpack = require('webpack') // eslint-disable-line import/no-extraneous-dependencies

module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/apps/ecosheds/ice-nps-ner/'
    : '/',
  chainWebpack: config => config.resolve.symlinks(false),
  configureWebpack: {
    plugins: [
      new webpack.ProvidePlugin({
        L: 'leaflet',
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery'
      })
    ]
  }
}
