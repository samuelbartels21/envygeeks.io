config = require("./gridsome.config.js");

/**
 * Learn more:
 * https://gridsome.org/docs/server-api
 */
module.exports = function(api) {
  api.loadSource(store => {
    Object.keys(config).forEach(k => {
      if (!config.skipOnMeta.includes(k)) {
        store.addMetaData(k,
          config[k]
        );
      }
    })
  })
}
