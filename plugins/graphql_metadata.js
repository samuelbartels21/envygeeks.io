const file = "../gridsome.config.js"
const skippableMeta = require(file).skipOnMeta
const config = require(file)

module.exports = (store) => {
  Object.keys(config).forEach(k => {
    if (!skippableMeta.includes(k)) {
      store.addMetadata(k,
        config[k]
      )
    }
  })
}
