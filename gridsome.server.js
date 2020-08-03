const skippable = require("./gridsome.config.js").skipOnMeta
const config = require("./gridsome.config.js")

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
