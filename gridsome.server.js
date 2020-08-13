const graphql_metadata = require("./plugins/graphql_metadata")
module.exports = function(api) {
  api.loadSource(store => {
    graphql_metadata(
      store
    )
  })
}
