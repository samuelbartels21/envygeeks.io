const config = require("./gridsome.config.js")
const skippable = require("./gridsome.config.js").skipOnMeta
const join = require("path").join

module.exports = function(api) {
  api.loadSource(store => {
    Object.keys(config).forEach(k => {
      if (!skippable.includes(k)) {
        store.addMetadata(k,
          config[k]
        )
      }
    })
  })
}
